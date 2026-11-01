import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/cg_draw.c:23
// Raven wrote: menuDef_t *menuScoreboard = NULL
nonisolated(unsafe) let menuScoreboard: MenuDef? = { () -> MenuDef? in portMissing("menuScoreboard", source: "oracle/codemp/cgame/cg_draw.c:23") }()

/// Source: oracle/codemp/cgame/cg_draw.c:24
// Raven wrote: vec4_t bluehudtint = {0.5, 0.5, 1.0, 1.0}
let bluehudtint: JKAShared.vec4_t = JKAShared.vec4_t(0.5, 0.5, 1.0, 1.0)

/// Source: oracle/codemp/cgame/cg_draw.c:25
// Raven wrote: vec4_t redhudtint = {1.0, 0.5, 0.5, 1.0}
let redhudtint: JKAShared.vec4_t = JKAShared.vec4_t(1.0, 0.5, 0.5, 1.0)

/// Source: oracle/codemp/cgame/cg_draw.c:26
// Raven wrote: float *hudTintColor
var hudTintColor: JKAShared.vec4_t {
    get { world.hudTintColor }
    set { world.hudTintColor = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:28
var sortedTeamPlayers: [Int32] {
    get { world.variables.sortedTeamPlayers }
    set { world.variables.sortedTeamPlayers = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:29
var numSortedTeamPlayers: Int32 {
    get { world.variables.numSortedTeamPlayers }
    set { world.variables.numSortedTeamPlayers = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:31
var lastvalidlockdif: Int32 {
    get { world.variables.lastvalidlockdif }
    set { world.variables.lastvalidlockdif = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:35
// Raven wrote: char systemChat[256]
nonisolated(unsafe) let systemChat: JKAShared.CharBuf = JKAShared.CharBuf(256)

/// Source: oracle/codemp/cgame/cg_draw.c:36
// Raven wrote: char teamChat1[256]
nonisolated(unsafe) let teamChat1: JKAShared.CharBuf = JKAShared.CharBuf(256)

/// Source: oracle/codemp/cgame/cg_draw.c:37
// Raven wrote: char teamChat2[256]
nonisolated(unsafe) let teamChat2: JKAShared.CharBuf = JKAShared.CharBuf(256)

/// Source: oracle/codemp/cgame/cg_draw.c:40
var cg_siegeDeathTime: Int32 {
    get { world.variables.cg_siegeDeathTime }
    set { world.variables.cg_siegeDeathTime = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:42
let MAX_HUD_TICS = 4 as Int32

/// Source: oracle/codemp/cgame/cg_draw.c:43
/// Raven's data table, a hand property of `CGameWorld`.
var armorTicName: [String] { world.armorTicName }

/// Source: oracle/codemp/cgame/cg_draw.c:51
/// Raven's data table, a hand property of `CGameWorld`.
var healthTicName: [String] { world.healthTicName }

/// Source: oracle/codemp/cgame/cg_draw.c:59
/// Raven's data table, a hand property of `CGameWorld`.
var forceTicName: [String] { world.forceTicName }

/// Source: oracle/codemp/cgame/cg_draw.c:67
/// Raven's data table, a hand property of `CGameWorld`.
var ammoTicName: [String] { world.ammoTicName }

/// Source: oracle/codemp/cgame/cg_draw.c:75
/// Raven's data table, a hand property of `CGameWorld`.
var showPowersName: [String?] { world.showPowersName }

/// Source: oracle/codemp/cgame/cg_draw.c:1393
let MAX_SHOWPOWERS = JKAMP.NUM_FORCE_POWERS

/// Source: oracle/codemp/cgame/cg_draw.c:1791
var cg_targVeh: Int32 {
    get { world.variables.cg_targVeh }
    set { world.variables.cg_targVeh = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:1792
var cg_targVehLastTime: Int32 {
    get { world.variables.cg_targVehLastTime }
    set { world.variables.cg_targVehLastTime = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:1868
let MAX_VHUD_SHIELD_TICS = 12 as Int32

/// Source: oracle/codemp/cgame/cg_draw.c:1869
let MAX_VHUD_SPEED_TICS = 5 as Int32

/// Source: oracle/codemp/cgame/cg_draw.c:1870
let MAX_VHUD_ARMOR_TICS = 5 as Int32

/// Source: oracle/codemp/cgame/cg_draw.c:1871
let MAX_VHUD_AMMO_TICS = 5 as Int32

/// Source: oracle/codemp/cgame/cg_draw.c:1940
var cg_vehicleAmmoWarning: Int32 {
    get { world.variables.cg_vehicleAmmoWarning }
    set { world.variables.cg_vehicleAmmoWarning = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:1941
var cg_vehicleAmmoWarningTime: Int32 {
    get { world.variables.cg_vehicleAmmoWarningTime }
    set { world.variables.cg_vehicleAmmoWarningTime = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:2196
var cg_drawLink: Bool {
    get { world.variables.cg_drawLink }
    set { world.variables.cg_drawLink = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:2425
// Raven wrote: veh_damage_t vehDamageData[4]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/cgame/cg_draw.c:3070
let FPS_FRAMES = 16 as Int32

/// Source: oracle/codemp/cgame/cg_draw.c:3116
let MAX_HEALTH_FOR_IFACE = 100 as Int32

/// Source: oracle/codemp/cgame/cg_draw.c:3167
var cg_radarRange: Float {
    get { world.variables.cg_radarRange }
    set { world.variables.cg_radarRange = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:3169
let RADAR_RADIUS = 60 as Int32

/// Source: oracle/codemp/cgame/cg_draw.c:3170
let RADAR_X = (580 - RADAR_RADIUS)

/// Source: oracle/codemp/cgame/cg_draw.c:3172
let RADAR_CHAT_DURATION = 6000 as Int32

/// Source: oracle/codemp/cgame/cg_draw.c:3173
var radarLockSoundDebounceTime: Int32 {
    get { world.variables.radarLockSoundDebounceTime }
    set { world.variables.radarLockSoundDebounceTime = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:3174
var impactSoundDebounceTime: Int32 {
    get { world.variables.impactSoundDebounceTime }
    set { world.variables.impactSoundDebounceTime = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:3175
let RADAR_MISSILE_RANGE = 3000.0 as Float

/// Source: oracle/codemp/cgame/cg_draw.c:3176
let RADAR_ASTEROID_RANGE = 10000.0 as Float

/// Source: oracle/codemp/cgame/cg_draw.c:3177
let RADAR_MIN_ASTEROID_SURF_WARN_DIST = 1200.0 as Float

/// Source: oracle/codemp/cgame/cg_draw.c:4141
let LAG_SAMPLES = 128 as Int32

/// Source: oracle/codemp/cgame/cg_draw.c:4152
var lagometer: Lagometer { world.storage.lagometer }

/// Source: oracle/codemp/cgame/cg_draw.c:4244
let MAX_LAGOMETER_PING = 900 as Int32

/// Source: oracle/codemp/cgame/cg_draw.c:4245
let MAX_LAGOMETER_RANGE = 300 as Int32

/// Source: oracle/codemp/cgame/cg_draw.c:4485
let HEALTH_WIDTH = 50.0 as Float

/// Source: oracle/codemp/cgame/cg_draw.c:4486
let HEALTH_HEIGHT = 5.0 as Float

/// Source: oracle/codemp/cgame/cg_draw.c:4738
var cg_genericTimerBar: Int32 {
    get { world.variables.cg_genericTimerBar }
    set { world.variables.cg_genericTimerBar = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:4739
var cg_genericTimerDur: Int32 {
    get { world.variables.cg_genericTimerDur }
    set { world.variables.cg_genericTimerDur = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:4740
var cg_genericTimerColor: JKAShared.vec4_t {
    get { world.variables.cg_genericTimerColor }
    set { world.variables.cg_genericTimerColor = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:4741
let CGTIMERBAR_H = 50.0 as Float

/// Source: oracle/codemp/cgame/cg_draw.c:4742
let CGTIMERBAR_W = 10.0 as Float

/// Source: oracle/codemp/cgame/cg_draw.c:4743
let CGTIMERBAR_X = (JKAShared.SCREEN_WIDTH - CGTIMERBAR_W - 120.0)

/// Source: oracle/codemp/cgame/cg_draw.c:4744
let CGTIMERBAR_Y = (JKAShared.SCREEN_HEIGHT - CGTIMERBAR_H - 20.0)

/// Source: oracle/codemp/cgame/cg_draw.c:4802
var cg_crosshairPrevPosX: Float {
    get { world.variables.cg_crosshairPrevPosX }
    set { world.variables.cg_crosshairPrevPosX = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:4803
var cg_crosshairPrevPosY: Float {
    get { world.variables.cg_crosshairPrevPosY }
    set { world.variables.cg_crosshairPrevPosY = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:4804
let CRAZY_CROSSHAIR_MAX_ERROR_X = (100.0 * 640.0 / 480.0) as Float

/// Source: oracle/codemp/cgame/cg_draw.c:4805
let CRAZY_CROSSHAIR_MAX_ERROR_Y = (100.0) as Float

/// Source: oracle/codemp/cgame/cg_draw.c:4847
/// Raven's data table, a hand property of `CGameWorld`.
var cg_crosshairPos: JKAShared.vec3_t {
    get { world.cg_crosshairPos }
    set { world.cg_crosshairPos = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:5325
var cg_saberFlashTime: Int32 {
    get { world.variables.cg_saberFlashTime }
    set { world.variables.cg_saberFlashTime = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:5326
/// Raven's data table, a hand property of `CGameWorld`.
var cg_saberFlashPos: JKAShared.vec3_t {
    get { world.cg_saberFlashPos }
    set { world.cg_saberFlashPos = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:6071
let MAX_XHAIR_DIST_ACCURACY = 20000.0 as Float

/// Source: oracle/codemp/cgame/cg_draw.c:7146
let JPFUELBAR_H = 100.0 as Float

/// Source: oracle/codemp/cgame/cg_draw.c:7147
let JPFUELBAR_W = 20.0 as Float

/// Source: oracle/codemp/cgame/cg_draw.c:7148
let JPFUELBAR_X = (JKAShared.SCREEN_WIDTH - JPFUELBAR_W - 8.0)

/// Source: oracle/codemp/cgame/cg_draw.c:7149
let JPFUELBAR_Y = 260.0 as Float

/// Source: oracle/codemp/cgame/cg_draw.c:7198
let EWEBHEALTH_H = 100.0 as Float

/// Source: oracle/codemp/cgame/cg_draw.c:7199
let EWEBHEALTH_W = 20.0 as Float

/// Source: oracle/codemp/cgame/cg_draw.c:7200
let EWEBHEALTH_X = (JKAShared.SCREEN_WIDTH - EWEBHEALTH_W - 8.0)

/// Source: oracle/codemp/cgame/cg_draw.c:7201
let EWEBHEALTH_Y = 290.0 as Float

/// Source: oracle/codemp/cgame/cg_draw.c:7261
let CLFUELBAR_H = 100.0 as Float

/// Source: oracle/codemp/cgame/cg_draw.c:7262
let CLFUELBAR_W = 20.0 as Float

/// Source: oracle/codemp/cgame/cg_draw.c:7263
let CLFUELBAR_X = (JKAShared.SCREEN_WIDTH - CLFUELBAR_W - 8.0)

/// Source: oracle/codemp/cgame/cg_draw.c:7264
let CLFUELBAR_Y = 260.0 as Float

/// Source: oracle/codemp/cgame/cg_draw.c:7317
var cgRageTime: Int32 {
    get { world.variables.cgRageTime }
    set { world.variables.cgRageTime = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7318
var cgRageFadeTime: Int32 {
    get { world.variables.cgRageFadeTime }
    set { world.variables.cgRageFadeTime = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7319
var cgRageFadeVal: Float {
    get { world.variables.cgRageFadeVal }
    set { world.variables.cgRageFadeVal = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7321
var cgRageRecTime: Int32 {
    get { world.variables.cgRageRecTime }
    set { world.variables.cgRageRecTime = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7322
var cgRageRecFadeTime: Int32 {
    get { world.variables.cgRageRecFadeTime }
    set { world.variables.cgRageRecFadeTime = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7323
var cgRageRecFadeVal: Float {
    get { world.variables.cgRageRecFadeVal }
    set { world.variables.cgRageRecFadeVal = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7325
var cgAbsorbTime: Int32 {
    get { world.variables.cgAbsorbTime }
    set { world.variables.cgAbsorbTime = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7326
var cgAbsorbFadeTime: Int32 {
    get { world.variables.cgAbsorbFadeTime }
    set { world.variables.cgAbsorbFadeTime = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7327
var cgAbsorbFadeVal: Float {
    get { world.variables.cgAbsorbFadeVal }
    set { world.variables.cgAbsorbFadeVal = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7329
var cgProtectTime: Int32 {
    get { world.variables.cgProtectTime }
    set { world.variables.cgProtectTime = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7330
var cgProtectFadeTime: Int32 {
    get { world.variables.cgProtectFadeTime }
    set { world.variables.cgProtectFadeTime = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7331
var cgProtectFadeVal: Float {
    get { world.variables.cgProtectFadeVal }
    set { world.variables.cgProtectFadeVal = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7333
var cgYsalTime: Int32 {
    get { world.variables.cgYsalTime }
    set { world.variables.cgYsalTime = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7334
var cgYsalFadeTime: Int32 {
    get { world.variables.cgYsalFadeTime }
    set { world.variables.cgYsalFadeTime = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7335
var cgYsalFadeVal: Float {
    get { world.variables.cgYsalFadeVal }
    set { world.variables.cgYsalFadeVal = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7337
var gCGHasFallVector: Bool {
    get { world.variables.gCGHasFallVector }
    set { world.variables.gCGHasFallVector = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7338
var gCGFallVector: JKAShared.vec3_t {
    get { world.variables.gCGFallVector }
    set { world.variables.gCGFallVector = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7351
var cg_beatingSiegeTime: Int32 {
    get { world.variables.cg_beatingSiegeTime }
    set { world.variables.cg_beatingSiegeTime = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7353
var cgSiegeRoundBeganTime: Int32 {
    get { world.variables.cgSiegeRoundBeganTime }
    set { world.variables.cgSiegeRoundBeganTime = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7354
var cgSiegeRoundCountTime: Int32 {
    get { world.variables.cgSiegeRoundCountTime }
    set { world.variables.cgSiegeRoundCountTime = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7481
var cgSiegeEntityRender: Int32 {
    get { world.variables.cgSiegeEntityRender }
    set { world.variables.cgSiegeEntityRender = newValue }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7529
let CHATBOX_CUTOFF_LEN = 550 as Int32

/// Source: oracle/codemp/cgame/cg_draw.c:7530
let CHATBOX_FONT_HEIGHT = 20 as Int32

/// Source: oracle/codemp/cgame/cg_draw.c:102
func UI_ParseAnimationFile(_ filename: String, _ animset: JKAMP.Animation, _ isHumanoid: Bool) -> Int32 {
    // Port-note: Raven passes `animset` to `BG_ParseAnimationFile`, whose `animset` parameter takes the Slots over the records, and Swift holds one record here. A Slots over one record has no form yet.
    // Raven wrote: return BG_ParseAnimationFile(filename, animset, isHumanoid)
    portMissing("UI_ParseAnimationFile", source: "oracle/codemp/cgame/cg_draw.c:102")
}

/// Source: oracle/codemp/cgame/cg_draw.c:107
func MenuFontToHandle(_ iMenuFont: Int32) -> Int32 {
    switch iMenuFont {
    case FONT_SMALL:
        return cgDC.Assets.qhSmallFont

    case FONT_SMALL2:
        return cgDC.Assets.qhSmall2Font

    case FONT_MEDIUM:
        return cgDC.Assets.qhMediumFont

    case FONT_LARGE:
        return cgDC.Assets.qhMediumFont //cgDC.Assets.qhBigFont;

    default:
        break
    }

    return cgDC.Assets.qhMediumFont
}

/// Source: oracle/codemp/cgame/cg_draw.c:123
func CG_Text_Width(_ text: String, _ scale: Float, _ iMenuFont: Int32) -> Int32 {
    let iFontIndex: Int32 = MenuFontToHandle(iMenuFont)

    return trap_R_Font_StrLenPixels(text, iFontIndex, scale)
}

/// Source: oracle/codemp/cgame/cg_draw.c:130
func CG_Text_Height(_ text: String, _ scale: Float, _ iMenuFont: Int32) -> Int32 {
    let iFontIndex: Int32 = MenuFontToHandle(iMenuFont)

    return trap_R_Font_HeightPixels(iFontIndex, scale)
}

/// Source: oracle/codemp/cgame/cg_draw.c:138
func CG_Text_Paint(_ x: Float, _ y: Float, _ scale: Float, _ color: JKAShared.vec4_t, _ text: String, _ adjust: Float, _ limit: Int32, _ style: Int32, _ iMenuFont: Int32) {
    var iStyleOR: Int32 = 0
    let iFontIndex: Int32 = MenuFontToHandle(iMenuFont)

    switch style {
    case ITEM_TEXTSTYLE_NORMAL:
        iStyleOR = 0

    case ITEM_TEXTSTYLE_BLINK:
        iStyleOR = STYLE_BLINK

    case ITEM_TEXTSTYLE_PULSE:
        iStyleOR = STYLE_BLINK

    case ITEM_TEXTSTYLE_SHADOWED:
        iStyleOR = Int32(STYLE_DROPSHADOW)

    case ITEM_TEXTSTYLE_OUTLINED:
        iStyleOR = Int32(STYLE_DROPSHADOW)

    case ITEM_TEXTSTYLE_OUTLINESHADOWED:
        iStyleOR = Int32(STYLE_DROPSHADOW)

    case ITEM_TEXTSTYLE_SHADOWEDMORE:
        iStyleOR = Int32(STYLE_DROPSHADOW)

    default:
        break
    }

    trap_R_Font_DrawString(Int32(x), Int32(y), text, color, iStyleOR | iFontIndex, limit == 0 ? -1 : limit, scale)
}

/**
```
================
CG_DrawZoomMask

================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:220
private func CG_DrawZoomMask() {
    var color1 = vec4_t()
    var level: Float
    // Port-note: A static local `flip` a statement reads before it writes, storage that outlives the call.
    // Raven wrote: static qboolean flip = qtrue;
    portMissing("CG_DrawZoomMask", source: "oracle/codemp/cgame/cg_draw.c:220")

    //	int ammo = cg_entities[0].gent->client->ps.ammo[weaponData[cent->currentState.weapon].ammoIndex];
    var cx: Float
    var cy: Float
    //	int val[5];
    var max: Float
    var fi: Float

    // Check for Binocular specific zooming since we'll want to render different bits in each case
    if cg.predictedPlayerState.zoomMode == 2 {
        var val: Int32
        var i: Int32
        let off: Float

        // zoom level
        level = Float((80.0 - cg.predictedPlayerState.zoomFov)) / 80.0

        // ...so we'll clamp it
        if level < 0.0 {
            level = 0.0
        } else if level > 1.0 {
            level = 1.0
        }

        // Using a magic number to convert the zoom level to scale amount
        level *= 162.0

        // draw blue tinted distortion mask, trying to make it as small as is necessary to fill in the viewable area
        trap_R_SetColor(colorTable[CT_WHITE])
        CG_DrawPic(34, 48, 570, 362, cgs.media.binocularStatic)

        // Black out the area behind the numbers
        trap_R_SetColor(colorTable[CT_BLACK])
        CG_DrawPic(212, 367, 200, 40, cgs.media.whiteShader)

        // Numbers should be kind of greenish
        color1[0] = 0.2
        color1[1] = 0.4
        color1[2] = 0.2
        color1[3] = 0.3
        trap_R_SetColor(color1)

        // Draw scrolling numbers, use intervals 10 units apart--sorry, this section of code is just kind of hacked
        //	up with a bunch of magic numbers.....
        val = (Int32(((cg.refdef.viewangles[YAW] + 180) / 10))) * 10
        off = (cg.refdef.viewangles[YAW] + 180) - val

        i = -10
        while i < 30 {
            val -= 10

            if val < 0 {
                val += 360
            }

            // we only want to draw the very far left one some of the time, if it's too far to the left it will
            //	poke outside the mask.
            if (off > 3.0 && i == -10) || i > -10 {
                // draw the value, but add 200 just to bump the range up...arbitrary, so change it if you like
                CG_DrawNumField(Int32(155 + i * 10 + off * 10), 374, 3, val + 200, 24, 14, NUM_FONT_CHUNKY, true)
                CG_DrawPic(245 + (i - 1) * 10 + off * 10, 376, 6, 6, cgs.media.whiteShader)
            }
            i += 10
        }

        CG_DrawPic(212, 367, 200, 28, cgs.media.binocularOverlay)

        color1[0] = sin(cg.time * 0.01) * 0.5 + 0.5
        color1[0] = color1[0] * color1[0]
        color1[1] = color1[0]
        color1[2] = color1[0]
        color1[3] = 1.0

        trap_R_SetColor(color1)

        CG_DrawPic(82, 94, 16, 16, cgs.media.binocularCircle)

        // Flickery color
        // Raven wrote: color1[0] = 0.7f + crandom() * 0.1f
        color1[0] = Float(Double(0.7 as Float) + crandom() * Double(0.1 as Float))
        // Raven wrote: color1[1] = 0.8f + crandom() * 0.1f
        color1[1] = Float(Double(0.8 as Float) + crandom() * Double(0.1 as Float))
        // Raven wrote: color1[2] = 0.7f + crandom() * 0.1f
        color1[2] = Float(Double(0.7 as Float) + crandom() * Double(0.1 as Float))
        color1[3] = 1.0
        trap_R_SetColor(color1)

        CG_DrawPic(0, 0, 640, 480, cgs.media.binocularMask)

        CG_DrawPic(4, 282 - level, 16, 16, cgs.media.binocularArrow)

        // The top triangle bit randomly flips
        // Port-note: A read of `flip`, a local the draft left as a hole.
        // Raven wrote: if ( flip ) { CG_DrawPic( 330, 60, -26, -30, cgs.media.binocularTri ); } else { CG_DrawPic( 307, 40, 26, 30, cgs.media.binocularTri ); }
        portMissing("CG_DrawZoomMask", source: "oracle/codemp/cgame/cg_draw.c:220")

        // The SDK also declares `random`, so the call names the bg module.
        if JKAMP_BG.random() > 0.98 && (cg.time & 1024) != 0 {
            // Port-note: A store into `flip`, a local the draft left as a hole.
            // Raven wrote: flip = !flip
            portMissing("CG_DrawZoomMask", source: "oracle/codemp/cgame/cg_draw.c:220")
        }
    } else if cg.predictedPlayerState.zoomMode != 0 {
        // disruptor zoom mode
        level = Float((50.0 - zoomFov)) / 50.0 //(float)(80.0f - zoomFov) / 80.0f;

        // ...so we'll clamp it
        if level < 0.0 {
            level = 0.0
        } else if level > 1.0 {
            level = 1.0
        }

        // Using a magic number to convert the zoom level to a rotation amount that correlates more or less with the zoom artwork.
        level *= 103.0

        // Draw target mask
        trap_R_SetColor(colorTable[CT_WHITE])
        CG_DrawPic(0, 0, 640, 480, cgs.media.disruptorMask)

        // apparently 99.0f is the full zoom level
        if level >= 99 {
            // Fully zoomed, so make the rotating insert pulse
            color1[0] = 1.0
            color1[1] = 1.0
            color1[2] = 1.0
            color1[3] = 0.7 + sin(cg.time * 0.01) * 0.3

            trap_R_SetColor(color1)
        }

        // Draw rotating insert
        CG_DrawRotatePic2(320, 240, 640, 480, -level, cgs.media.disruptorInsert)

        // Increase the light levels under the center of the target
        //		CG_DrawPic( 198, 118, 246, 246, cgs.media.disruptorLight );

        // weirdness.....converting ammo to a base five number scale just to be geeky.
        /*		val[0] = ammo % 5;
        val[1] = (ammo / 5) % 5;
        val[2] = (ammo / 25) % 5;
        val[3] = (ammo / 125) % 5;
        val[4] = (ammo / 625) % 5;

        color1[0] = 0.2f;
        color1[1] = 0.55f + crandom() * 0.1f;
        color1[2] = 0.5f + crandom() * 0.1f;
        color1[3] = 1.0f;
        trap_R_SetColor( color1 );

        for ( int t = 0; t < 5; t++ )
        {
        cx = 320 + sin( (t*10+45)/57.296f ) * 192;
        cy = 240 + cos( (t*10+45)/57.296f ) * 192;

        CG_DrawRotatePic2( cx, cy, 24, 38, 45 - t * 10, trap_R_RegisterShader( va("gfx/2d/char%d",val[4-t] )));
        }
        */
        //max = ( cg_entities[0].gent->health / 100.0f );


        if (cg.snap!.ps.eFlags & EF_DOUBLE_AMMO) != 0 {
            max = cg.snap!.ps.ammo[weaponData[WP_DISRUPTOR].ammoIndex] / (Float(ammoData[weaponData[WP_DISRUPTOR].ammoIndex].max) * 2.0)
        } else {
            max = cg.snap!.ps.ammo[weaponData[WP_DISRUPTOR].ammoIndex] / Float(ammoData[weaponData[WP_DISRUPTOR].ammoIndex].max)
        }
        if max > 1.0 {
            max = 1.0
        }

        color1[0] = (1.0 - max) * 2.0
        color1[1] = max * 1.5
        color1[2] = 0.0
        color1[3] = 1.0

        // If we are low on health, make us flash
        if max < 0.15 && (cg.time & 512) != 0 {
            // Raven wrote: VectorClear( color1 )
            color1[0] = 0
            color1[1] = 0
            color1[2] = 0
        }

        if color1[0] > 1.0 {
            color1[0] = 1.0
        }

        if color1[1] > 1.0 {
            color1[1] = 1.0
        }

        trap_R_SetColor(color1)

        max *= 58.0

        fi = 18.5
        while fi <= 18.5 + max {
            cx = 320 + sin((fi + 90.0) / 57.296) * 190
            cy = 240 + cos((fi + 90.0) / 57.296) * 190

            CG_DrawRotatePic2(cx, cy, 12, 24, 90 - fi, cgs.media.disruptorInsertTick)
            fi += 3
        }

        if cg.predictedPlayerState.weaponstate == WEAPON_CHARGING_ALT {
            trap_R_SetColor(colorTable[CT_WHITE])

            // draw the charge level
            max = (cg.time - cg.predictedPlayerState.weaponChargeTime) / (50.0 * 30.0) // bad hardcodedness 50 is disruptor charge unit and 30 is max charge units allowed.

            if max > 1.0 {
                max = 1.0
            }

            trap_R_DrawStretchPic(257, 435, 134 * max, 34, 0, 0, max, 1, cgs.media.disruptorChargeShader)
        }
        //		trap_R_SetColor( colorTable[CT_WHITE] );
        //		CG_DrawPic( 0, 0, 640, 480, cgs.media.disruptorMask );
    }
}

/**
```
================
CG_Draw3DModel

================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:467
func CG_Draw3DModel(_ x: Float, _ y: Float, _ w: Float, _ h: Float, _ model: JKAShared.qhandle_t, _ ghoul2: OpaquePointer?, _ g2radius: Int32, _ skin: JKAShared.qhandle_t, _ origin: JKAShared.vec3_t, _ angles: JKAShared.vec3_t) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Refdef.scratch { refdef -> Bool in
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives true where Raven returns from the function.
        let earlyOut2 = RefEntity.scratch { ent -> Bool in

            if cg_draw3dIcons.integer == 0 || cg_drawIcons.integer == 0 {
                return true
            }

            // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.

            // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Slots<vec3_t>' (aka 'Slots<SIMD3<Float>>') to expected argument type '[vec3_t]' (aka 'Array<SIMD3<Float>>')".
            // Raven wrote: AnglesToAxis( angles, ent.axis )
            portMissing("CG_Draw3DModel", source: "oracle/codemp/cgame/cg_draw.c:467")
            ent.origin = origin
            ent.hModel = model
            ent.ghoul2 = ghoul2
            ent.radius = Float(g2radius)
            ent.customSkin = skin
            ent.renderfx = RF_NOSHADOW // no stencil shadows

            refdef.rdflags = RDF_NOWORLDMODEL

            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Slots<vec3_t>' (aka 'Slots<SIMD3<Float>>') to expected argument type '[vec3_t]' (aka 'Array<SIMD3<Float>>')".
            // Raven wrote: AxisClear( refdef.viewaxis )
            portMissing("CG_Draw3DModel", source: "oracle/codemp/cgame/cg_draw.c:467")

            refdef.fov_x = 30
            refdef.fov_y = 30

            refdef.x = Int32(x)
            refdef.y = Int32(y)
            refdef.width = Int32(w)
            refdef.height = Int32(h)

            refdef.time = cg.time

            trap_R_ClearScene()
            trap_R_AddRefEntityToScene(ent)
            trap_R_RenderScene(refdef)
            return false
        }
        if earlyOut2 {
            return true
        }
        return false
    }
    if earlyOut {
        return
    }
}

/**
```
================
CG_DrawHead

Used for both the status bar and the scoreboard
================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:512
func CG_DrawHead(_ x: Float, _ y: Float, _ w: Float, _ h: Float, _ clientNum: Int32, _ headAngles: JKAShared.vec3_t) {
    var ci: ClientInfo?

    if clientNum >= MAX_CLIENTS {
        //npc?
        return
    }

    ci = cgs.clientinfo[clientNum]

    CG_DrawPic(x, y, w, h, ci!.modelIcon)

    // if they are deferred, draw a cross out
    if ci!.deferred {
        CG_DrawPic(x, y, w, h, cgs.media.deferShader)
    }
}

/**
```
================
CG_DrawFlagModel

Used for both the status bar and the scoreboard
================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:539
func CG_DrawFlagModel(_ x: Float, _ y: Float, _ w: Float, _ h: Float, _ team: Int32, _ force2D: Bool) {
    let cm: qhandle_t
    let len: Float
    var origin = vec3_t()
    var angles = vec3_t()
    var mins = vec3_t()
    var maxs = vec3_t()
    var handle: qhandle_t

    if !force2D && cg_draw3dIcons.integer != 0 {
        angles = vec3_t()

        cm = cgs.media.redFlagModel

        // offset the origin y and z to center the flag
        trap_R_ModelBounds(cm, &mins, &maxs)

        origin[2] = Float(-0.5 * Double(mins[2] + maxs[2]))
        origin[1] = Float(0.5 * Double(mins[1] + maxs[1]))

        // calculate distance so the flag nearly fills the box
        // assume heads are taller than wide
        len = Float(0.5 * Double(maxs[2] - mins[2]))
        origin[0] = Float(Double(len) / 0.268) // len / tan( fov/2 )

        angles[YAW] = Float(60 * sin(Double(cg.time) / 2000.0))

        if team == TEAM_RED {
            handle = cgs.media.redFlagModel
        } else if team == TEAM_BLUE {
            handle = cgs.media.blueFlagModel
        } else if team == TEAM_FREE {
            handle = 0 //cgs.media.neutralFlagModel;
        } else {
            return
        }
        CG_Draw3DModel(x, y, w, h, handle, nil, 0, 0, origin, angles)
    } else if cg_drawIcons.integer != 0 {
        var item: Gitem?

        if team == TEAM_RED {
            item = BG_FindItemForPowerup(PW_REDFLAG)
        } else if team == TEAM_BLUE {
            item = BG_FindItemForPowerup(PW_BLUEFLAG)
        } else if team == TEAM_FREE {
            item = BG_FindItemForPowerup(PW_NEUTRALFLAG)
        } else {
            return
        }
        if item != nil {
            // Raven wrote: CG_DrawPic( x, y, w, h, cg_items[ ITEM_INDEX(item) ].icon )
            CG_DrawPic(x, y, w, h, cg_items[bg_itemlist.index(of: item!)].icon)
        }
    }
}

/**
```
================
DrawAmmo
================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:598
func DrawAmmo() {
    let x: Int32
    let y: Int32

    x = SCREEN_WIDTH - 80
    y = SCREEN_HEIGHT - 80
}

/**
```
================
CG_DrawHealth
================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:614
func CG_DrawHealth(_ menuHUD: MenuDef) {
    var calcColor = vec4_t()
    var ps: PlayerState?
    var healthAmt: Int32
    var i: Int32
    var currValue: Int32
    let inc: Int32
    var focusItem: ItemDef?
    var percent: Float

    // Can we find the menu?

    ps = cg.snap!.ps

    // What's the health?
    healthAmt = ps!.stats[STAT_HEALTH]
    if healthAmt > ps!.stats[STAT_MAX_HEALTH] {
        healthAmt = ps!.stats[STAT_MAX_HEALTH]
    }


    inc = Int32(Float(ps!.stats[STAT_MAX_HEALTH]) / MAX_HUD_TICS)
    currValue = healthAmt

    // Print the health tics, fading out the one which is partial health
    i = (MAX_HUD_TICS - 1)
    while i >= 0 {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
        // Raven wrote: focusItem = Menu_FindItemByName(menuHUD, healthTicName[i])
        portMissing("CG_DrawHealth", source: "oracle/codemp/cgame/cg_draw.c:614")

        if focusItem == nil {
            i -= 1
            continue
        }

        // Raven wrote: memcpy(calcColor, hudTintColor, sizeof(vec4_t))
        calcColor = hudTintColor

        if currValue <= 0 {
            break
        } else if currValue < inc {
            percent = Float(currValue) / inc
            calcColor[3] *= percent // Fade it out
        }

        trap_R_SetColor(calcColor)

        CG_DrawPic(focusItem!.window.rect.x, focusItem!.window.rect.y, focusItem!.window.rect.w, focusItem!.window.rect.h, focusItem!.window.background)

        currValue -= inc
        i -= 1
    }

    // Print the mueric amount
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
    // Raven wrote: focusItem = Menu_FindItemByName(menuHUD, "healthamount")
    portMissing("CG_DrawHealth", source: "oracle/codemp/cgame/cg_draw.c:614")
    if focusItem != nil {
        // Print health amount
        trap_R_SetColor(vec4_t(focusItem!.window.foreColor[0], focusItem!.window.foreColor[1], focusItem!.window.foreColor[2], focusItem!.window.foreColor[3]))

        CG_DrawNumField(Int32(focusItem!.window.rect.x), Int32(focusItem!.window.rect.y), 3, ps!.stats[STAT_HEALTH], Int32(focusItem!.window.rect.w), Int32(focusItem!.window.rect.h), NUM_FONT_SMALL, false)
    }
}

/**
```
================
CG_DrawArmor
================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:702
func CG_DrawArmor(_ menuHUD: MenuDef) {
    var calcColor = vec4_t()
    var ps: PlayerState?
    var armor: Int32
    let maxArmor: Int32
    var focusItem: ItemDef?
    var percent: Float
    let quarterArmor: Float
    var i: Int32
    var currValue: Int32
    let inc: Int32

    //ps = &cg.snap->ps;
    ps = cg.predictedPlayerState

    // Can we find the menu?

    armor = ps!.stats[STAT_ARMOR]
    maxArmor = ps!.stats[STAT_MAX_HEALTH]

    if armor > maxArmor {
        armor = maxArmor
    }

    currValue = armor
    inc = Int32(Float(maxArmor) / MAX_HUD_TICS)

    // Raven wrote: memcpy(calcColor, hudTintColor, sizeof(vec4_t))
    calcColor = hudTintColor
    i = (MAX_HUD_TICS - 1)
    while i >= 0 {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
        // Raven wrote: focusItem = Menu_FindItemByName(menuHUD, armorTicName[i])
        portMissing("CG_DrawArmor", source: "oracle/codemp/cgame/cg_draw.c:702")

        if focusItem == nil {
            i -= 1
            continue
        }

        // Raven wrote: memcpy(calcColor, hudTintColor, sizeof(vec4_t))
        calcColor = hudTintColor

        if currValue <= 0 {
            break
        } else if currValue < inc {
            percent = Float(currValue) / inc
            calcColor[3] *= percent
        }

        trap_R_SetColor(calcColor)

        if (i == (MAX_HUD_TICS - 1)) && (currValue < inc) {
            if cg.HUDArmorFlag {
                CG_DrawPic(focusItem!.window.rect.x, focusItem!.window.rect.y, focusItem!.window.rect.w, focusItem!.window.rect.h, focusItem!.window.background)
            }
        } else {
            CG_DrawPic(focusItem!.window.rect.x, focusItem!.window.rect.y, focusItem!.window.rect.w, focusItem!.window.rect.h, focusItem!.window.background)
        }

        currValue -= inc
        i -= 1
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
    // Raven wrote: focusItem = Menu_FindItemByName(menuHUD, "armoramount")
    portMissing("CG_DrawArmor", source: "oracle/codemp/cgame/cg_draw.c:702")

    if focusItem != nil {
        // Print armor amount
        trap_R_SetColor(vec4_t(focusItem!.window.foreColor[0], focusItem!.window.foreColor[1], focusItem!.window.foreColor[2], focusItem!.window.foreColor[3]))

        CG_DrawNumField(Int32(focusItem!.window.rect.x), Int32(focusItem!.window.rect.y), 3, armor, Int32(focusItem!.window.rect.w), Int32(focusItem!.window.rect.h), NUM_FONT_SMALL, false)
    }

    // If armor is low, flash a graphic to warn the player
    if armor != 0 {
        quarterArmor = Float((ps!.stats[STAT_MAX_HEALTH] / 4.0))

        // Make tic flash if armor is at 25% of full armor
        if ps!.stats[STAT_ARMOR] < quarterArmor {
            if cg.HUDTickFlashTime < cg.time {
                cg.HUDTickFlashTime = Float(cg.time + 400)
                if cg.HUDArmorFlag {
                    cg.HUDArmorFlag = false
                } else {
                    cg.HUDArmorFlag = true
                }
            }
        } else {
            cg.HUDArmorFlag = true
        }
    } else {
        cg.HUDArmorFlag = false
    }
}

/**
```
================
CG_DrawSaberStyle

If the weapon is a light saber (which needs no ammo) then draw a graphic showing
the saber style (fast, medium, strong)
================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:841
private func CG_DrawSaberStyle(_ cent: Centity, _ menuHUD: MenuDef) {
    var focusItem: ItemDef?

    if cent.currentState.weapon == 0 {
        return
    }

    if cent.currentState.weapon != WP_SABER {
        return
    }

    // Can we find the menu?


    // draw the current saber style in this window
    switch cg.predictedPlayerState.fd.saberDrawAnimLevel {
    case 1, //FORCE_LEVEL_1:
         5: //FORCE_LEVEL_5://Tavion
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
        // Raven wrote: focusItem = Menu_FindItemByName(menuHUD, "saberstyle_fast")
        portMissing("CG_DrawSaberStyle", source: "oracle/codemp/cgame/cg_draw.c:841")

        if focusItem != nil {
            // Raven wrote: trap_R_SetColor( hudTintColor )
            trap_R_SetColor(hudTintColor)

            CG_DrawPic(focusItem!.window.rect.x, focusItem!.window.rect.y, focusItem!.window.rect.w, focusItem!.window.rect.h, focusItem!.window.background)
        }

    case 2, //FORCE_LEVEL_2:
         6, //SS_DUAL
         7: //SS_STAFF
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
        // Raven wrote: focusItem = Menu_FindItemByName(menuHUD, "saberstyle_medium")
        portMissing("CG_DrawSaberStyle", source: "oracle/codemp/cgame/cg_draw.c:841")

        if focusItem != nil {
            // Raven wrote: trap_R_SetColor( hudTintColor )
            trap_R_SetColor(hudTintColor)

            CG_DrawPic(focusItem!.window.rect.x, focusItem!.window.rect.y, focusItem!.window.rect.w, focusItem!.window.rect.h, focusItem!.window.background)
        }

    case 3, //FORCE_LEVEL_3:
         4: //FORCE_LEVEL_4://Desann
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
        // Raven wrote: focusItem = Menu_FindItemByName(menuHUD, "saberstyle_strong")
        portMissing("CG_DrawSaberStyle", source: "oracle/codemp/cgame/cg_draw.c:841")

        if focusItem != nil {
            // Raven wrote: trap_R_SetColor( hudTintColor )
            trap_R_SetColor(hudTintColor)

            CG_DrawPic(focusItem!.window.rect.x, focusItem!.window.rect.y, focusItem!.window.rect.w, focusItem!.window.rect.h, focusItem!.window.background)
        }

    default:
        break
    }
}

/**
```
================
CG_DrawAmmo
================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:928
private func CG_DrawAmmo(_ cent: Centity, _ menuHUD: MenuDef) {
    var ps: PlayerState?
    var i: Int32
    var calcColor = vec4_t()
    var value: Float
    var inc: Float = 0.0
    var percent: Float
    var focusItem: ItemDef?

    ps = cg.snap!.ps

    // Can we find the menu?

    if cent.currentState.weapon == 0 {
        return
    }

    value = Float(ps!.ammo[weaponData[cent.currentState.weapon].ammoIndex])
    if value < 0 {
        return
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
    // Raven wrote: focusItem = Menu_FindItemByName(menuHUD, "ammoamount")
    portMissing("CG_DrawAmmo", source: "oracle/codemp/cgame/cg_draw.c:928")
    // Raven wrote: trap_R_SetColor( hudTintColor )
    trap_R_SetColor(hudTintColor)

    if weaponData[cent.currentState.weapon].energyPerShot == 0 && weaponData[cent.currentState.weapon].altEnergyPerShot == 0 {
        //just draw "infinite"
        inc = Float(8 / MAX_HUD_TICS)
        value = 8

        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
        // Raven wrote: focusItem = Menu_FindItemByName(menuHUD, "ammoinfinite")
        portMissing("CG_DrawAmmo", source: "oracle/codemp/cgame/cg_draw.c:928")
        // Raven wrote: trap_R_SetColor( hudTintColor )
        trap_R_SetColor(hudTintColor)
        if focusItem != nil {
            UI_DrawProportionalString(Int32(focusItem!.window.rect.x), Int32(focusItem!.window.rect.y), "--", NUM_FONT_SMALL, vec4_t(focusItem!.window.foreColor[0], focusItem!.window.foreColor[1], focusItem!.window.foreColor[2], focusItem!.window.foreColor[3]))
        }
    } else {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
        // Raven wrote: focusItem = Menu_FindItemByName(menuHUD, "ammoamount")
        portMissing("CG_DrawAmmo", source: "oracle/codemp/cgame/cg_draw.c:928")
        // Raven wrote: trap_R_SetColor( hudTintColor )
        trap_R_SetColor(hudTintColor)
        if focusItem != nil {
            if (cent.currentState.eFlags & EF_DOUBLE_AMMO) != 0 {
                inc = Float((ammoData[weaponData[cent.currentState.weapon].ammoIndex].max * 2.0)) / MAX_HUD_TICS
            } else {
                inc = Float(ammoData[weaponData[cent.currentState.weapon].ammoIndex].max) / MAX_HUD_TICS
            }
            value = Float(ps!.ammo[weaponData[cent.currentState.weapon].ammoIndex])

            CG_DrawNumField(Int32(focusItem!.window.rect.x), Int32(focusItem!.window.rect.y), 3, Int32(value), Int32(focusItem!.window.rect.w), Int32(focusItem!.window.rect.h), NUM_FONT_SMALL, false)
        }
    }

    // Draw tics
    i = MAX_HUD_TICS - 1
    while i >= 0 {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
        // Raven wrote: focusItem = Menu_FindItemByName(menuHUD, ammoTicName[i])
        portMissing("CG_DrawAmmo", source: "oracle/codemp/cgame/cg_draw.c:928")

        if focusItem == nil {
            i -= 1
            continue
        }

        // Raven wrote: memcpy(calcColor, hudTintColor, sizeof(vec4_t))
        calcColor = hudTintColor

        if value <= 0 {
            break
        } else if value < inc {
            percent = value / inc
            calcColor[3] = percent
        }

        trap_R_SetColor(calcColor)

        CG_DrawPic(focusItem!.window.rect.x, focusItem!.window.rect.y, focusItem!.window.rect.w, focusItem!.window.rect.h, focusItem!.window.background)

        value -= inc
        i -= 1
    }
}

/**
```
================
CG_DrawForcePower
================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:1042
func CG_DrawForcePower(_ menuHUD: MenuDef) {
    var i: Int32
    var calcColor = vec4_t()
    var value: Float
    let inc: Float
    var percent: Float
    var focusItem: ItemDef?
    let maxForcePower: Int32 = 100
    var flash: Bool = false

    // Can we find the menu?

    // Make the hud flash by setting forceHUDTotalFlashTime above cg.time
    if cg.forceHUDTotalFlashTime > cg.time {
        flash = true
        if cg.forceHUDNextFlashTime < cg.time {
            cg.forceHUDNextFlashTime = cg.time + 400
            // Port-note: Raven passes NULL for the `origin` input of `trap_S_StartSound`, and the engine then plays the sound at the entity. A zero vector plays it at the world origin, so the trap needs an optional `origin`.
            portMissing("CG_DrawForcePower", source: "oracle/codemp/cgame/cg_draw.c:1042")
            var scratchOrigin = vec3_t()
            trap_S_StartSound(&scratchOrigin, 0, CHAN_LOCAL, cgs.media.noforceSound)

            if cg.forceHUDActive {
                cg.forceHUDActive = false
            } else {
                cg.forceHUDActive = true
            }
        }
    } else {
        cg.forceHUDNextFlashTime = 0
        cg.forceHUDActive = true
    }

    //	if (!cg.forceHUDActive)
    //	{
    //		return;
    //	}

    inc = Float(maxForcePower) / MAX_HUD_TICS
    value = Float(cg.snap!.ps.fd.forcePower)

    i = MAX_HUD_TICS - 1
    while i >= 0 {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
        // Raven wrote: focusItem = Menu_FindItemByName(menuHUD, forceTicName[i])
        portMissing("CG_DrawForcePower", source: "oracle/codemp/cgame/cg_draw.c:1042")

        if focusItem == nil {
            i -= 1
            continue
        }

        //		memcpy(calcColor, hudTintColor, sizeof(vec4_t));

        if value <= 0 {
            break
        } else if value < inc {
            if flash {
                // Raven wrote: memcpy(calcColor, colorTable[CT_RED], sizeof(vec4_t))
                calcColor = colorTable[CT_RED]
            } else {
                // Raven wrote: memcpy(calcColor, colorTable[CT_WHITE], sizeof(vec4_t))
                calcColor = colorTable[CT_WHITE]
            }

            percent = value / inc
            calcColor[3] = percent
        } else {
            if flash {
                // Raven wrote: memcpy(calcColor, colorTable[CT_RED], sizeof(vec4_t))
                calcColor = colorTable[CT_RED]
            } else {
                // Raven wrote: memcpy(calcColor, colorTable[CT_WHITE], sizeof(vec4_t))
                calcColor = colorTable[CT_WHITE]
            }
        }

        trap_R_SetColor(calcColor)

        CG_DrawPic(focusItem!.window.rect.x, focusItem!.window.rect.y, focusItem!.window.rect.w, focusItem!.window.rect.h, focusItem!.window.background)

        value -= inc
        i -= 1
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
    // Raven wrote: focusItem = Menu_FindItemByName(menuHUD, "forceamount")
    portMissing("CG_DrawForcePower", source: "oracle/codemp/cgame/cg_draw.c:1042")

    if focusItem != nil {
        // Print force amount
        trap_R_SetColor(vec4_t(focusItem!.window.foreColor[0], focusItem!.window.foreColor[1], focusItem!.window.foreColor[2], focusItem!.window.foreColor[3]))

        CG_DrawNumField(Int32(focusItem!.window.rect.x), Int32(focusItem!.window.rect.y), 3, cg.snap!.ps.fd.forcePower, Int32(focusItem!.window.rect.w), Int32(focusItem!.window.rect.h), NUM_FONT_SMALL, false)
    }
}

/**
```
================
CG_DrawHUD
================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:1169
func CG_DrawHUD(_ cent: Centity) {
    var menuHUD: MenuDef? = nil
    var focusItem: ItemDef? = nil
    var scoreStr: String? = nil
    var scoreBias: Int32
    var scoreBiasStr = CharBuf(16)

    if cg_hudFiles.integer != 0 {
        let x: Int32 = 0
        let y: Int32 = SCREEN_HEIGHT - 80
        var ammoString = CharBuf(64)
        var weapX: Int32 = x

        UI_DrawProportionalString(x + 16, y + 40, va("%i", cg.snap!.ps.stats[STAT_HEALTH]), UI_SMALLFONT | UI_DROPSHADOW, colorTable[CT_HUD_RED])

        UI_DrawProportionalString(x + 18 + 14, y + 40 + 14, va("%i", cg.snap!.ps.stats[STAT_ARMOR]), UI_SMALLFONT | UI_DROPSHADOW, colorTable[CT_HUD_GREEN])

        if cg.snap!.ps.weapon == WP_SABER {
            if cg.snap!.ps.fd.saberDrawAnimLevel == SS_DUAL {
                Com_sprintf(&ammoString, Int32((ammoString).count), "AKIMBO")
                weapX += 16
            } else if cg.snap!.ps.fd.saberDrawAnimLevel == SS_STAFF {
                Com_sprintf(&ammoString, Int32((ammoString).count), "STAFF")
                weapX += 16
            } else if cg.snap!.ps.fd.saberDrawAnimLevel == FORCE_LEVEL_3 {
                Com_sprintf(&ammoString, Int32((ammoString).count), "STRONG")
                weapX += 16
            } else if cg.snap!.ps.fd.saberDrawAnimLevel == FORCE_LEVEL_2 {
                Com_sprintf(&ammoString, Int32((ammoString).count), "MEDIUM")
                weapX += 16
            } else {
                Com_sprintf(&ammoString, Int32((ammoString).count), "FAST")
            }
        } else {
            Com_sprintf(&ammoString, Int32((ammoString).count), "%i", cg.snap!.ps.ammo[weaponData[cent.currentState.weapon].ammoIndex])
        }

        UI_DrawProportionalString(SCREEN_WIDTH - (weapX + 16 + 32), y + 40, va("%s", ammoString), UI_SMALLFONT | UI_DROPSHADOW, colorTable[CT_HUD_ORANGE])

        UI_DrawProportionalString(SCREEN_WIDTH - (x + 18 + 14 + 32), y + 40 + 14, va("%i", cg.snap!.ps.fd.forcePower), UI_SMALLFONT | UI_DROPSHADOW, colorTable[CT_ICON_BLUE])

        return
    }

    if cgs.gametype >= GT_TEAM && cgs.gametype != GT_SIEGE {
        // tint the hud items based on team
        if cg.snap!.ps.persistant[PERS_TEAM] == TEAM_RED {
            // Raven wrote: hudTintColor = redhudtint
            hudTintColor = redhudtint
        } else if cg.snap!.ps.persistant[PERS_TEAM] == TEAM_BLUE {
            // Raven wrote: hudTintColor = bluehudtint
            hudTintColor = bluehudtint
        } else {
            // Raven wrote: hudTintColor = colorTable[CT_WHITE]
            hudTintColor = colorTable[CT_WHITE]
        }
    } else {
        // tint the hud items white (dont' tint)
        // Raven wrote: hudTintColor = colorTable[CT_WHITE]
        hudTintColor = colorTable[CT_WHITE]
    }

    // Draw the left HUD
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menus_FindByName' in scope".
    // Raven wrote: menuHUD = Menus_FindByName("lefthud")
    portMissing("CG_DrawHUD", source: "oracle/codemp/cgame/cg_draw.c:1169")
    if menuHUD != nil {
        var focusItem: ItemDef?

        // Print scanline
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
        // Raven wrote: focusItem = Menu_FindItemByName(menuHUD, "scanline")
        portMissing("CG_DrawHUD", source: "oracle/codemp/cgame/cg_draw.c:1169")
        if focusItem != nil {
            // Raven wrote: trap_R_SetColor( hudTintColor )
            trap_R_SetColor(hudTintColor)
            CG_DrawPic(focusItem!.window.rect.x, focusItem!.window.rect.y, focusItem!.window.rect.w, focusItem!.window.rect.h, focusItem!.window.background)
        }

        // Print frame
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
        // Raven wrote: focusItem = Menu_FindItemByName(menuHUD, "frame")
        portMissing("CG_DrawHUD", source: "oracle/codemp/cgame/cg_draw.c:1169")
        if focusItem != nil {
            // Raven wrote: trap_R_SetColor( hudTintColor )
            trap_R_SetColor(hudTintColor)
            CG_DrawPic(focusItem!.window.rect.x, focusItem!.window.rect.y, focusItem!.window.rect.w, focusItem!.window.rect.h, focusItem!.window.background)
        }

        if cg.predictedPlayerState.pm_type != PM_SPECTATOR {
            CG_DrawArmor(menuHUD!)
            CG_DrawHealth(menuHUD!)
        }
    } else {
        //CG_Error("CG_ChatBox_ArrayInsert: unable to locate HUD menu file ");
    }

    //scoreStr = va("Score: %i", cgs.clientinfo[cg.snap->ps.clientNum].score);
    if cgs.gametype == GT_DUEL {
        //A duel that requires more than one kill to knock the current enemy back to the queue
        //show current kills out of how many needed
        scoreStr = va("%s: %i/%i", CG_GetStringEdString("MP_INGAME", "SCORE"), cg.snap!.ps.persistant[PERS_SCORE], cgs.fraglimit)
    } else if 0 != 0 && cgs.gametype < GT_TEAM {
        // This is a teamless mode, draw the score bias.
        scoreBias = cg.snap!.ps.persistant[PERS_SCORE] - cgs.scores1
        if scoreBias == 0 {
            // We are the leader!
            if cgs.scores2 <= 0 {
                // Nobody to be ahead of yet.
                Com_sprintf(&scoreBiasStr, Int32((scoreBiasStr).count), "")
            } else {
                scoreBias = cg.snap!.ps.persistant[PERS_SCORE] - cgs.scores2
                if scoreBias == 0 {
                    Com_sprintf(&scoreBiasStr, Int32((scoreBiasStr).count), " (Tie)")
                } else {
                    Com_sprintf(&scoreBiasStr, Int32((scoreBiasStr).count), " (+%d)", scoreBias)
                }
            }
        } else {
            // We are behind!
            Com_sprintf(&scoreBiasStr, Int32((scoreBiasStr).count), " (%d)", scoreBias)
        }
        scoreStr = va("%s: %i%s", CG_GetStringEdString("MP_INGAME", "SCORE"), cg.snap!.ps.persistant[PERS_SCORE], scoreBiasStr)
    } else {
        // Don't draw a bias.
        scoreStr = va("%s: %i", CG_GetStringEdString("MP_INGAME", "SCORE"), cg.snap!.ps.persistant[PERS_SCORE])
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menus_FindByName' in scope".
    // Raven wrote: menuHUD = Menus_FindByName("righthud")
    portMissing("CG_DrawHUD", source: "oracle/codemp/cgame/cg_draw.c:1169")

    if menuHUD != nil {
        if cgs.gametype != GT_POWERDUEL {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
            // Raven wrote: focusItem = Menu_FindItemByName(menuHUD, "score_line")
            portMissing("CG_DrawHUD", source: "oracle/codemp/cgame/cg_draw.c:1169")
            if focusItem != nil {
                UI_DrawScaledProportionalString(Int32(focusItem!.window.rect.x), Int32(focusItem!.window.rect.y), scoreStr!, UI_RIGHT | UI_DROPSHADOW, vec4_t(focusItem!.window.foreColor[0], focusItem!.window.foreColor[1], focusItem!.window.foreColor[2], focusItem!.window.foreColor[3]), 0.7)
            }
        }

        // Print scanline
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
        // Raven wrote: focusItem = Menu_FindItemByName(menuHUD, "scanline")
        portMissing("CG_DrawHUD", source: "oracle/codemp/cgame/cg_draw.c:1169")
        if focusItem != nil {
            // Raven wrote: trap_R_SetColor( hudTintColor )
            trap_R_SetColor(hudTintColor)
            CG_DrawPic(focusItem!.window.rect.x, focusItem!.window.rect.y, focusItem!.window.rect.w, focusItem!.window.rect.h, focusItem!.window.background)
        }

        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
        // Raven wrote: focusItem = Menu_FindItemByName(menuHUD, "frame")
        portMissing("CG_DrawHUD", source: "oracle/codemp/cgame/cg_draw.c:1169")
        if focusItem != nil {
            // Raven wrote: trap_R_SetColor( hudTintColor )
            trap_R_SetColor(hudTintColor)
            CG_DrawPic(focusItem!.window.rect.x, focusItem!.window.rect.y, focusItem!.window.rect.w, focusItem!.window.rect.h, focusItem!.window.background)
        }

        CG_DrawForcePower(menuHUD!)

        // Draw ammo tics or saber style
        if cent.currentState.weapon == WP_SABER {
            CG_DrawSaberStyle(cent, menuHUD!)
        } else {
            CG_DrawAmmo(cent, menuHUD!)
        }
    } else {
        //CG_Error("CG_ChatBox_ArrayInsert: unable to locate HUD menu file ");
    }
}

/// Source: oracle/codemp/cgame/cg_draw.c:1395
func ForcePower_Valid(_ i: Int32) -> Bool {
    if i == FP_LEVITATION || i == FP_SABER_OFFENSE || i == FP_SABER_DEFENSE || i == FP_SABERTHROW {
        return false
    }

    if (cg.snap!.ps.fd.forcePowersKnown & (1 << i)) != 0 {
        return true
    }

    return false
}

/// Source: oracle/codemp/cgame/cg_draw.c:1421
func CG_DrawForceSelect() {
    var i: Int32
    var count: Int32
    let smallIconSize: Int32
    let bigIconSize: Int32
    var holdX: Int32
    let x: Int32
    let y: Int32
    let x2: Int32
    let y2: Int32
    let pad: Int32
    let length: Int32
    var sideLeftIconCnt: Int32
    var sideRightIconCnt: Int32
    let sideMax: Int32
    let holdCount: Int32
    var iconCnt: Int32
    let yOffset: Int32 = 0


    x2 = 0
    y2 = 0

    // don't display if dead
    if cg.snap!.ps.stats[STAT_HEALTH] <= 0 {
        return
    }

    if (cg.forceSelectTime + WEAPON_SELECT_TIME) < cg.time {
        cg.forceSelect = cg.snap!.ps.fd.forcePowerSelected
        return
    }

    if cg.snap!.ps.fd.forcePowersKnown == 0 {
        return
    }


    // count the number of powers owned
    count = 0

    i = 0
    while i < NUM_FORCE_POWERS {
        if ForcePower_Valid(i) {
            count += 1
        }
        i += 1
    }

    if count == 0 {
        return
    }

    sideMax = 3 // Max number of icons on the side

    // Calculate how many icons will appear to either side of the center one
    holdCount = count - 1 // -1 for the center icon
    if holdCount == 0 {
        sideLeftIconCnt = 0
        sideRightIconCnt = 0
    } else if count > (2 * sideMax) {
        sideLeftIconCnt = sideMax
        sideRightIconCnt = sideMax
    } else {
        sideLeftIconCnt = holdCount / 2
        sideRightIconCnt = holdCount - sideLeftIconCnt
    }

    smallIconSize = 30
    bigIconSize = 60
    pad = 12

    x = 320
    y = 425

    // Background
    length = (sideLeftIconCnt * smallIconSize) + (sideLeftIconCnt * pad) + bigIconSize + (sideRightIconCnt * smallIconSize) + (sideRightIconCnt * pad) + 12

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_ProperForceIndex' in scope".
    // Raven wrote: i = BG_ProperForceIndex(cg.forceSelect) - 1
    portMissing("CG_DrawForceSelect", source: "oracle/codemp/cgame/cg_draw.c:1421")
    if i < 0 {
        i = NUM_FORCE_POWERS
    }

    trap_R_SetColor(nil)
    // Work backwards from current icon
    holdX = x - ((bigIconSize / 2) + pad + smallIconSize)
    iconCnt = 1
    while iconCnt < (sideLeftIconCnt + 1) {
        if i < 0 {
            i = NUM_FORCE_POWERS
        }

        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'forcePowerSorted' in scope".
        // Raven wrote: if (!ForcePower_Valid(forcePowerSorted[i])) // Does he have this power? { continue; }
        portMissing("CG_DrawForceSelect", source: "oracle/codemp/cgame/cg_draw.c:1421")

        iconCnt += 1 // Good icon

        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'forcePowerSorted' in scope".
        // Raven wrote: if (cgs.media.forcePowerIcons[forcePowerSorted[i]]) { CG_DrawPic( holdX, y + yOffset, smallIconSize, smallIconSize, cgs.media.forcePowerIcons[forcePowerSorted[i]] ); holdX -= (smallIconSize+pad); }
        portMissing("CG_DrawForceSelect", source: "oracle/codemp/cgame/cg_draw.c:1421")
        i -= 1
    }

    if ForcePower_Valid(cg.forceSelect) {
        // Current Center Icon
        if cgs.media.forcePowerIcons[cg.forceSelect] != 0 {
            CG_DrawPic(Float(x - (bigIconSize / 2)), Float((y - ((bigIconSize - smallIconSize) / 2)) + yOffset), Float(bigIconSize), Float(bigIconSize), cgs.media.forcePowerIcons[cg.forceSelect]) //only cache the icon for display
        }
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_ProperForceIndex' in scope".
    // Raven wrote: i = BG_ProperForceIndex(cg.forceSelect) + 1
    portMissing("CG_DrawForceSelect", source: "oracle/codemp/cgame/cg_draw.c:1421")
    if i > NUM_FORCE_POWERS {
        i = 0
    }

    // Work forwards from current icon
    holdX = x + (bigIconSize / 2) + pad
    iconCnt = 1
    while iconCnt < (sideRightIconCnt + 1) {
        if i > NUM_FORCE_POWERS {
            i = 0
        }

        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'forcePowerSorted' in scope".
        // Raven wrote: if (!ForcePower_Valid(forcePowerSorted[i])) // Does he have this power? { continue; }
        portMissing("CG_DrawForceSelect", source: "oracle/codemp/cgame/cg_draw.c:1421")

        iconCnt += 1 // Good icon

        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'forcePowerSorted' in scope".
        // Raven wrote: if (cgs.media.forcePowerIcons[forcePowerSorted[i]]) { CG_DrawPic( holdX, y + yOffset, smallIconSize, smallIconSize, cgs.media.forcePowerIcons[forcePowerSorted[i]] ); //only cache the icon for display holdX += (smallIconSize+pad); }
        portMissing("CG_DrawForceSelect", source: "oracle/codemp/cgame/cg_draw.c:1421")
        i += 1
    }

    if showPowersName[cg.forceSelect] != nil {
        UI_DrawProportionalString(320, y + 30 + yOffset, CG_GetStringEdString("SP_INGAME", showPowersName[cg.forceSelect]), UI_CENTER | UI_SMALLFONT, colorTable[CT_ICON_BLUE])
    }
}

/**
```
===================
CG_DrawInventorySelect
===================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:1585
func CG_DrawInvenSelect() {
    var i: Int32
    let sideMax: Int32
    let holdCount: Int32
    var iconCnt: Int32
    let smallIconSize: Int32
    let bigIconSize: Int32
    var sideLeftIconCnt: Int32
    var sideRightIconCnt: Int32
    var count: Int32
    var holdX: Int32
    let x: Int32
    let y: Int32
    let y2: Int32
    let pad: Int32
    var height: Int32
    var addX: Float

    // don't display if dead
    if cg.snap!.ps.stats[STAT_HEALTH] <= 0 {
        return
    }

    if (cg.invenSelectTime + WEAPON_SELECT_TIME) < cg.time {
        return
    }

    if cg.snap!.ps.stats[STAT_HOLDABLE_ITEM] == 0 || cg.snap!.ps.stats[STAT_HOLDABLE_ITEMS] == 0 {
        return
    }


    if cg.itemSelect == -1 {
        cg.itemSelect = bg_itemlist[cg.snap!.ps.stats[STAT_HOLDABLE_ITEM]].giTag
    }

    //const int bits = cg.snap->ps.stats[ STAT_ITEMS ];

    // count the number of items owned
    count = 0
    i = 0
    while i < HI_NUM_HOLDABLE {
        if (cg.snap!.ps.stats[STAT_HOLDABLE_ITEMS] & (1 << i)) != 0 {
            count += 1
        }
        i += 1
    }

    if count == 0 {
        y2 = 0 //err?
        UI_DrawProportionalString(320, y2 + 22, "EMPTY INVENTORY", UI_CENTER | UI_SMALLFONT, colorTable[CT_ICON_BLUE])
        return
    }

    sideMax = 3 // Max number of icons on the side

    // Calculate how many icons will appear to either side of the center one
    holdCount = count - 1 // -1 for the center icon
    if holdCount == 0 {
        sideLeftIconCnt = 0
        sideRightIconCnt = 0
    } else if count > (2 * sideMax) {
        sideLeftIconCnt = sideMax
        sideRightIconCnt = sideMax
    } else {
        sideLeftIconCnt = holdCount / 2
        sideRightIconCnt = holdCount - sideLeftIconCnt
    }

    i = cg.itemSelect - 1
    if i < 0 {
        i = HI_NUM_HOLDABLE - 1
    }

    smallIconSize = 40
    bigIconSize = 80
    pad = 16

    x = 320
    y = 410

    // Left side ICONS
    // Work backwards from current icon
    holdX = x - ((bigIconSize / 2) + pad + smallIconSize)
    height = Int32(smallIconSize * cg.iconHUDPercent)
    addX = Float(Double(Float(smallIconSize)) * 0.75)

    iconCnt = 0
    while iconCnt < sideLeftIconCnt {
        if i < 0 {
            i = HI_NUM_HOLDABLE - 1
        }

        if !((cg.snap!.ps.stats[STAT_HOLDABLE_ITEMS] & (1 << i)) != 0) || i == cg.itemSelect {
            i -= 1
            continue
        }

        iconCnt += 1 // Good icon

        if !BG_IsItemSelectable(cg.predictedPlayerState, i) {
            i -= 1
            continue
        }

        if cgs.media.invenIcons[i] != 0 {
            trap_R_SetColor(nil)
            CG_DrawPic(Float(holdX), Float(y + 10), Float(smallIconSize), Float(smallIconSize), cgs.media.invenIcons[i])

            trap_R_SetColor(colorTable[CT_ICON_BLUE])
            /*CG_DrawNumField (holdX + addX, y + smallIconSize, 2, cg.snap->ps.inventory[i], 6, 12,
            NUM_FONT_SMALL,qfalse);
            */

            holdX -= (smallIconSize + pad)
        }
        i -= 1
    }

    // Current Center Icon
    height = Int32(bigIconSize * cg.iconHUDPercent)
    if cgs.media.invenIcons[cg.itemSelect] != 0 && BG_IsItemSelectable(cg.predictedPlayerState, cg.itemSelect) {
        let itemNdex: Int32
        trap_R_SetColor(nil)
        CG_DrawPic(Float(x - (bigIconSize / 2)), Float((y - ((bigIconSize - smallIconSize) / 2)) + 10), Float(bigIconSize), Float(bigIconSize), cgs.media.invenIcons[cg.itemSelect])
        addX = Float(Double(Float(bigIconSize)) * 0.75)
        trap_R_SetColor(colorTable[CT_ICON_BLUE])
        /*CG_DrawNumField ((x-(bigIconSize/2)) + addX, y, 2, cg.snap->ps.inventory[cg.inventorySelect], 6, 12,
        NUM_FONT_SMALL,qfalse);*/

        itemNdex = BG_GetItemIndexByTag(cg.itemSelect, IT_HOLDABLE)
        if bg_itemlist[itemNdex].classname != nil {
            var textColor = vec4_t(0.312, 0.75, 0.621, 1.0)
            var text = CharBuf(1024)
            var upperKey = CharBuf(1024)

            strcpy(&upperKey, bg_itemlist[itemNdex].classname!)

            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'CharBuf' to expected argument type 'String'".
            // Raven wrote: if ( trap_SP_GetStringTextString( va("SP_INGAME_%s",Q_strupr(upperKey)), text, sizeof( text ))) { UI_DrawProportionalString(320, y+45, text, UI_CENTER | UI_SMALLFONT, textColor); } else { UI_DrawProportionalString(320, y+45, bg_itemlist[itemNdex].classname, UI_CENTER | UI_SMALLFONT, textColor); }
            portMissing("CG_DrawInvenSelect", source: "oracle/codemp/cgame/cg_draw.c:1585")
        }
    }

    i = cg.itemSelect + 1
    if i > HI_NUM_HOLDABLE - 1 {
        i = 0
    }

    // Right side ICONS
    // Work forwards from current icon
    holdX = x + (bigIconSize / 2) + pad
    height = Int32(smallIconSize * cg.iconHUDPercent)
    addX = Float(Double(Float(smallIconSize)) * 0.75)
    iconCnt = 0
    while iconCnt < sideRightIconCnt {
        if i > HI_NUM_HOLDABLE - 1 {
            i = 0
        }

        if !((cg.snap!.ps.stats[STAT_HOLDABLE_ITEMS] & (1 << i)) != 0) || i == cg.itemSelect {
            i += 1
            continue
        }

        iconCnt += 1 // Good icon

        if !BG_IsItemSelectable(cg.predictedPlayerState, i) {
            i += 1
            continue
        }

        if cgs.media.invenIcons[i] != 0 {
            trap_R_SetColor(nil)
            CG_DrawPic(Float(holdX), Float(y + 10), Float(smallIconSize), Float(smallIconSize), cgs.media.invenIcons[i])

            trap_R_SetColor(colorTable[CT_ICON_BLUE])
            /*CG_DrawNumField (holdX + addX, y + smallIconSize, 2, cg.snap->ps.inventory[i], 6, 12,
            NUM_FONT_SMALL,qfalse);*/

            holdX += (smallIconSize + pad)
        }
        i += 1
    }
}

/// Source: oracle/codemp/cgame/cg_draw.c:1793
func CG_CheckTargetVehicle(_ pTargetVeh: inout Centity?, _ alpha: inout Float) -> Bool {
    var targetNum: Int32 = ENTITYNUM_NONE
    var targetVeh: Centity? = nil


    alpha = 1.0

    //FIXME: need to clear all of these when you die?
    if cg.predictedPlayerState.rocketLockIndex < ENTITYNUM_WORLD {
        targetNum = cg.predictedPlayerState.rocketLockIndex
    } else if cg.crosshairVehNum < ENTITYNUM_WORLD && cg.time - cg.crosshairVehTime < 3000 {
        //crosshair was on a vehicle in the last 3 seconds
        targetNum = cg.crosshairVehNum
    } else if cg.crosshairClientNum < ENTITYNUM_WORLD {
        targetNum = cg.crosshairClientNum
    }

    if targetNum < MAX_CLIENTS {
        //real client
        if cg_entities[targetNum].currentState.m_iVehicleNum >= MAX_CLIENTS {
            //in a vehicle
            targetNum = cg_entities[targetNum].currentState.m_iVehicleNum
        }
    }
    if targetNum < ENTITYNUM_WORLD && targetNum >= MAX_CLIENTS {
        var targetVeh: Centity? = cg_entities[targetNum]
        if targetVeh!.currentState.NPC_class == CLASS_VEHICLE && targetVeh!.m_pVehicle != nil && targetVeh!.m_pVehicle!.m_pVehicleInfo != nil && targetVeh!.m_pVehicle!.m_pVehicleInfo!.type == VH_FIGHTER {
            //it's a vehicle
            cg_targVeh = targetNum
            cg_targVehLastTime = cg.time
            alpha = 1.0
        } else {
            targetVeh = nil
        }
    }
    if targetVeh == nil {
        if cg_targVehLastTime != 0 && cg.time - cg_targVehLastTime < 3000 {
            targetVeh = cg_entities[cg_targVeh]
            if cg.time - cg_targVehLastTime < 1000 {
                //stay at full alpha for 1 sec after lose them from crosshair
                alpha = 1.0
            } else {
                //fade out over 2 secs
                alpha = 1.0 - ((cg.time - cg_targVehLastTime - 1000) / 2000.0)
            }
        }
    }
    if targetVeh != nil {
        pTargetVeh = targetVeh!
        return true
    }
    return false
}

/// Source: oracle/codemp/cgame/cg_draw.c:1873
func CG_DrawVehicleShields(_ menuHUD: MenuDef, _ veh: Centity) -> Float {
    var i: Int32
    var itemName = CharBuf(64)
    let inc: Float
    var currValue: Float
    let maxShields: Float
    var calcColor = vec4_t()
    var item: ItemDef?
    let percShields: Float

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
    // Raven wrote: item = Menu_FindItemByName((menuDef_t *) menuHUD, "armorbackground")
    portMissing("CG_DrawVehicleShields", source: "oracle/codemp/cgame/cg_draw.c:1873")

    if item != nil {
        trap_R_SetColor(vec4_t(item!.window.foreColor[0], item!.window.foreColor[1], item!.window.foreColor[2], item!.window.foreColor[3]))
        CG_DrawPic(item!.window.rect.x, item!.window.rect.y, item!.window.rect.w, item!.window.rect.h, item!.window.background)
    }

    maxShields = Float(veh.m_pVehicle!.m_pVehicleInfo!.shields)
    currValue = Float(cg.predictedVehicleState.stats[STAT_ARMOR])
    percShields = Float(currValue) / Float(maxShields)
    // Print all the tics of the shield graphic
    // Look at the amount of health left and show only as much of the graphic as there is health.
    // Use alpha to fade out partial section of health
    inc = Float(maxShields) / MAX_VHUD_ARMOR_TICS
    i = 1
    while i <= MAX_VHUD_ARMOR_TICS {
        // Raven wrote: sprintf( itemName, "armor_tic%d", i )
        strcpy(&itemName, va("armor_tic%d", i))

        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
        // Raven wrote: item = Menu_FindItemByName((menuDef_t *) menuHUD, itemName)
        portMissing("CG_DrawVehicleShields", source: "oracle/codemp/cgame/cg_draw.c:1873")

        if item == nil {
            i += 1
            continue
        }

        // Raven wrote: memcpy(calcColor, item->window.foreColor, sizeof(vec4_t))
        calcColor = vec4_t(item!.window.foreColor[0], item!.window.foreColor[1], item!.window.foreColor[2], item!.window.foreColor[3])

        if currValue <= 0 {
            break
        } else if currValue < inc {
            let percent: Float = currValue / inc
            calcColor[3] *= percent // Fade it out
        }

        trap_R_SetColor(calcColor)

        CG_DrawPic(item!.window.rect.x, item!.window.rect.y, item!.window.rect.w, item!.window.rect.h, item!.window.background)

        currValue -= inc
        i += 1
    }

    return percShields
}

/// Source: oracle/codemp/cgame/cg_draw.c:1942
func CG_DrawVehicleAmmo(_ menuHUD: MenuDef, _ veh: Centity) {
    var i: Int32
    var itemName = CharBuf(64)
    let inc: Float
    var currValue: Float
    let maxAmmo: Float
    var calcColor = vec4_t()
    var item: ItemDef?

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
    // Raven wrote: item = Menu_FindItemByName((menuDef_t *) menuHUD, "ammobackground")
    portMissing("CG_DrawVehicleAmmo", source: "oracle/codemp/cgame/cg_draw.c:1942")

    if item != nil {
        trap_R_SetColor(vec4_t(item!.window.foreColor[0], item!.window.foreColor[1], item!.window.foreColor[2], item!.window.foreColor[3]))
        CG_DrawPic(item!.window.rect.x, item!.window.rect.y, item!.window.rect.w, item!.window.rect.h, item!.window.background)
    }

    maxAmmo = Float(veh.m_pVehicle!.m_pVehicleInfo!.weapon[0].ammoMax)
    currValue = Float(cg.predictedVehicleState.ammo[0])

    inc = Float(maxAmmo) / MAX_VHUD_AMMO_TICS
    i = 1
    while i <= MAX_VHUD_AMMO_TICS {
        // Raven wrote: sprintf( itemName, "ammo_tic%d", i )
        strcpy(&itemName, va("ammo_tic%d", i))

        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
        // Raven wrote: item = Menu_FindItemByName((menuDef_t *)menuHUD, itemName)
        portMissing("CG_DrawVehicleAmmo", source: "oracle/codemp/cgame/cg_draw.c:1942")

        if item == nil {
            i += 1
            continue
        }

        if cg_vehicleAmmoWarningTime > cg.time && cg_vehicleAmmoWarning == 0 {
            // Port-note: Raven's `memcpy(calcColor, g_color_table[ColorIndex(COLOR_RED)], sizeof(vec4_t))` runs over bytes that are not one record with a view.
            // Raven wrote: memcpy(calcColor, g_color_table[ColorIndex(COLOR_RED)], sizeof(vec4_t))
            portMissing("CG_DrawVehicleAmmo", source: "oracle/codemp/cgame/cg_draw.c:1942")
            calcColor[3] = Float(sin(Double(cg.time) * 0.005) * 0.5 + 0.5)
        } else {
            // Raven wrote: memcpy(calcColor, item->window.foreColor, sizeof(vec4_t))
            calcColor = vec4_t(item!.window.foreColor[0], item!.window.foreColor[1], item!.window.foreColor[2], item!.window.foreColor[3])

            if currValue <= 0 {
                break
            } else if currValue < inc {
                let percent: Float = currValue / inc
                calcColor[3] *= percent // Fade it out
            }
        }

        trap_R_SetColor(calcColor)

        CG_DrawPic(item!.window.rect.x, item!.window.rect.y, item!.window.rect.w, item!.window.rect.h, item!.window.background)

        currValue -= inc
        i += 1
    }
}

/// Source: oracle/codemp/cgame/cg_draw.c:2013
func CG_DrawVehicleAmmoUpper(_ menuHUD: MenuDef, _ veh: Centity) {
    var i: Int32
    var itemName = CharBuf(64)
    let inc: Float
    var currValue: Float
    let maxAmmo: Float
    var calcColor = vec4_t()
    var item: ItemDef?

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
    // Raven wrote: item = Menu_FindItemByName((menuDef_t *)menuHUD, "ammoupperbackground")
    portMissing("CG_DrawVehicleAmmoUpper", source: "oracle/codemp/cgame/cg_draw.c:2013")

    if item != nil {
        trap_R_SetColor(vec4_t(item!.window.foreColor[0], item!.window.foreColor[1], item!.window.foreColor[2], item!.window.foreColor[3]))
        CG_DrawPic(item!.window.rect.x, item!.window.rect.y, item!.window.rect.w, item!.window.rect.h, item!.window.background)
    }

    maxAmmo = Float(veh.m_pVehicle!.m_pVehicleInfo!.weapon[0].ammoMax)
    currValue = Float(cg.predictedVehicleState.ammo[0])

    inc = Float(maxAmmo) / MAX_VHUD_AMMO_TICS
    i = 1
    while i < MAX_VHUD_AMMO_TICS {
        // Raven wrote: sprintf( itemName, "ammoupper_tic%d", i )
        strcpy(&itemName, va("ammoupper_tic%d", i))

        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
        // Raven wrote: item = Menu_FindItemByName((menuDef_t *)menuHUD, itemName)
        portMissing("CG_DrawVehicleAmmoUpper", source: "oracle/codemp/cgame/cg_draw.c:2013")

        if item == nil {
            i += 1
            continue
        }

        if cg_vehicleAmmoWarningTime > cg.time && cg_vehicleAmmoWarning == 0 {
            // Port-note: Raven's `memcpy(calcColor, g_color_table[ColorIndex(COLOR_RED)], sizeof(vec4_t))` runs over bytes that are not one record with a view.
            // Raven wrote: memcpy(calcColor, g_color_table[ColorIndex(COLOR_RED)], sizeof(vec4_t))
            portMissing("CG_DrawVehicleAmmoUpper", source: "oracle/codemp/cgame/cg_draw.c:2013")
            calcColor[3] = Float(sin(Double(cg.time) * 0.005) * 0.5 + 0.5)
        } else {
            // Raven wrote: memcpy(calcColor, item->window.foreColor, sizeof(vec4_t))
            calcColor = vec4_t(item!.window.foreColor[0], item!.window.foreColor[1], item!.window.foreColor[2], item!.window.foreColor[3])

            if currValue <= 0 {
                break
            } else if currValue < inc {
                let percent: Float = currValue / inc
                calcColor[3] *= percent // Fade it out
            }
        }

        trap_R_SetColor(calcColor)

        CG_DrawPic(item!.window.rect.x, item!.window.rect.y, item!.window.rect.w, item!.window.rect.h, item!.window.background)

        currValue -= inc
        i += 1
    }
}

/// Source: oracle/codemp/cgame/cg_draw.c:2084
func CG_DrawVehicleAmmoLower(_ menuHUD: MenuDef, _ veh: Centity) {
    var i: Int32
    var itemName = CharBuf(64)
    let inc: Float
    var currValue: Float
    let maxAmmo: Float
    var calcColor = vec4_t()
    var item: ItemDef?


    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
    // Raven wrote: item = Menu_FindItemByName((menuDef_t *)menuHUD, "ammolowerbackground")
    portMissing("CG_DrawVehicleAmmoLower", source: "oracle/codemp/cgame/cg_draw.c:2084")

    if item != nil {
        trap_R_SetColor(vec4_t(item!.window.foreColor[0], item!.window.foreColor[1], item!.window.foreColor[2], item!.window.foreColor[3]))
        CG_DrawPic(item!.window.rect.x, item!.window.rect.y, item!.window.rect.w, item!.window.rect.h, item!.window.background)
    }

    maxAmmo = Float(veh.m_pVehicle!.m_pVehicleInfo!.weapon[1].ammoMax)
    currValue = Float(cg.predictedVehicleState.ammo[1])

    inc = Float(maxAmmo) / MAX_VHUD_AMMO_TICS
    i = 1
    while i < MAX_VHUD_AMMO_TICS {
        // Raven wrote: sprintf( itemName, "ammolower_tic%d", i )
        strcpy(&itemName, va("ammolower_tic%d", i))

        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
        // Raven wrote: item = Menu_FindItemByName((menuDef_t *)menuHUD, itemName)
        portMissing("CG_DrawVehicleAmmoLower", source: "oracle/codemp/cgame/cg_draw.c:2084")

        if item == nil {
            i += 1
            continue
        }

        if cg_vehicleAmmoWarningTime > cg.time && cg_vehicleAmmoWarning == 1 {
            // Port-note: Raven's `memcpy(calcColor, g_color_table[ColorIndex(COLOR_RED)], sizeof(vec4_t))` runs over bytes that are not one record with a view.
            // Raven wrote: memcpy(calcColor, g_color_table[ColorIndex(COLOR_RED)], sizeof(vec4_t))
            portMissing("CG_DrawVehicleAmmoLower", source: "oracle/codemp/cgame/cg_draw.c:2084")
            calcColor[3] = Float(sin(Double(cg.time) * 0.005) * 0.5 + 0.5)
        } else {
            // Raven wrote: memcpy(calcColor, item->window.foreColor, sizeof(vec4_t))
            calcColor = vec4_t(item!.window.foreColor[0], item!.window.foreColor[1], item!.window.foreColor[2], item!.window.foreColor[3])

            if currValue <= 0 {
                break
            } else if currValue < inc {
                let percent: Float = currValue / inc
                calcColor[3] *= percent // Fade it out
            }
        }

        trap_R_SetColor(calcColor)

        CG_DrawPic(item!.window.rect.x, item!.window.rect.y, item!.window.rect.w, item!.window.rect.h, item!.window.background)

        currValue -= inc
        i += 1
    }
}

// The HUD.menu file has the graphic print with a negative height, so it will print from the bottom up.
/// Source: oracle/codemp/cgame/cg_draw.c:2156
func CG_DrawVehicleTurboRecharge(_ menuHUD: MenuDef, _ veh: Centity) {
    var item: ItemDef?
    var height: Int32

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
    // Raven wrote: item = Menu_FindItemByName( (menuDef_t *) menuHUD, "turborecharge")
    portMissing("CG_DrawVehicleTurboRecharge", source: "oracle/codemp/cgame/cg_draw.c:2156")

    if item != nil {
        var percent: Float = 0.0
        let diff: Int32 = (cg.time - veh.m_pVehicle!.m_iTurboTime)

        height = Int32(item!.window.rect.h)

        if diff > veh.m_pVehicle!.m_pVehicleInfo!.turboRecharge {
            percent = 1.0
            trap_R_SetColor(colorTable[CT_GREEN])
        } else {
            percent = Float(diff) / veh.m_pVehicle!.m_pVehicleInfo!.turboRecharge
            if percent < 0.0 {
                percent = 0.0
            }
            trap_R_SetColor(colorTable[CT_RED])
        }

        height = Int32(Float(height) * percent)

        CG_DrawPic(item!.window.rect.x, item!.window.rect.y, item!.window.rect.w, Float(height), cgs.media.whiteShader)
    }
}

/// Source: oracle/codemp/cgame/cg_draw.c:2197
func CG_DrawVehicleWeaponsLinked(_ menuHUD: MenuDef, _ veh: Centity) {
    var drawLink: Bool = false
    if veh.m_pVehicle != nil && veh.m_pVehicle!.m_pVehicleInfo != nil && (veh.m_pVehicle!.m_pVehicleInfo!.weapon[0].linkable == 2 || veh.m_pVehicle!.m_pVehicleInfo!.weapon[1].linkable == 2) {
        //weapon is always linked
        drawLink = true
    } else {
        //MP way:
        //must get sent over network
        if cg.predictedVehicleState.vehWeaponsLinked {
            drawLink = true
        }
        //NOTE: below is SP way
        /*
        //just cheat it
        if ( veh->gent->m_pVehicle->weaponStatus[0].linked
        || veh->gent->m_pVehicle->weaponStatus[1].linked )
        {
        drawLink = qtrue;
        }
        */
    }

    if cg_drawLink != drawLink {
        //state changed, play sound
        cg_drawLink = drawLink
        // Port-note: Raven passes NULL for the `origin` input of `trap_S_StartSound`, and the engine then plays the sound at the entity. A zero vector plays it at the world origin, so the trap needs an optional `origin`.
        portMissing("CG_DrawVehicleWeaponsLinked", source: "oracle/codemp/cgame/cg_draw.c:2197")
        var scratchOrigin = vec3_t()
        trap_S_StartSound(&scratchOrigin, cg.predictedPlayerState.clientNum, CHAN_LOCAL, trap_S_RegisterSound("sound/vehicles/common/linkweaps.wav"))
    }

    if drawLink {
        var item: ItemDef?

        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
        // Raven wrote: item = Menu_FindItemByName( (menuDef_t *) menuHUD, "weaponslinked")
        portMissing("CG_DrawVehicleWeaponsLinked", source: "oracle/codemp/cgame/cg_draw.c:2197")

        if item != nil {
            trap_R_SetColor(colorTable[CT_CYAN])

            CG_DrawPic(item!.window.rect.x, item!.window.rect.y, item!.window.rect.w, item!.window.rect.h, cgs.media.whiteShader)
        }
    }
}

/// Source: oracle/codemp/cgame/cg_draw.c:2251
func CG_DrawVehicleSpeed(_ menuHUD: MenuDef, _ veh: Centity) {
    var i: Int32
    var itemName = CharBuf(64)
    let inc: Float
    var currValue: Float
    let maxSpeed: Float
    var calcColor = vec4_t()
    var item: ItemDef?

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
    // Raven wrote: item = Menu_FindItemByName((menuDef_t *) menuHUD, "speedbackground")
    portMissing("CG_DrawVehicleSpeed", source: "oracle/codemp/cgame/cg_draw.c:2251")

    if item != nil {
        trap_R_SetColor(vec4_t(item!.window.foreColor[0], item!.window.foreColor[1], item!.window.foreColor[2], item!.window.foreColor[3]))
        CG_DrawPic(item!.window.rect.x, item!.window.rect.y, item!.window.rect.w, item!.window.rect.h, item!.window.background)
    }

    maxSpeed = veh.m_pVehicle!.m_pVehicleInfo!.speedMax
    currValue = cg.predictedVehicleState.speed


    // Print all the tics of the shield graphic
    // Look at the amount of health left and show only as much of the graphic as there is health.
    // Use alpha to fade out partial section of health
    inc = Float(maxSpeed) / MAX_VHUD_SPEED_TICS
    i = 1
    while i <= MAX_VHUD_SPEED_TICS {
        // Raven wrote: sprintf( itemName, "speed_tic%d", i )
        strcpy(&itemName, va("speed_tic%d", i))

        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
        // Raven wrote: item = Menu_FindItemByName((menuDef_t *)menuHUD, itemName)
        portMissing("CG_DrawVehicleSpeed", source: "oracle/codemp/cgame/cg_draw.c:2251")

        if item == nil {
            i += 1
            continue
        }

        if cg.time > veh.m_pVehicle!.m_iTurboTime {
            // Raven wrote: memcpy(calcColor, item->window.foreColor, sizeof(vec4_t))
            calcColor = vec4_t(item!.window.foreColor[0], item!.window.foreColor[1], item!.window.foreColor[2], item!.window.foreColor[3])
        } else {
            if cg.VHUDFlashTime < cg.time {
                cg.VHUDFlashTime = cg.time + 200
                if cg.VHUDTurboFlag {
                    cg.VHUDTurboFlag = false
                } else {
                    cg.VHUDTurboFlag = true
                }
            }

            if cg.VHUDTurboFlag {
                // Raven wrote: memcpy(calcColor, colorTable[CT_LTRED1], sizeof(vec4_t))
                calcColor = colorTable[CT_LTRED1]
            } else {
                // Raven wrote: memcpy(calcColor, item->window.foreColor, sizeof(vec4_t))
                calcColor = vec4_t(item!.window.foreColor[0], item!.window.foreColor[1], item!.window.foreColor[2], item!.window.foreColor[3])
            }
        }


        if currValue <= 0 {
            break
        } else if currValue < inc {
            let percent: Float = currValue / inc
            calcColor[3] *= percent // Fade it out
        }

        trap_R_SetColor(calcColor)

        CG_DrawPic(item!.window.rect.x, item!.window.rect.y, item!.window.rect.w, item!.window.rect.h, item!.window.background)

        currValue -= inc
        i += 1
    }
}

/// Source: oracle/codemp/cgame/cg_draw.c:2344
func CG_DrawVehicleArmor(_ menuHUD: MenuDef, _ veh: Centity) {
    var i: Int32
    var calcColor = vec4_t()
    var itemName = CharBuf(64)
    let inc: Float
    var currValue: Float
    let maxArmor: Float
    var item: ItemDef?

    maxArmor = Float(veh.m_pVehicle!.m_pVehicleInfo!.armor)
    currValue = Float(cg.predictedVehicleState.stats[STAT_HEALTH])

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
    // Raven wrote: item = Menu_FindItemByName( (menuDef_t *) menuHUD, "shieldbackground")
    portMissing("CG_DrawVehicleArmor", source: "oracle/codemp/cgame/cg_draw.c:2344")

    if item != nil {
        trap_R_SetColor(vec4_t(item!.window.foreColor[0], item!.window.foreColor[1], item!.window.foreColor[2], item!.window.foreColor[3]))
        CG_DrawPic(item!.window.rect.x, item!.window.rect.y, item!.window.rect.w, item!.window.rect.h, item!.window.background)
    }


    // Print all the tics of the shield graphic
    // Look at the amount of health left and show only as much of the graphic as there is health.
    // Use alpha to fade out partial section of health
    inc = Float(maxArmor) / MAX_VHUD_SHIELD_TICS
    i = 1
    while i <= MAX_VHUD_SHIELD_TICS {
        // Raven wrote: sprintf( itemName, "shield_tic%d", i )
        strcpy(&itemName, va("shield_tic%d", i))

        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
        // Raven wrote: item = Menu_FindItemByName((menuDef_t *) menuHUD, itemName)
        portMissing("CG_DrawVehicleArmor", source: "oracle/codemp/cgame/cg_draw.c:2344")

        if item == nil {
            i += 1
            continue
        }


        // Raven wrote: memcpy(calcColor, item->window.foreColor, sizeof(vec4_t))
        calcColor = vec4_t(item!.window.foreColor[0], item!.window.foreColor[1], item!.window.foreColor[2], item!.window.foreColor[3])

        if currValue <= 0 {
            break
        } else if currValue < inc {
            let percent: Float = currValue / inc
            calcColor[3] *= percent // Fade it out
        }

        trap_R_SetColor(calcColor)

        CG_DrawPic(item!.window.rect.x, item!.window.rect.y, item!.window.rect.w, item!.window.rect.h, item!.window.background)

        currValue -= inc
        i += 1
    }
}

// Draw health graphic for given part of vehicle
/// Source: oracle/codemp/cgame/cg_draw.c:2434
func CG_DrawVehicleDamage(_ veh: Centity, _ brokenLimbs: Int32, _ menuHUD: MenuDef, _ alpha: Float, _ index: Int32) {
    var item: ItemDef?
    var colorI: Int32
    var color = vec4_t()
    var graphicHandle: Int32 = 0

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
    // Raven wrote: item = Menu_FindItemByName((menuDef_t *)menuHUD, vehDamageData[index].itemName)
    portMissing("CG_DrawVehicleDamage", source: "oracle/codemp/cgame/cg_draw.c:2434")
    if item != nil {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'vehDamageData' in scope".
        // Raven wrote: if (brokenLimbs & (1<<vehDamageData[index].heavyDamage)) { colorI = CT_RED; if (brokenLimbs & (1<<vehDamageData[index].lightDamage)) { colorI = CT_DKGREY; } } else if (brokenLimbs & (1<<vehDamageData[index].lightDamage)) { colorI = CT_YELLOW; } else { colorI = CT_GREEN; }
        portMissing("CG_DrawVehicleDamage", source: "oracle/codemp/cgame/cg_draw.c:2434")

        // Raven wrote: VectorCopy4 ( colorTable[colorI], color )
        color = colorTable[colorI]
        color[3] = alpha
        trap_R_SetColor(color)

        switch index {
        case VEH_DAMAGE_FRONT:
            graphicHandle = veh.m_pVehicle!.m_pVehicleInfo!.iconFrontHandle

        case VEH_DAMAGE_BACK:
            graphicHandle = veh.m_pVehicle!.m_pVehicleInfo!.iconBackHandle

        case VEH_DAMAGE_LEFT:
            graphicHandle = veh.m_pVehicle!.m_pVehicleInfo!.iconLeftHandle

        case VEH_DAMAGE_RIGHT:
            graphicHandle = veh.m_pVehicle!.m_pVehicleInfo!.iconRightHandle

        default:
            break
        }

        if graphicHandle != 0 {
            CG_DrawPic(item!.window.rect.x, item!.window.rect.y, item!.window.rect.w, item!.window.rect.h, graphicHandle)
        }
    }
}

// Used on both damage indicators :  player vehicle and the vehicle the player is locked on
/// Source: oracle/codemp/cgame/cg_draw.c:2495
func CG_DrawVehicleDamageHUD(_ veh: Centity, _ brokenLimbs: Int32, _ percShields: Float, _ menuName: String, _ alpha: Float) {
    var menuHUD: MenuDef?
    var item: ItemDef?
    var color = vec4_t()

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menus_FindByName' in scope".
    // Raven wrote: menuHUD = Menus_FindByName(menuName)
    portMissing("CG_DrawVehicleDamageHUD", source: "oracle/codemp/cgame/cg_draw.c:2495")

    if menuHUD == nil {
        return
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
    // Raven wrote: item = Menu_FindItemByName(menuHUD, "background")
    portMissing("CG_DrawVehicleDamageHUD", source: "oracle/codemp/cgame/cg_draw.c:2495")
    if item != nil {
        if veh.m_pVehicle!.m_pVehicleInfo!.dmgIndicBackgroundHandle != 0 {
            if veh.damageTime > cg.time {
                //ship shields currently taking damage
                //NOTE: cent->damageAngle can be accessed to get the direction from the ship origin to the impact point (in 3-D space)
                var perc: Float = 1.0 - ((veh.damageTime - cg.time) / 2000.0)
                if perc < 0.0 {
                    perc = 0.0
                } else if perc > 1.0 {
                    perc = 1.0
                }
                color[0] = item!.window.foreColor[0] //flash red
                color[1] = item!.window.foreColor[1] * perc //fade other colors back in over time
                color[2] = item!.window.foreColor[2] * perc //fade other colors back in over time
                color[3] = item!.window.foreColor[3] //always normal alpha
                trap_R_SetColor(color)
            } else {
                trap_R_SetColor(vec4_t(item!.window.foreColor[0], item!.window.foreColor[1], item!.window.foreColor[2], item!.window.foreColor[3]))
            }

            CG_DrawPic(item!.window.rect.x, item!.window.rect.y, item!.window.rect.w, item!.window.rect.h, veh.m_pVehicle!.m_pVehicleInfo!.dmgIndicBackgroundHandle)
        }
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
    // Raven wrote: item = Menu_FindItemByName(menuHUD, "outer_frame")
    portMissing("CG_DrawVehicleDamageHUD", source: "oracle/codemp/cgame/cg_draw.c:2495")
    if item != nil {
        if veh.m_pVehicle!.m_pVehicleInfo!.dmgIndicFrameHandle != 0 {
            trap_R_SetColor(vec4_t(item!.window.foreColor[0], item!.window.foreColor[1], item!.window.foreColor[2], item!.window.foreColor[3]))
            CG_DrawPic(item!.window.rect.x, item!.window.rect.y, item!.window.rect.w, item!.window.rect.h, veh.m_pVehicle!.m_pVehicleInfo!.dmgIndicFrameHandle)
        }
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
    // Raven wrote: item = Menu_FindItemByName(menuHUD, "shields")
    portMissing("CG_DrawVehicleDamageHUD", source: "oracle/codemp/cgame/cg_draw.c:2495")
    if item != nil {
        if veh.m_pVehicle!.m_pVehicleInfo!.dmgIndicShieldHandle != 0 {
            // Raven wrote: VectorCopy4 ( colorTable[CT_HUD_GREEN], color )
            color = colorTable[CT_HUD_GREEN]
            color[3] = percShields
            trap_R_SetColor(color)
            CG_DrawPic(item!.window.rect.x, item!.window.rect.y, item!.window.rect.w, item!.window.rect.h, veh.m_pVehicle!.m_pVehicleInfo!.dmgIndicShieldHandle)
        }
    }

    //TODO: if we check nextState.brokenLimbs & prevState.brokenLimbs, we can tell when a damage flag has been added and flash that part of the ship
    //FIXME: when ship explodes, either stop drawing ship or draw all parts black
    CG_DrawVehicleDamage(veh, brokenLimbs, menuHUD!, alpha, VEH_DAMAGE_FRONT)
    CG_DrawVehicleDamage(veh, brokenLimbs, menuHUD!, alpha, VEH_DAMAGE_BACK)
    CG_DrawVehicleDamage(veh, brokenLimbs, menuHUD!, alpha, VEH_DAMAGE_LEFT)
    CG_DrawVehicleDamage(veh, brokenLimbs, menuHUD!, alpha, VEH_DAMAGE_RIGHT)
}

/// Source: oracle/codemp/cgame/cg_draw.c:2585
func CG_DrawVehicleHud(_ cent: Centity) -> Bool {
    var item: ItemDef?
    var menuHUD: MenuDef?
    var ps: PlayerState?
    var veh: Centity?
    let shieldPerc: Float
    var alpha: Float = 0

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menus_FindByName' in scope".
    // Raven wrote: menuHUD = Menus_FindByName("swoopvehiclehud")
    portMissing("CG_DrawVehicleHud", source: "oracle/codemp/cgame/cg_draw.c:2585")
    if menuHUD == nil {
        return true // Draw player HUD
    }

    ps = cg.predictedPlayerState

    if ps == nil || !(ps!.m_iVehicleNum != 0) {
        return true // Draw player HUD
    }
    veh = cg_entities[ps!.m_iVehicleNum]

    if veh == nil {
        return true // Draw player HUD
    }

    CG_DrawVehicleTurboRecharge(menuHUD!, veh!)
    CG_DrawVehicleWeaponsLinked(menuHUD!, veh!)

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
    // Raven wrote: item = Menu_FindItemByName(menuHUD, "leftframe")
    portMissing("CG_DrawVehicleHud", source: "oracle/codemp/cgame/cg_draw.c:2585")

    // Draw frame
    if item != nil {
        trap_R_SetColor(vec4_t(item!.window.foreColor[0], item!.window.foreColor[1], item!.window.foreColor[2], item!.window.foreColor[3]))
        CG_DrawPic(item!.window.rect.x, item!.window.rect.y, item!.window.rect.w, item!.window.rect.h, item!.window.background)
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
    // Raven wrote: item = Menu_FindItemByName(menuHUD, "rightframe")
    portMissing("CG_DrawVehicleHud", source: "oracle/codemp/cgame/cg_draw.c:2585")

    if item != nil {
        trap_R_SetColor(vec4_t(item!.window.foreColor[0], item!.window.foreColor[1], item!.window.foreColor[2], item!.window.foreColor[3]))
        CG_DrawPic(item!.window.rect.x, item!.window.rect.y, item!.window.rect.w, item!.window.rect.h, item!.window.background)
    }


    CG_DrawVehicleArmor(menuHUD!, veh!)

    // Get animal hud for speed
    //	if (veh->m_pVehicle->m_pVehicleInfo->type == VH_ANIMAL)
    //	{
    //		menuHUD = Menus_FindByName("tauntaunhud");
    //	}


    CG_DrawVehicleSpeed(menuHUD!, veh!)

    // Revert to swoophud
    //	if (veh->m_pVehicle->m_pVehicleInfo->type == VH_ANIMAL)
    //	{
    //		menuHUD = Menus_FindByName("swoopvehiclehud");
    //	}

    //	if (veh->m_pVehicle->m_pVehicleInfo->type == VH_ANIMAL)
    //	{
    shieldPerc = CG_DrawVehicleShields(menuHUD!, veh!)
    //	}

    if veh!.m_pVehicle!.m_pVehicleInfo!.weapon[0].ID != 0 && veh!.m_pVehicle!.m_pVehicleInfo!.weapon[1].ID == 0 {
        CG_DrawVehicleAmmo(menuHUD!, veh!)
    } else if veh!.m_pVehicle!.m_pVehicleInfo!.weapon[0].ID != 0 && veh!.m_pVehicle!.m_pVehicleInfo!.weapon[1].ID != 0 {
        CG_DrawVehicleAmmoUpper(menuHUD!, veh!)
        CG_DrawVehicleAmmoLower(menuHUD!, veh!)
    }

    // If he's hidden, he must be in a vehicle
    if veh!.m_pVehicle!.m_pVehicleInfo!.hideRider {
        CG_DrawVehicleDamageHUD(veh!, cg.predictedVehicleState.brokenLimbs, shieldPerc, "vehicledamagehud", 1.0)

        // Has he targeted an enemy?
        if CG_CheckTargetVehicle(&veh, &alpha) {
            CG_DrawVehicleDamageHUD(veh!, veh!.currentState.brokenLimbs, (Float(veh!.currentState.activeForcePass) / 10.0), "enemyvehicledamagehud", alpha)
        }

        return false // Don't draw player HUD
    }

    return true // Draw player HUD
}

/**
```
================
CG_DrawStats

================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:2699
private func CG_DrawStats() {
    var cent: Centity?
    var ps: PlayerState?
    var drawHUD: Bool = true
    /*	playerState_t	*ps;
    vec3_t			angles;
    //	vec3_t		origin;

    if ( cg_drawStatus.integer == 0 ) {
    return;
    }
    */
    cent = cg_entities[cg.snap!.ps.clientNum]
    /*	ps = &cg.snap->ps;

    VectorClear( angles );

    // Do start
    if (!cg.interfaceStartupDone)
    {
    CG_InterfaceStartup();
    }

    cgi_UI_MenuPaintAll();*/

    if cent != nil {
        ps = cg.predictedPlayerState

        if ps!.m_iVehicleNum != 0 {
            drawHUD = CG_DrawVehicleHud(cent!)
        }
    }

    if drawHUD {
        CG_DrawHUD(cent!)
    }

    /*CG_DrawArmor(cent);
    CG_DrawHealth(cent);
    CG_DrawAmmo(cent);

    CG_DrawTalk(cent);*/
}

/**
```
===================
CG_DrawPickupItem
===================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:2752
private func CG_DrawPickupItem() {
    let value: Int32
    // Port-note: A pointer local `float * fadeColor` with no view.
    // Raven wrote: float *fadeColor;
    portMissing("CG_DrawPickupItem", source: "oracle/codemp/cgame/cg_draw.c:2752")

    value = cg.itemPickup
    if value != 0 && cg_items[value].icon != -1 {
        // Port-note: A store into `fadeColor`, a local the draft left as a hole.
        // Raven wrote: fadeColor = CG_FadeColor( cg.itemPickupTime, 3000 )
        portMissing("CG_DrawPickupItem", source: "oracle/codemp/cgame/cg_draw.c:2752")
        // Port-note: A read of `fadeColor`, a local the draft left as a hole.
        // Raven wrote: if ( fadeColor ) { CG_RegisterItemVisuals( value ); trap_R_SetColor( fadeColor ); CG_DrawPic( 573, 320, ICON_SIZE, ICON_SIZE, cg_items[ value ].icon ); trap_R_SetColor( NULL ); }
        portMissing("CG_DrawPickupItem", source: "oracle/codemp/cgame/cg_draw.c:2752")
    }
}

/**
```
================
CG_DrawTeamBackground

================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:2776
func CG_DrawTeamBackground(_ x: Int32, _ y: Int32, _ w: Int32, _ h: Int32, _ alpha: Float, _ team: Int32) {
    var hcolor = vec4_t()

    hcolor[3] = alpha
    if team == TEAM_RED {
        hcolor[0] = 1
        hcolor[1] = 0.2
        hcolor[2] = 0.2
    } else if team == TEAM_BLUE {
        hcolor[0] = 0.2
        hcolor[1] = 0.2
        hcolor[2] = 1
    } else {
        return
    }
    //	trap_R_SetColor( hcolor );

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
    // Raven wrote: CG_FillRect ( x, y, w, h, hcolor )
    portMissing("CG_DrawTeamBackground", source: "oracle/codemp/cgame/cg_draw.c:2776")
    //	CG_DrawPic( x, y, w, h, cgs.media.teamStatusBar );
    trap_R_SetColor(nil)
}

/**
```
================
CG_DrawMiniScoreboard
================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:2813
private func CG_DrawMiniScoreboard(_ y: Float) -> Float {
    var temp = CharBuf(64)
    let xOffset: Int32 = 0
    // Raven assigns his own `y` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var y = y


    if cg_drawScores.integer == 0 {
        return y
    }

    if cgs.gametype == GT_SIEGE {
        //don't bother with this in siege
        return y
    }

    if cgs.gametype >= GT_TEAM {
        strcpy(&temp, va("%s: ", CG_GetStringEdString("MP_INGAME", "RED")))
        Q_strcat(&temp, MAX_QPATH, cgs.scores1 == SCORE_NOT_PRESENT ? "-" : (va("%i", cgs.scores1)))
        Q_strcat(&temp, MAX_QPATH, va(" %s: ", CG_GetStringEdString("MP_INGAME", "BLUE")))
        Q_strcat(&temp, MAX_QPATH, cgs.scores2 == SCORE_NOT_PRESENT ? "-" : (va("%i", cgs.scores2)))

        CG_Text_Paint(Float(630 - CG_Text_Width(String(temp), 0.7, FONT_MEDIUM) + xOffset), y, 0.7, colorWhite, String(temp), 0, 0, ITEM_TEXTSTYLE_SHADOWEDMORE, FONT_MEDIUM)
        y += 15
    } else {
        /*
        strcpy ( temp, "1st: " );
        Q_strcat ( temp, MAX_QPATH, cgs.scores1==SCORE_NOT_PRESENT?"-":(va("%i",cgs.scores1)) );

        Q_strcat ( temp, MAX_QPATH, " 2nd: " );
        Q_strcat ( temp, MAX_QPATH, cgs.scores2==SCORE_NOT_PRESENT?"-":(va("%i",cgs.scores2)) );

        CG_Text_Paint( 630 - CG_Text_Width ( temp, 0.7f, FONT_SMALL ), y, 0.7f, colorWhite, temp, 0, 0, ITEM_TEXTSTYLE_SHADOWEDMORE, FONT_MEDIUM );
        y += 15;
        */
        //rww - no longer doing this. Since the attacker now shows who is first, we print the score there.
    }


    return y
}

/**
```
================
CG_DrawEnemyInfo
================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:2866
private func CG_DrawEnemyInfo(_ y: Float) -> Float {
    var size: Float
    var clientNum: Int32
    var title: String
    var ci: ClientInfo?
    let xOffset: Int32 = 0
    // Raven assigns his own `y` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var y = y

    if cg.snap == nil {
        return y
    }


    if cg_drawEnemyInfo.integer == 0 {
        return y
    }

    if cg.predictedPlayerState.stats[STAT_HEALTH] <= 0 {
        return y
    }

    if cgs.gametype == GT_POWERDUEL {
        //just get out of here then
        return y
    }

    if cgs.gametype == GT_JEDIMASTER {
        //title = "Jedi Master";
        title = CG_GetStringEdString("MP_INGAME", "MASTERY7")
        clientNum = cgs.jediMaster

        if clientNum < 0 {
            //return y;
            //			title = "Get Saber!";
            title = CG_GetStringEdString("MP_INGAME", "GET_SABER")


            size = Float(Double(ICON_SIZE) * 1.25)
            y += 5

            CG_DrawPic(640 - size - 12 + xOffset, y, size, size, cgs.media.weaponIcons[WP_SABER])

            y += size

            /*
            CG_Text_Paint( 630 - CG_Text_Width ( ci->name, 0.7f, FONT_MEDIUM ), y, 0.7f, colorWhite, ci->name, 0, 0, 0, FONT_MEDIUM );
            y += 15;
            */

            CG_Text_Paint(Float(630 - CG_Text_Width(title, 0.7, FONT_MEDIUM) + xOffset), y, 0.7, colorWhite, title, 0, 0, 0, FONT_MEDIUM)

            return y + BIGCHAR_HEIGHT + 2
        }
    } else if cg.snap!.ps.duelInProgress {
        //		title = "Dueling";
        title = CG_GetStringEdString("MP_INGAME", "DUELING")
        clientNum = cg.snap!.ps.duelIndex
    } else if cgs.gametype == GT_DUEL && cgs.clientinfo[cg.snap!.ps.clientNum].team != TEAM_SPECTATOR {
        title = CG_GetStringEdString("MP_INGAME", "DUELING")
        if cg.snap!.ps.clientNum == cgs.duelist1 {
            clientNum = cgs.duelist2 //if power duel, should actually draw both duelists 2 and 3 I guess
        } else if cg.snap!.ps.clientNum == cgs.duelist2 {
            clientNum = cgs.duelist1
        } else if cg.snap!.ps.clientNum == cgs.duelist3 {
            clientNum = cgs.duelist1
        } else {
            return y
        }
    } else {
        /*
        title = "Attacker";
        clientNum = cg.predictedPlayerState.persistant[PERS_ATTACKER];

        if ( clientNum < 0 || clientNum >= MAX_CLIENTS || clientNum == cg.snap->ps.clientNum )
        {
        return y;
        }

        if ( cg.time - cg.attackerTime > ATTACKER_HEAD_TIME )
        {
        cg.attackerTime = 0;
        return y;
        }
        */
        //As of current, we don't want to draw the attacker. Instead, draw whoever is in first place.
        if cgs.duelWinner < 0 || cgs.duelWinner >= MAX_CLIENTS {
            return y
        }


        title = va("%s: %i", CG_GetStringEdString("MP_INGAME", "LEADER"), cgs.scores1)

        /*
        if (cgs.scores1 == 1)
        {
        title = va("%i kill", cgs.scores1);
        }
        else
        {
        title = va("%i kills", cgs.scores1);
        }
        */
        clientNum = cgs.duelWinner
    }

    if clientNum >= MAX_CLIENTS {
        return y
    }

    ci = cgs.clientinfo[clientNum]

    size = Float(Double(ICON_SIZE) * 1.25)
    y += 5

    if ci!.modelIcon != 0 {
        CG_DrawPic(640 - size - 5 + xOffset, y, size, size, ci!.modelIcon)
    }

    y += size

    //	CG_Text_Paint( 630 - CG_Text_Width ( ci->name, 0.7f, FONT_MEDIUM ) + xOffset, y, 0.7f, colorWhite, ci->name, 0, 0, 0, FONT_MEDIUM );
    CG_Text_Paint(Float(630 - CG_Text_Width(ci!.name, 1.0, FONT_SMALL2) + xOffset), y, 1.0, colorWhite, ci!.name, 0, 0, 0, FONT_SMALL2)

    y += 15
    //	CG_Text_Paint( 630 - CG_Text_Width ( title, 0.7f, FONT_MEDIUM ) + xOffset, y, 0.7f, colorWhite, title, 0, 0, 0, FONT_MEDIUM );
    CG_Text_Paint(Float(630 - CG_Text_Width(title, 1.0, FONT_SMALL2) + xOffset), y, 1.0, colorWhite, title, 0, 0, 0, FONT_SMALL2)

    if (cgs.gametype == GT_DUEL || cgs.gametype == GT_POWERDUEL) && cgs.clientinfo[cg.snap!.ps.clientNum].team != TEAM_SPECTATOR {
        //also print their score
        var text = CharBuf(1024)
        y += 15
        Com_sprintf(&text, Int32((text).count), "%i/%i", cgs.clientinfo[clientNum].score, cgs.fraglimit)
        CG_Text_Paint(Float(630 - CG_Text_Width(String(text), 0.7, FONT_MEDIUM) + xOffset), y, 0.7, colorWhite, String(text), 0, 0, 0, FONT_MEDIUM)
    }

    // nmckenzie: DUEL_HEALTH - fixme - need checks and such here.  And this is coded to duelist 1 right now, which is wrongly.
    if cgs.showDuelHealths >= 2 {
        y += 15
        if cgs.duelist1 == clientNum {
            CG_DrawDuelistHealth(640 - size - 5 + xOffset, y, 64, 8, 1)
        } else if cgs.duelist2 == clientNum {
            CG_DrawDuelistHealth(640 - size - 5 + xOffset, y, 64, 8, 2)
        }
    }

    return y + BIGCHAR_HEIGHT + 2
}

/**
```
==================
CG_DrawSnapshot
==================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:3047
private func CG_DrawSnapshot(_ y: Float) -> Float {
    let s: String
    let w: Int32
    let xOffset: Int32 = 0


    s = va("time:%i snap:%i cmd:%i", cg.snap!.serverTime, cg.latestSnapshotNum, cgs.serverCommandSequence)
    w = CG_DrawStrlen(s) * BIGCHAR_WIDTH

    CG_DrawBigString(635 - w + xOffset, Int32(y + 2), s, 1.0)

    return y + BIGCHAR_HEIGHT + 4
}

/// Source: oracle/codemp/cgame/cg_draw.c:3071
private func CG_DrawFPS(_ y: Float) -> Float {
    let s: String
    let w: Int32
    // Port-note: A static local `previousTimes` a statement writes, storage that outlives the call.
    // Raven wrote: static unsigned short previousTimes[FPS_FRAMES];
    portMissing("CG_DrawFPS", source: "oracle/codemp/cgame/cg_draw.c:3071")
    // Port-note: A static local `index` a statement reads before it writes, storage that outlives the call.
    // Raven wrote: static unsigned short index;
    portMissing("CG_DrawFPS", source: "oracle/codemp/cgame/cg_draw.c:3071")
    // Port-note: A static local `previous` a statement reads before it writes, storage that outlives the call.
    // Raven wrote: static int previous;
    portMissing("CG_DrawFPS", source: "oracle/codemp/cgame/cg_draw.c:3071")
    // Port-note: A static local `lastupdate` a statement reads before it writes, storage that outlives the call.
    // Raven wrote: lastupdate;
    portMissing("CG_DrawFPS", source: "oracle/codemp/cgame/cg_draw.c:3071")
    let t: Int32
    var i: Int32
    let fps: Int32
    var total: Int32
    let frameTime: UInt16
    let xOffset: Int32 = 0


    // don't use serverTime, because that will be drifting to
    // correct for internet lag changes, timescales, timedemos, etc
    t = trap_Milliseconds()
    // Port-note: A read of `previous`, a local the draft left as a hole.
    // Raven wrote: frameTime = t - previous
    portMissing("CG_DrawFPS", source: "oracle/codemp/cgame/cg_draw.c:3071")
    // Port-note: A store into `previous`, a local the draft left as a hole.
    // Raven wrote: previous = t
    portMissing("CG_DrawFPS", source: "oracle/codemp/cgame/cg_draw.c:3071")
    // Port-note: A read of `lastupdate`, a local the draft left as a hole.
    // Raven wrote: if (t - lastupdate > 50) //don't sample faster than this { lastupdate = t; previousTimes[index % FPS_FRAMES] = frameTime; index++; }
    portMissing("CG_DrawFPS", source: "oracle/codemp/cgame/cg_draw.c:3071")
    // average multiple frames together to smooth changes out a bit
    total = 0
    i = 0
    while i < FPS_FRAMES {
        // Port-note: A read of `previousTimes`, a local the draft left as a hole.
        // Raven wrote: total += previousTimes[i]
        portMissing("CG_DrawFPS", source: "oracle/codemp/cgame/cg_draw.c:3071")
        i += 1
    }
    if total == 0 {
        total = 1
    }
    fps = 1000 * FPS_FRAMES / total

    s = va("%ifps", fps)
    w = CG_DrawStrlen(s) * BIGCHAR_WIDTH

    CG_DrawBigString(635 - w + xOffset, Int32(y + 2), s, 1.0)

    return y + BIGCHAR_HEIGHT + 4
}

/// Source: oracle/codemp/cgame/cg_draw.c:3117
func CG_DrawHealthBarRough(_ x: Float, _ y: Float, _ width: Int32, _ height: Int32, _ ratio: Float, _ color1: Float, _ color2: Float) {
    let midpoint: Float
    let remainder: Float
    var color3: [Float] = [1, 0, 0, 0.7]

    midpoint = width * ratio - 1
    remainder = width - midpoint
    // Port-note: The draft of this statement did not compile, and the compiler wrote "value of type 'Float' has no subscripts".
    // Raven wrote: color3[0] = color1[0] * 0.5f
    portMissing("CG_DrawHealthBarRough", source: "oracle/codemp/cgame/cg_draw.c:3117")

    //this won't line up otherwise.
    CG_DrawRect(x + 1, y + height / 2 - 1, midpoint, 1, Float(height / 4 + 1), color1) // creme-y filling.
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type '[Float]' to expected argument type 'Float'".
    // Raven wrote: CG_DrawRect(x + midpoint, y + height/2-1, remainder, 1, height/4+1, color3)
    portMissing("CG_DrawHealthBarRough", source: "oracle/codemp/cgame/cg_draw.c:3117")
    CG_DrawRect(x, y, Float(width), Float(height), 1, color2) // hard crispy shell
}

/// Source: oracle/codemp/cgame/cg_draw.c:3132
func CG_DrawDuelistHealth(_ x: Float, _ y: Float, _ w: Float, _ h: Float, _ duelist: Int32) {
    var duelHealthColor: [Float] = [1, 0, 0, 0.7]
    var healthSrc: Float = 0.0
    var ratio: Float

    if duelist == 1 {
        healthSrc = Float(cgs.duelist1health)
    } else if duelist == 2 {
        healthSrc = Float(cgs.duelist2health)
    }

    ratio = healthSrc / MAX_HEALTH_FOR_IFACE
    if ratio > 1.0 {
        ratio = 1.0
    }
    if ratio < 0.0 {
        ratio = 0.0
    }
    duelHealthColor[0] = (ratio * 0.2) + 0.5

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type '[Float]' to expected argument type 'Float'".
    // Raven wrote: CG_DrawHealthBarRough (x, y, w, h, ratio, duelHealthColor, colorTable[CT_WHITE])
    portMissing("CG_DrawDuelistHealth", source: "oracle/codemp/cgame/cg_draw.c:3132")
}

/// Source: oracle/codemp/cgame/cg_draw.c:3179
func CG_DrawRadar(_ y: Float) -> Float {
    var color = vec4_t()
    var teamColor = vec4_t()
    var arrow_w: Float
    var arrow_h: Float
    var cl: ClientInfo?
    var local: ClientInfo?
    var i: Int32
    var arrowBaseScale: Float
    var zScale: Float
    let xOffset: Int32 = 0

    if cg.snap == nil {
        return y
    }


    // Make sure the radar should be showing
    if cg.snap!.ps.stats[STAT_HEALTH] <= 0 {
        return y
    }

    if (cg.predictedPlayerState.pm_flags & PMF_FOLLOW) != 0 || cg.predictedPlayerState.persistant[PERS_TEAM] == TEAM_SPECTATOR {
        return y
    }

    local = cgs.clientinfo[cg.snap!.ps.clientNum]
    if !local!.infoValid {
        return y
    }

    // Draw the radar background image
    color[2] = 1.0
    color[1] = color[2]
    color[0] = color[1]
    color[3] = 0.6
    trap_R_SetColor(color)
    CG_DrawPic(Float(RADAR_X + xOffset), y, Float(RADAR_RADIUS * 2), Float(RADAR_RADIUS * 2), cgs.media.radarShader)

    //Always green for your own team.
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: VectorCopy ( g_color_table[ColorIndex(COLOR_GREEN)], teamColor )
    portMissing("CG_DrawRadar", source: "oracle/codemp/cgame/cg_draw.c:3179")
    teamColor[3] = 1.0

    // Draw all of the radar entities.  Draw them backwards so players are drawn last
    i = cg.radarEntityCount - 1
    while i >= 0 {
        var dirLook = vec3_t()
        var dirPlayer = vec3_t()
        var angleLook: Float
        var anglePlayer: Float
        var angle: Float
        var distance: Float
        var actualDist: Float
        var cent: Centity?

        cent = cg_entities[cg.radarEntities[i]]

        // Get the distances first
        dirPlayer = cg.predictedPlayerState.origin - cent!.lerpOrigin
        dirPlayer[2] = 0
        distance = VectorNormalize(&dirPlayer)
        actualDist = distance

        if distance > cg_radarRange * 0.8 {
            if (cent!.currentState.eFlags & EF_RADAROBJECT) != 0 || (cent!.currentState.eType == ET_NPC && cent!.currentState.NPC_class == CLASS_VEHICLE && cent!.currentState.speed > 0) {
                distance = cg_radarRange * 0.8
            } else {
                i -= 1
                continue
            }
        }

        distance = distance / cg_radarRange
        distance *= RADAR_RADIUS

        // Raven passes NULL for the `right` and `up` outputs.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(cg.predictedPlayerState.viewangles, &dirLook, &scratchRight, &scratchUp)

        dirLook[2] = 0
        anglePlayer = atan2(dirPlayer[0], dirPlayer[1])
        VectorNormalize(&dirLook)
        angleLook = atan2(dirLook[0], dirLook[1])
        angle = angleLook - anglePlayer

        switch cent!.currentState.eType {
        case ET_NPC: //FIXME: draw last, with players...
            if cent!.currentState.NPC_class == CLASS_VEHICLE && cent!.currentState.speed > 0 {
                if cent!.m_pVehicle != nil && cent!.m_pVehicle!.m_pVehicleInfo!.radarIconHandle != 0 {
                    var x: Float
                    var ly: Float

                    x = Float(RADAR_X) + Float(RADAR_RADIUS) + Float(sin(angle)) * distance
                    ly = y + Float(RADAR_RADIUS) + Float(cos(angle)) * distance

                    arrowBaseScale = 9.0
                    zScale = 1.0

                    //we want to scale the thing up/down based on the relative Z (up/down) positioning
                    if cent!.lerpOrigin[2] > cg.predictedPlayerState.origin[2] {
                        //higher, scale up (between 16 and 24)
                        var dif: Float = (cent!.lerpOrigin[2] - cg.predictedPlayerState.origin[2])

                        //max out to 1.5x scale at 512 units above local player's height
                        dif /= 4096.0
                        if dif > 0.5 {
                            dif = 0.5
                        }
                        zScale += dif
                    } else if cent!.lerpOrigin[2] < cg.predictedPlayerState.origin[2] {
                        //lower, scale down (between 16 and 8)
                        var dif: Float = (cg.predictedPlayerState.origin[2] - cent!.lerpOrigin[2])

                        //half scale at 512 units below local player's height
                        dif /= 4096.0
                        if dif > 0.5 {
                            dif = 0.5
                        }
                        zScale -= dif
                    }

                    arrowBaseScale *= zScale

                    if cent!.currentState.m_iVehicleNum != 0 && cgs.clientinfo[cent!.currentState.m_iVehicleNum - 1].infoValid {
                        if cgs.clientinfo[cent!.currentState.m_iVehicleNum - 1].team == local!.team {
                            trap_R_SetColor(teamColor)
                        } else {
                            // Port-note: No operator between the operands, the text there is ``.
                            // Raven wrote: trap_R_SetColor ( g_color_table[ColorIndex(COLOR_RED)] )
                            portMissing("CG_DrawRadar", source: "oracle/codemp/cgame/cg_draw.c:3179")
                        }
                    } else {
                        trap_R_SetColor(nil)
                    }
                    CG_DrawPic(x - 4 + xOffset, ly - 4, arrowBaseScale, arrowBaseScale, cent!.m_pVehicle!.m_pVehicleInfo!.radarIconHandle)
                }
            }

        case ET_MOVER:
            if cent!.currentState.speed != 0 && actualDist < (cent!.currentState.speed + RADAR_ASTEROID_RANGE) && cg.predictedPlayerState.m_iVehicleNum != 0 {
                //a mover that's close to me and I'm in a vehicle
                var mayImpact: Bool = false
                var surfaceDist: Float = (actualDist - cent!.currentState.speed)
                if surfaceDist < 0.0 {
                    surfaceDist = 0.0
                }
                if surfaceDist < RADAR_MIN_ASTEROID_SURF_WARN_DIST {
                    //always warn!
                    mayImpact = true
                } else {
                    //not close enough to always warn, yet, so check its direction
                    var asteroidPos = vec3_t()
                    var myPos = vec3_t()
                    var moveDir = vec3_t()
                    var predictTime: Int32
                    let timeStep: Int32 = 500
                    var newDist: Float
                    predictTime = timeStep
                    while predictTime < 5000 {
                        //asteroid dir, speed, size, + my dir & speed...
                        BG_EvaluateTrajectory(cent!.currentState.pos, cg.time + predictTime, &asteroidPos)
                        //FIXME: I don't think it's calcing "myPos" correctly
                        // Raven passes NULL for the `right` and `up` outputs.
                        var scratchRight2 = vec3_t()
                        var scratchUp2 = vec3_t()
                        AngleVectors(cg.predictedVehicleState.viewangles, &moveDir, &scratchRight2, &scratchUp2)
                        _VectorMA(cg.predictedVehicleState.origin, cg.predictedVehicleState.speed * predictTime / 1000.0, moveDir, &myPos)
                        newDist = Distance(myPos, asteroidPos)
                        if (newDist - cent!.currentState.speed) <= RADAR_MIN_ASTEROID_SURF_WARN_DIST {
                            //heading for an impact within the next 5 seconds
                            mayImpact = true
                            break
                        }
                        predictTime += timeStep
                    }
                }
                if mayImpact {
                    //possible collision
                    var asteroidColor = vec4_t(0.5, 0.5, 0.5, 1.0)
                    var x: Float
                    var ly: Float
                    var asteroidScale: Float = (cent!.currentState.speed / 2000.0)
                    if actualDist > RADAR_ASTEROID_RANGE {
                        actualDist = RADAR_ASTEROID_RANGE
                    }
                    distance = (actualDist / RADAR_ASTEROID_RANGE) * RADAR_RADIUS

                    x = Float(RADAR_X) + Float(RADAR_RADIUS) + Float(sin(angle)) * distance
                    ly = y + Float(RADAR_RADIUS) + Float(cos(angle)) * distance

                    if asteroidScale > 3.0 {
                        asteroidScale = 3.0
                    } else if asteroidScale < 0.2 {
                        asteroidScale = 0.2
                    }
                    arrowBaseScale = (9.0 * asteroidScale)
                    if impactSoundDebounceTime < cg.time {
                        var soundOrg = vec3_t()
                        if surfaceDist > RADAR_ASTEROID_RANGE * 0.66 {
                            impactSoundDebounceTime = cg.time + 1000
                        } else if surfaceDist > RADAR_ASTEROID_RANGE / 3.0 {
                            impactSoundDebounceTime = cg.time + 400
                        } else {
                            impactSoundDebounceTime = cg.time + 100
                        }
                        _VectorMA(cg.refdef.vieworg, -500.0 * (surfaceDist / RADAR_ASTEROID_RANGE), dirPlayer, &soundOrg)
                        trap_S_StartSound(&soundOrg, ENTITYNUM_WORLD, CHAN_AUTO, trap_S_RegisterSound("sound/vehicles/common/impactalarm.wav"))
                    }
                    //brighten it the closer it is
                    if surfaceDist > RADAR_ASTEROID_RANGE * 0.66 {
                        asteroidColor[2] = 0.7
                        asteroidColor[1] = asteroidColor[2]
                        asteroidColor[0] = asteroidColor[1]
                    } else if surfaceDist > RADAR_ASTEROID_RANGE / 3.0 {
                        asteroidColor[2] = 0.85
                        asteroidColor[1] = asteroidColor[2]
                        asteroidColor[0] = asteroidColor[1]
                    } else {
                        asteroidColor[2] = 1.0
                        asteroidColor[1] = asteroidColor[2]
                        asteroidColor[0] = asteroidColor[1]
                    }
                    //alpha out the longer it's been since it was considered dangerous
                    if (cg.time - impactSoundDebounceTime) > 100 {
                        asteroidColor[3] = Float(((cg.time - impactSoundDebounceTime) - 100)) / 900.0
                    }

                    trap_R_SetColor(asteroidColor)
                    CG_DrawPic(x - 4 + xOffset, ly - 4, arrowBaseScale, arrowBaseScale, trap_R_RegisterShaderNoMip("gfx/menus/radar/asteroid"))
                }
            }

        case ET_MISSILE:
            if cent!.currentState.owner > MAX_CLIENTS && cg_entities[cent!.currentState.owner].currentState.NPC_class == CLASS_VEHICLE {
                //a rocket belonging to an NPC, FIXME: only tracking rockets!
                var x: Float
                var ly: Float

                x = Float(RADAR_X) + Float(RADAR_RADIUS) + Float(sin(angle)) * distance
                ly = y + Float(RADAR_RADIUS) + Float(cos(angle)) * distance

                arrowBaseScale = 3.0
                if cg.predictedPlayerState.m_iVehicleNum != 0 {
                    //I'm in a vehicle
                    //if it's targetting me, then play an alarm sound if I'm in a vehicle
                    if cent!.currentState.otherEntityNum == cg.predictedPlayerState.clientNum || cent!.currentState.otherEntityNum == cg.predictedPlayerState.m_iVehicleNum {
                        if radarLockSoundDebounceTime < cg.time {
                            var soundOrg = vec3_t()
                            var alarmSound: Int32
                            if actualDist > RADAR_MISSILE_RANGE * 0.66 {
                                radarLockSoundDebounceTime = cg.time + 1000
                                arrowBaseScale = 3.0
                                alarmSound = trap_S_RegisterSound("sound/vehicles/common/lockalarm1.wav")
                            } else if actualDist > RADAR_MISSILE_RANGE / 3.0 {
                                radarLockSoundDebounceTime = cg.time + 500
                                arrowBaseScale = 6.0
                                alarmSound = trap_S_RegisterSound("sound/vehicles/common/lockalarm2.wav")
                            } else {
                                radarLockSoundDebounceTime = cg.time + 250
                                arrowBaseScale = 9.0
                                alarmSound = trap_S_RegisterSound("sound/vehicles/common/lockalarm3.wav")
                            }
                            if actualDist > RADAR_MISSILE_RANGE {
                                actualDist = RADAR_MISSILE_RANGE
                            }
                            _VectorMA(cg.refdef.vieworg, -500.0 * (actualDist / RADAR_MISSILE_RANGE), dirPlayer, &soundOrg)
                            trap_S_StartSound(&soundOrg, ENTITYNUM_WORLD, CHAN_AUTO, alarmSound)
                        }
                    }
                }
                zScale = 1.0

                //we want to scale the thing up/down based on the relative Z (up/down) positioning
                if cent!.lerpOrigin[2] > cg.predictedPlayerState.origin[2] {
                    //higher, scale up (between 16 and 24)
                    var dif: Float = (cent!.lerpOrigin[2] - cg.predictedPlayerState.origin[2])

                    //max out to 1.5x scale at 512 units above local player's height
                    dif /= 1024.0
                    if dif > 0.5 {
                        dif = 0.5
                    }
                    zScale += dif
                } else if cent!.lerpOrigin[2] < cg.predictedPlayerState.origin[2] {
                    //lower, scale down (between 16 and 8)
                    var dif: Float = (cg.predictedPlayerState.origin[2] - cent!.lerpOrigin[2])

                    //half scale at 512 units below local player's height
                    dif /= 1024.0
                    if dif > 0.5 {
                        dif = 0.5
                    }
                    zScale -= dif
                }

                arrowBaseScale *= zScale

                if cent!.currentState.owner >= MAX_CLIENTS && cg_entities[cent!.currentState.owner].currentState.NPC_class == CLASS_VEHICLE && cg_entities[cent!.currentState.owner].currentState.m_iVehicleNum <= MAX_CLIENTS && cgs.clientinfo[cg_entities[cent!.currentState.owner].currentState.m_iVehicleNum - 1].infoValid {
                    cl = cgs.clientinfo[cg_entities[cent!.currentState.owner].currentState.m_iVehicleNum - 1]
                    if cl!.team == local!.team {
                        trap_R_SetColor(teamColor)
                    } else {
                        // Port-note: No operator between the operands, the text there is ``.
                        // Raven wrote: trap_R_SetColor ( g_color_table[ColorIndex(COLOR_RED)] )
                        portMissing("CG_DrawRadar", source: "oracle/codemp/cgame/cg_draw.c:3179")
                    }
                } else {
                    trap_R_SetColor(nil)
                }
                CG_DrawPic(x - 4 + xOffset, ly - 4, arrowBaseScale, arrowBaseScale, cgs.media.mAutomapRocketIcon)
            }

        case ET_PLAYER:
            do {
                var color = vec4_t()

                cl = cgs.clientinfo[cent!.currentState.number]

                // not valid then dont draw it
                if !cl!.infoValid {
                    i -= 1
                    continue
                }

                // Raven wrote: VectorCopy4 ( teamColor, color )
                color = teamColor

                arrowBaseScale = 16.0
                zScale = 1.0

                // Pulse the radar icon after a voice message
                if cent!.vChatTime + 2000 > cg.time {
                    let f: Float = (cent!.vChatTime + 2000 - cg.time) / 3000.0
                    arrowBaseScale = 16.0 + 4.0 * f
                    color[0] = teamColor[0] + (1.0 - teamColor[0]) * f
                    color[1] = teamColor[1] + (1.0 - teamColor[1]) * f
                    color[2] = teamColor[2] + (1.0 - teamColor[2]) * f
                }

                trap_R_SetColor(color)

                //we want to scale the thing up/down based on the relative Z (up/down) positioning
                if cent!.lerpOrigin[2] > cg.predictedPlayerState.origin[2] {
                    //higher, scale up (between 16 and 32)
                    var dif: Float = (cent!.lerpOrigin[2] - cg.predictedPlayerState.origin[2])

                    //max out to 2x scale at 1024 units above local player's height
                    dif /= 1024.0
                    if dif > 1.0 {
                        dif = 1.0
                    }
                    zScale += dif
                } else if cent!.lerpOrigin[2] < cg.predictedPlayerState.origin[2] {
                    //lower, scale down (between 16 and 8)
                    var dif: Float = (cg.predictedPlayerState.origin[2] - cent!.lerpOrigin[2])

                    //half scale at 512 units below local player's height
                    dif /= 1024.0
                    if dif > 0.5 {
                        dif = 0.5
                    }
                    zScale -= dif
                }

                arrowBaseScale *= zScale

                arrow_w = arrowBaseScale * RADAR_RADIUS / 128
                arrow_h = arrowBaseScale * RADAR_RADIUS / 128

                CG_DrawRotatePic2(RADAR_X + RADAR_RADIUS + sin(angle) * distance + xOffset, y + RADAR_RADIUS + cos(angle) * distance, arrow_w, arrow_h, (360 - cent!.lerpAngles[YAW]) + cg.predictedPlayerState.viewangles[YAW], cgs.media.mAutomapPlayerIcon)
                break
            }

        default:
            do {
                var x: Float
                var ly: Float
                var shader: qhandle_t
                var color = vec4_t()

                x = Float(RADAR_X) + Float(RADAR_RADIUS) + Float(sin(angle)) * distance
                ly = y + Float(RADAR_RADIUS) + Float(cos(angle)) * distance

                arrowBaseScale = 9.0
                shader = 0
                zScale = 1.0

                //we want to scale the thing up/down based on the relative Z (up/down) positioning
                if cent!.lerpOrigin[2] > cg.predictedPlayerState.origin[2] {
                    //higher, scale up (between 16 and 24)
                    var dif: Float = (cent!.lerpOrigin[2] - cg.predictedPlayerState.origin[2])

                    //max out to 1.5x scale at 512 units above local player's height
                    dif /= 1024.0
                    if dif > 0.5 {
                        dif = 0.5
                    }
                    zScale += dif
                } else if cent!.lerpOrigin[2] < cg.predictedPlayerState.origin[2] {
                    //lower, scale down (between 16 and 8)
                    var dif: Float = (cg.predictedPlayerState.origin[2] - cent!.lerpOrigin[2])

                    //half scale at 512 units below local player's height
                    dif /= 1024.0
                    if dif > 0.5 {
                        dif = 0.5
                    }
                    zScale -= dif
                }

                arrowBaseScale *= zScale

                if cent!.currentState.brokenLimbs != 0 {
                    //slightly misleading to use this value, but don't want to add more to entstate.
                    //any ent with brokenLimbs non-0 and on radar is an objective ent.
                    //brokenLimbs is literal team value.
                    var objState = CharBuf(1024)
                    var complete: Int32

                    //we only want to draw it if the objective for it is not complete.
                    //frame represents objective num.
                    strcpy(&objState, trap_Cvar_VariableStringBuffer(va("team%i_objective%i", cent!.currentState.brokenLimbs, cent!.currentState.frame), 1024))

                    complete = atoi(objState)

                    if complete == 0 {
                        // generic enemy index specifies a shader to use for the radar entity.
                        if cent!.currentState.genericenemyindex != 0 {
                            color[3] = 1.0
                            color[2] = color[3]
                            color[1] = color[2]
                            color[0] = color[1]
                            shader = cgs.gameIcons[cent!.currentState.genericenemyindex]
                        } else {
                            if cg.snap != nil && cent!.currentState.brokenLimbs == cg.snap!.ps.persistant[PERS_TEAM] {
                                // Port-note: No operator between the operands, the text there is ``.
                                // Raven wrote: VectorCopy ( g_color_table[ColorIndex(COLOR_RED)], color )
                                portMissing("CG_DrawRadar", source: "oracle/codemp/cgame/cg_draw.c:3179")
                            } else {
                                // Port-note: No operator between the operands, the text there is ``.
                                // Raven wrote: VectorCopy ( g_color_table[ColorIndex(COLOR_GREEN)], color )
                                portMissing("CG_DrawRadar", source: "oracle/codemp/cgame/cg_draw.c:3179")
                            }

                            shader = cgs.media.siegeItemShader
                        }
                    }
                } else {
                    color[3] = 1.0
                    color[2] = color[3]
                    color[1] = color[2]
                    color[0] = color[1]

                    // generic enemy index specifies a shader to use for the radar entity.
                    if cent!.currentState.genericenemyindex != 0 {
                        shader = cgs.gameIcons[cent!.currentState.genericenemyindex]
                    } else {
                        shader = cgs.media.siegeItemShader
                    }
                }

                if shader != 0 {
                    // Pulse the alpha if time2 is set.  time2 gets set when the entity takes pain
                    // Raven wrote: if ( (cent->currentState.time2 && cg.time - cent->currentState.time2 < 5000) || (cent->currentState.time2 == 0xFFFFFFFF) ) { if ( (cg.time / 200) & 1 ) { color[3] = 0.1f + 0.9f * (float) (cg.time % 200) / 200.0f; } else { color[3] = 1.0f - 0.9f * (float) (cg.time % 200) / 200.0f; } }
                    if (cent!.currentState.time2 != 0 && cg.time - cent!.currentState.time2 < 5000) || (cent!.currentState.time2 == ~0) {
                        if ((cg.time / 200) & 1) != 0 {
                            color[3] = 0.1 + 0.9 * Float(cg.time % 200) / 200.0
                        } else {
                            color[3] = 1.0 - 0.9 * Float(cg.time % 200) / 200.0
                        }
                    }

                    trap_R_SetColor(color)
                    CG_DrawPic(x - 4 + xOffset, ly - 4, arrowBaseScale, arrowBaseScale, shader)
                }
            }
        }
        i -= 1
    }

    arrowBaseScale = 16.0

    arrow_w = arrowBaseScale * RADAR_RADIUS / 128
    arrow_h = arrowBaseScale * RADAR_RADIUS / 128

    trap_R_SetColor(colorWhite)
    CG_DrawRotatePic2(Float(RADAR_X + RADAR_RADIUS + xOffset), y + RADAR_RADIUS, arrow_w, arrow_h, 0, cgs.media.mAutomapPlayerIcon)

    return y + (RADAR_RADIUS * 2)
}

/**
```
=================
CG_DrawTimer
=================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:3745
private func CG_DrawTimer(_ y: Float) -> Float {
    let s: String
    let w: Int32
    let mins: Int32
    var seconds: Int32
    let tens: Int32
    let msec: Int32
    let xOffset: Int32 = 0


    msec = cg.time - cgs.levelStartTime

    seconds = msec / 1000
    mins = seconds / 60
    seconds -= mins * 60
    tens = seconds / 10
    seconds -= tens * 10

    s = va("%i:%i%i", mins, tens, seconds)
    w = CG_DrawStrlen(s) * BIGCHAR_WIDTH

    CG_DrawBigString(635 - w + xOffset, Int32(y + 2), s, 1.0)

    return y + BIGCHAR_HEIGHT + 4
}

/// Source: oracle/codemp/cgame/cg_draw.c:3779
private func CG_DrawTeamOverlay(_ y: Float, _ right: Bool, _ upper: Bool) -> Float {
    let x: Int32
    let w: Int32
    let h: Int32
    var xx: Int32
    var i: Int32
    var j: Int32
    var len: Int32
    var p: String
    var hcolor = vec4_t()
    var pwidth: Int32
    var lwidth: Int32
    var plyrs: Int32
    var st = CharBuf(16)
    var ci: ClientInfo?
    var item: Gitem?
    let ret_y: Int32
    let count: Int32
    let xOffset: Int32 = 0
    // Raven assigns his own `y` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var y = y


    if cg_drawTeamOverlay.integer == 0 {
        return y
    }

    if cg.snap!.ps.persistant[PERS_TEAM] != TEAM_RED && cg.snap!.ps.persistant[PERS_TEAM] != TEAM_BLUE {
        return y // Not on any team
    }

    plyrs = 0

    // max player name width
    pwidth = 0
    count = (numSortedTeamPlayers > 8) ? 8 : numSortedTeamPlayers
    i = 0
    while i < count {
        // Raven wrote: ci = cgs.clientinfo + sortedTeamPlayers[i]
        ci = cgs.clientinfo[sortedTeamPlayers[i]]
        if ci!.infoValid && ci!.team == cg.snap!.ps.persistant[PERS_TEAM] {
            plyrs += 1
            len = CG_DrawStrlen(ci!.name)
            if len > pwidth {
                pwidth = len
            }
        }
        i += 1
    }

    if plyrs == 0 {
        return y
    }

    if pwidth > TEAM_OVERLAY_MAXNAME_WIDTH {
        pwidth = TEAM_OVERLAY_MAXNAME_WIDTH
    }

    // max location name width
    lwidth = 0
    i = 1
    while i < MAX_LOCATIONS {
        p = CG_GetLocationString(CG_ConfigString(CS_LOCATIONS + i))
        // Raven wrote: if (p && *p) { len = CG_DrawStrlen(p); if (len > lwidth) lwidth = len; }
        if !p.isEmpty {
            len = CG_DrawStrlen(p)
            if len > lwidth {
                lwidth = len
            }
        }
        i += 1
    }

    if lwidth > TEAM_OVERLAY_MAXLOCATION_WIDTH {
        lwidth = TEAM_OVERLAY_MAXLOCATION_WIDTH
    }

    w = (pwidth + lwidth + 4 + 7) * TINYCHAR_WIDTH

    if right {
        x = 640 - w
    } else {
        x = 0
    }

    h = plyrs * TINYCHAR_HEIGHT

    if upper {
        ret_y = Int32(y + h)
    } else {
        y -= h
        ret_y = Int32(y)
    }

    if cg.snap!.ps.persistant[PERS_TEAM] == TEAM_RED {
        hcolor[0] = 1.0
        hcolor[1] = 0.0
        hcolor[2] = 0.0
        hcolor[3] = 0.33
    } else {
        // if ( cg.snap->ps.persistant[PERS_TEAM] == TEAM_BLUE )
        hcolor[0] = 0.0
        hcolor[1] = 0.0
        hcolor[2] = 1.0
        hcolor[3] = 0.33
    }
    trap_R_SetColor(hcolor)
    CG_DrawPic(Float(x + xOffset), y, Float(w), Float(h), cgs.media.teamStatusBar)
    trap_R_SetColor(nil)

    i = 0
    while i < count {
        // Raven wrote: ci = cgs.clientinfo + sortedTeamPlayers[i]
        ci = cgs.clientinfo[sortedTeamPlayers[i]]
        if ci!.infoValid && ci!.team == cg.snap!.ps.persistant[PERS_TEAM] {
            hcolor[3] = 1.0
            hcolor[2] = hcolor[3]
            hcolor[1] = hcolor[2]
            hcolor[0] = hcolor[1]

            xx = x + TINYCHAR_WIDTH

            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
            // Raven wrote: CG_DrawStringExt( xx + xOffset, y, ci->name, hcolor, qfalse, qfalse, TINYCHAR_WIDTH, TINYCHAR_HEIGHT, TEAM_OVERLAY_MAXNAME_WIDTH)
            portMissing("CG_DrawTeamOverlay", source: "oracle/codemp/cgame/cg_draw.c:3779")

            if lwidth != 0 {
                p = CG_GetLocationString(CG_ConfigString(CS_LOCATIONS + ci!.location))
                // Raven wrote: if (!p || !*p) p = "unknown"
                if p.isEmpty {
                    p = "unknown"
                }
                len = CG_DrawStrlen(p)
                if len > lwidth {
                    len = lwidth
                }

                //				xx = x + TINYCHAR_WIDTH * 2 + TINYCHAR_WIDTH * pwidth +
                //					((lwidth/2 - len/2) * TINYCHAR_WIDTH);
                xx = x + TINYCHAR_WIDTH * 2 + TINYCHAR_WIDTH * pwidth
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
                // Raven wrote: CG_DrawStringExt( xx + xOffset, y, p, hcolor, qfalse, qfalse, TINYCHAR_WIDTH, TINYCHAR_HEIGHT, TEAM_OVERLAY_MAXLOCATION_WIDTH)
                portMissing("CG_DrawTeamOverlay", source: "oracle/codemp/cgame/cg_draw.c:3779")
            }

            CG_GetColorForHealth(ci!.health, ci!.armor, &hcolor)

            Com_sprintf(&st, Int32((st).count), "%3i %3i", ci!.health, ci!.armor)

            xx = x + TINYCHAR_WIDTH * 3 + TINYCHAR_WIDTH * pwidth + TINYCHAR_WIDTH * lwidth

            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
            // Raven wrote: CG_DrawStringExt( xx + xOffset, y, st, hcolor, qfalse, qfalse, TINYCHAR_WIDTH, TINYCHAR_HEIGHT, 0 )
            portMissing("CG_DrawTeamOverlay", source: "oracle/codemp/cgame/cg_draw.c:3779")

            // draw weapon icon
            xx += TINYCHAR_WIDTH * 3

            if cg_weapons[ci!.curWeapon].weaponIcon != 0 {
                CG_DrawPic(Float(xx + xOffset), y, Float(TINYCHAR_WIDTH), Float(TINYCHAR_HEIGHT), cg_weapons[ci!.curWeapon].weaponIcon)
            } else {
                CG_DrawPic(Float(xx + xOffset), y, Float(TINYCHAR_WIDTH), Float(TINYCHAR_HEIGHT), cgs.media.deferShader)
            }

            // Draw powerup icons
            if right {
                xx = x
            } else {
                xx = x + w - TINYCHAR_WIDTH
            }
            j = 0
            while j <= PW_NUM_POWERUPS {
                if (ci!.powerups & (1 << j)) != 0 {
                    item = BG_FindItemForPowerup(j)

                    if item != nil {
                        CG_DrawPic(Float(xx + xOffset), y, Float(TINYCHAR_WIDTH), Float(TINYCHAR_HEIGHT), trap_R_RegisterShader(item!.icon!))
                        if right {
                            xx -= TINYCHAR_WIDTH
                        } else {
                            xx += TINYCHAR_WIDTH
                        }
                    }
                }
                j += 1
            }

            y += TINYCHAR_HEIGHT
        }
        i += 1
    }

    return Float(ret_y)
    //#endif
}

/// Source: oracle/codemp/cgame/cg_draw.c:3952
private func CG_DrawPowerupIcons(_ y: Int32) {
    var j: Int32
    let ico_size: Int32 = 64
    //int y = ico_size/2;
    let xOffset: Int32 = 0
    var item: Gitem?
    // Raven assigns his own `y` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var y = y


    if cg.snap == nil {
        return
    }

    y += 16

    j = 0
    while j <= PW_NUM_POWERUPS {
        if cg.snap!.ps.powerups[j] > cg.time {
            let secondsleft: Int32 = (cg.snap!.ps.powerups[j] - cg.time) / 1000

            item = BG_FindItemForPowerup(j)

            if item != nil {
                var icoShader: Int32 = 0
                if cgs.gametype == GT_CTY && (j == PW_REDFLAG || j == PW_BLUEFLAG) {
                    if j == PW_REDFLAG {
                        icoShader = trap_R_RegisterShaderNoMip("gfx/hud/mpi_rflag_ys")
                    } else {
                        icoShader = trap_R_RegisterShaderNoMip("gfx/hud/mpi_bflag_ys")
                    }
                } else {
                    icoShader = trap_R_RegisterShader(item!.icon!)
                }

                CG_DrawPic(Float((640 - (Double(ico_size) * 1.1)) + Double(xOffset)), Float(y), Float(ico_size), Float(ico_size), icoShader)

                y += ico_size

                if j != PW_REDFLAG && j != PW_BLUEFLAG && secondsleft < 999 {
                    UI_DrawProportionalString(Int32((640 - (Double(ico_size) * 1.1)) + Double(ico_size / 2) + Double(xOffset)), y - 8, va("%i", secondsleft), UI_CENTER | UI_BIGFONT | UI_DROPSHADOW, colorTable[CT_WHITE])
                }

                y += (ico_size / 3)
            }
        }
        j += 1
    }
}

/**
```
=====================
CG_DrawUpperRight

=====================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:4020
private func CG_DrawUpperRight() {
    var y: Float

    y = 0

    trap_R_SetColor(colorTable[CT_WHITE])

    if cgs.gametype >= GT_TEAM && cg_drawTeamOverlay.integer == 1 {
        y = CG_DrawTeamOverlay(y, true, true)
    }
    if cg_drawSnapshot.integer != 0 {
        y = CG_DrawSnapshot(y)
    }

    if cg_drawFPS.integer != 0 {
        y = CG_DrawFPS(y)
    }
    if cg_drawTimer.integer != 0 {
        y = CG_DrawTimer(y)
    }

    if (cgs.gametype >= GT_TEAM || cg.predictedPlayerState.m_iVehicleNum != 0) && cg_drawRadar.integer != 0 {
        //draw Radar in Siege mode or when in a vehicle of any kind
        y = CG_DrawRadar(y)
    }

    y = CG_DrawEnemyInfo(y)

    y = CG_DrawMiniScoreboard(y)

    CG_DrawPowerupIcons(Int32(y))
}

/**
```
==============
CG_AddLagometerFrameInfo

Adds the current interpolate / extrapolate bar for this frame
==============
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:4161
func CG_AddLagometerFrameInfo() {
    let offset: Int32

    offset = cg.time - cg.latestSnapshotTime
    lagometer.frameSamples[lagometer.frameCount & (LAG_SAMPLES - 1)] = offset
    lagometer.frameCount += 1
}

/**
```
==============
CG_AddLagometerSnapshotInfo

Each time a snapshot is received, log its ping time and
the number of snapshots that were dropped before it.

Pass NULL for a dropped packet.
==============
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:4179
func CG_AddLagometerSnapshotInfo(_ snap: Snapshot?) {
    // dropped packet
    if snap == nil {
        lagometer.snapshotSamples[lagometer.snapshotCount & (LAG_SAMPLES - 1)] = -1
        lagometer.snapshotCount += 1
        return
    }

    // add this snapshot's info
    lagometer.snapshotSamples[lagometer.snapshotCount & (LAG_SAMPLES - 1)] = snap!.ping
    lagometer.snapshotFlags[lagometer.snapshotCount & (LAG_SAMPLES - 1)] = snap!.snapFlags
    lagometer.snapshotCount += 1
}

/**
```
==============
CG_DrawDisconnect

Should we draw something differnet for long lag vs no packets?
==============
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:4200
private func CG_DrawDisconnect() {
    var x: Float = 0
    var y: Float = 0
    var cmdNum: Int32 = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Usercmd.scratch { cmd -> Bool in
        var s: String
        var w: Int32 = 0

        if cg.mMapChange {
            s = CG_GetStringEdString("MP_INGAME", "SERVER_CHANGING_MAPS") // s = "Server Changing Maps";
            w = CG_DrawStrlen(s) * BIGCHAR_WIDTH
            CG_DrawBigString(320 - w / 2, 100, s, 1.0)

            s = CG_GetStringEdString("MP_INGAME", "PLEASE_WAIT") // s = "Please wait...";
            w = CG_DrawStrlen(s) * BIGCHAR_WIDTH
            CG_DrawBigString(320 - w / 2, 200, s, 1.0)
            return true
        }

        // draw the phone jack if we are completely past our buffers
        cmdNum = trap_GetCurrentCmdNumber() - CMD_BACKUP + 1
        trap_GetUserCmd(cmdNum, cmd)
        if cmd.serverTime <= cg.snap!.ps.commandTime || cmd.serverTime > cg.time {
            // special check for map_restart // bk 0102165 - FIXME
            return true
        }

        // also add text in center of screen
        s = CG_GetStringEdString("MP_INGAME", "CONNECTION_INTERRUPTED") // s = "Connection Interrupted"; // bk 010215 - FIXME
        w = CG_DrawStrlen(s) * BIGCHAR_WIDTH
        CG_DrawBigString(320 - w / 2, 100, s, 1.0)

        // blink the icon
        if ((cg.time >> 9) & 1) != 0 {
            return true
        }

        x = Float(640 - 48)
        y = Float(480 - 48)

        CG_DrawPic(x, y, 48, 48, trap_R_RegisterShader("gfx/2d/net.tga"))
        return false
    }
    if earlyOut {
        return
    }
}

/**
```
==============
CG_DrawLagometer
==============
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:4252
private func CG_DrawLagometer() {
    var a: Int32
    let x: Int32
    let y: Int32
    var i: Int32
    var v: Float
    let ax: Float
    let ay: Float
    let aw: Float
    let ah: Float
    let mid: Float
    var range: Float
    var color: Int32
    var vscale: Float

    if cg_lagometer.integer == 0 || cgs.localServer {
        CG_DrawDisconnect()
        return
    }

    //
    // draw the graph
    //
    x = 640 - 48
    y = 480 - 144

    trap_R_SetColor(nil)
    CG_DrawPic(Float(x), Float(y), 48, 48, cgs.media.lagometerShader)

    ax = Float(x)
    ay = Float(y)
    aw = 48
    ah = 48

    color = -1
    range = ah / 3
    mid = ay + range

    vscale = range / MAX_LAGOMETER_RANGE

    // draw the frame interpoalte / extrapolate graph
    a = 0
    while a < aw {
        i = (lagometer.frameCount - 1 - a) & (LAG_SAMPLES - 1)
        v = Float(lagometer.frameSamples[i])
        v *= vscale
        if v > 0 {
            if color != 1 {
                color = 1
                // Port-note: No operator between the operands, the text there is ``.
                // Raven wrote: trap_R_SetColor( g_color_table[ColorIndex(COLOR_YELLOW)] )
                portMissing("CG_DrawLagometer", source: "oracle/codemp/cgame/cg_draw.c:4252")
            }
            if v > range {
                v = range
            }
            trap_R_DrawStretchPic(ax + aw - a, mid - v, 1, v, 0, 0, 0, 0, cgs.media.whiteShader)
        } else if v < 0 {
            if color != 2 {
                color = 2
                // Port-note: No operator between the operands, the text there is ``.
                // Raven wrote: trap_R_SetColor( g_color_table[ColorIndex(COLOR_BLUE)] )
                portMissing("CG_DrawLagometer", source: "oracle/codemp/cgame/cg_draw.c:4252")
            }
            v = -v
            if v > range {
                v = range
            }
            trap_R_DrawStretchPic(ax + aw - a, mid, 1, v, 0, 0, 0, 0, cgs.media.whiteShader)
        }
        a += 1
    }

    // draw the snapshot latency / drop graph
    range = ah / 2
    vscale = range / MAX_LAGOMETER_PING

    a = 0
    while a < aw {
        i = (lagometer.snapshotCount - 1 - a) & (LAG_SAMPLES - 1)
        v = Float(lagometer.snapshotSamples[i])
        if v > 0 {
            if (lagometer.snapshotFlags[i] & SNAPFLAG_RATE_DELAYED) != 0 {
                if color != 5 {
                    color = 5 // YELLOW for rate delay
                    // Port-note: No operator between the operands, the text there is ``.
                    // Raven wrote: trap_R_SetColor( g_color_table[ColorIndex(COLOR_YELLOW)] )
                    portMissing("CG_DrawLagometer", source: "oracle/codemp/cgame/cg_draw.c:4252")
                }
            } else {
                if color != 3 {
                    color = 3
                    // Port-note: No operator between the operands, the text there is ``.
                    // Raven wrote: trap_R_SetColor( g_color_table[ColorIndex(COLOR_GREEN)] )
                    portMissing("CG_DrawLagometer", source: "oracle/codemp/cgame/cg_draw.c:4252")
                }
            }
            v = v * vscale
            if v > range {
                v = range
            }
            trap_R_DrawStretchPic(ax + aw - a, ay + ah - v, 1, v, 0, 0, 0, 0, cgs.media.whiteShader)
        } else if v < 0 {
            if color != 4 {
                color = 4 // RED for dropped snapshots
                // Port-note: No operator between the operands, the text there is ``.
                // Raven wrote: trap_R_SetColor( g_color_table[ColorIndex(COLOR_RED)] )
                portMissing("CG_DrawLagometer", source: "oracle/codemp/cgame/cg_draw.c:4252")
            }
            trap_R_DrawStretchPic(ax + aw - a, ay + ah - range, 1, range, 0, 0, 0, 0, cgs.media.whiteShader)
        }
        a += 1
    }

    trap_R_SetColor(nil)

    if cg_nopredict.integer != 0 || cg_synchronousClients.integer != 0 {
        CG_DrawBigString(Int32(ax), Int32(ay), "snc", 1.0)
    }

    CG_DrawDisconnect()
}

/// Source: oracle/codemp/cgame/cg_draw.c:4353
func CG_DrawSiegeMessage(_ str: String, _ objectiveScreen: Int32) {
    //	if (!( trap_Key_GetCatcher() & KEYCATCH_UI ))
    do {
        trap_OpenUIMenu(UIMENU_CLOSEALL)
        trap_Cvar_Set("cg_siegeMessage", str)
        if objectiveScreen != 0 {
            trap_OpenUIMenu(UIMENU_SIEGEOBJECTIVES)
        } else {
            trap_OpenUIMenu(UIMENU_SIEGEMESSAGE)
        }
    }
}

/// Source: oracle/codemp/cgame/cg_draw.c:4370
func CG_DrawSiegeMessageNonMenu(_ str: String) {
    var text = CharBuf(1024)
    // Raven steps his own `str` parameter through its bytes, so the body walks a TextCursor over a copy of them.
    var str = TextCursor(CharBuf(str))
    if str[0] == Int32(ascii: "@") {
        // Raven wrote: trap_SP_GetStringTextString(str+1, text, sizeof(text))
        strcpy(&text, trap_SP_GetStringTextString(TextCursor(str.buf, at: 1).text, Int32((text).count)).1)
        str = TextCursor(text)
    }
    CG_CenterPrint(str.text, Int32(Double(SCREEN_HEIGHT) * 0.20), BIGCHAR_WIDTH)
}

/**
```
==============
CG_CenterPrint

Called for important messages that should stay in the center of the screen
for a few moments
==============
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:4398
func CG_CenterPrint(_ str: String, _ y: Int32, _ charWidth: Int32) {
    // Raven wrote: char *s;
    var s: TextCursor

    Q_strncpyz(&cg.centerPrintBuffer, str, 1024)

    cg.centerPrintTime = cg.time
    cg.centerPrintY = y
    cg.centerPrintCharWidth = charWidth

    // count the number of lines for centering
    cg.centerPrintLines = 1
    // Raven wrote: s = cg.centerPrint
    s = TextCursor(cg.centerPrintBuffer)
    // Raven wrote: while( *s ) { if (*s == '\n') cg.centerPrintLines++; s++; }
    while s[0] != 0 {
        if s[0] == Int32(ascii: "\n") {
            cg.centerPrintLines += 1
        }
        s.advance()
    }
}

/**
```
===================
CG_DrawCenterString
===================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:4423
private func CG_DrawCenterString() {
    // Raven wrote: char *start;
    var start: TextCursor
    var l: Int32
    var x: Int32
    var y: Int32
    var w: Int32
    var h: Int32
    // Port-note: A pointer local `float * color` with no view.
    // Raven wrote: float *color;
    portMissing("CG_DrawCenterString", source: "oracle/codemp/cgame/cg_draw.c:4423")
    let scale: Float = 1.0

    if cg.centerPrintTime == 0 {
        return
    }

    // Port-note: A store into `color`, a local the draft left as a hole.
    // Raven wrote: color = CG_FadeColor( cg.centerPrintTime, 1000 * cg_centertime.value )
    portMissing("CG_DrawCenterString", source: "oracle/codemp/cgame/cg_draw.c:4423")
    // Port-note: A read of `color`, a local the draft left as a hole.
    // Raven wrote: if ( !color ) { return; }
    portMissing("CG_DrawCenterString", source: "oracle/codemp/cgame/cg_draw.c:4423")

    // Port-note: A read of `color`, a local the draft left as a hole.
    // Raven wrote: trap_R_SetColor( color )
    portMissing("CG_DrawCenterString", source: "oracle/codemp/cgame/cg_draw.c:4423")

    // Raven wrote: start = cg.centerPrint
    start = TextCursor(cg.centerPrintBuffer)

    y = cg.centerPrintY - cg.centerPrintLines * BIGCHAR_HEIGHT / 2

    while 1 != 0 {
        var linebuffer = CharBuf(1024)

        l = 0
        while l < 50 {
            // Raven wrote: if ( !start[l] || start[l] == '\n' ) { break; }
            if start[l] == 0 || start[l] == Int32(ascii: "\n") {
                break
            }
            // Raven wrote: linebuffer[l] = start[l]
            linebuffer[l] = start[l]
            l += 1
        }
        linebuffer[l] = 0

        w = CG_Text_Width(String(linebuffer), scale, FONT_MEDIUM)
        h = CG_Text_Height(String(linebuffer), scale, FONT_MEDIUM)
        x = (SCREEN_WIDTH - w) / 2
        // Port-note: A read of `color`, a local the draft left as a hole.
        // Raven wrote: CG_Text_Paint(x, y + h, scale, color, linebuffer, 0, 0, ITEM_TEXTSTYLE_SHADOWEDMORE, FONT_MEDIUM)
        portMissing("CG_DrawCenterString", source: "oracle/codemp/cgame/cg_draw.c:4423")
        y += h + 6

        // Raven wrote: while ( *start && ( *start != '\n' ) ) { start++; }
        while start[0] != 0 && (start[0] != Int32(ascii: "\n")) {
            start.advance()
        }
        // Raven wrote: if ( !*start ) { break; }
        if start[0] == 0 {
            break
        }
        // Raven wrote: start++
        start.advance()
    }

    trap_R_SetColor(nil)
}

//see if we can draw some extra info on this guy based on our class
/// Source: oracle/codemp/cgame/cg_draw.c:4489
func CG_DrawSiegeInfo(_ cent: Centity, _ chX: Float, _ chY: Float, _ chW: Float, _ chH: Float) {
    let se: SiegeExtended? = cg_siegeExtendedData[cent.currentState.number]
    var ci: ClientInfo?
    let configstring: String
    let v: String
    var siegeClass: SiegeClass?
    var aColor = vec4_t()
    var bColor = vec4_t()
    var cColor = vec4_t()
    var x: Float
    var y: Float
    var percent: Float
    var ammoMax: Int32


    if se!.lastUpdated > cg.time {
        //strange, shouldn't happen
        return
    }

    if (cg.time - se!.lastUpdated) > 10000 {
        //if you haven't received a status update on this guy in 10 seconds, forget about it
        return
    }

    if (cent.currentState.eFlags & EF_DEAD) != 0 {
        //he's dead, don't display info on him
        return
    }

    if cent.currentState.weapon != se!.weapon {
        //data is invalidated until it syncs back again
        return
    }

    ci = cgs.clientinfo[cent.currentState.number]
    if ci!.team != cg.predictedPlayerState.persistant[PERS_TEAM] {
        //not on the same team
        return
    }

    configstring = CG_ConfigString(cg.predictedPlayerState.clientNum + CS_PLAYERS)
    v = Info_ValueForKey(configstring, "siegeclass")

    if v.isEmpty {
        //don't have siege class in info?
        return
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SiegeFindClassByName' in scope".
    // Raven wrote: siegeClass = BG_SiegeFindClassByName(v)
    portMissing("CG_DrawSiegeInfo", source: "oracle/codemp/cgame/cg_draw.c:4489")

    if siegeClass == nil {
        //invalid
        return
    }

    if !((siegeClass!.classflags & (1 << CFL_STATVIEWER)) != 0) {
        //doesn't really have the ability to see others' stats
        return
    }

    x = chX + ((chW / 2) - (HEALTH_WIDTH / 2))
    y = (chY + chH) + 8.0
    percent = (Float(se!.health) / Float(se!.maxhealth)) * HEALTH_WIDTH

    //color of the bar
    aColor[0] = 0.0
    aColor[1] = 1.0
    aColor[2] = 0.0
    aColor[3] = 0.4

    //color of the border
    bColor[0] = 0.0
    bColor[1] = 0.0
    bColor[2] = 0.0
    bColor[3] = 0.3

    //color of greyed out "missing health"
    cColor[0] = 0.5
    cColor[1] = 0.5
    cColor[2] = 0.5
    cColor[3] = 0.4

    //draw the background (black)
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
    // Raven wrote: CG_DrawRect(x, y, HEALTH_WIDTH, HEALTH_HEIGHT, 1.0f, colorTable[CT_BLACK])
    portMissing("CG_DrawSiegeInfo", source: "oracle/codemp/cgame/cg_draw.c:4489")

    //now draw the part to show how much health there is in the color specified
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
    // Raven wrote: CG_FillRect(x+1.0f, y+1.0f, percent-1.0f, HEALTH_HEIGHT-1.0f, aColor)
    portMissing("CG_DrawSiegeInfo", source: "oracle/codemp/cgame/cg_draw.c:4489")

    //then draw the other part greyed out
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
    // Raven wrote: CG_FillRect(x+percent, y+1.0f, HEALTH_WIDTH-percent-1.0f, HEALTH_HEIGHT-1.0f, cColor)
    portMissing("CG_DrawSiegeInfo", source: "oracle/codemp/cgame/cg_draw.c:4489")


    //now draw his ammo
    ammoMax = ammoData[weaponData[cent.currentState.weapon].ammoIndex].max
    if (cent.currentState.eFlags & EF_DOUBLE_AMMO) != 0 {
        ammoMax *= 2
    }

    x = chX + ((chW / 2) - (HEALTH_WIDTH / 2))
    y = (chY + chH) + HEALTH_HEIGHT + 10.0

    if weaponData[cent.currentState.weapon].energyPerShot == 0 && weaponData[cent.currentState.weapon].altEnergyPerShot == 0 {
        //a weapon that takes no ammo, so show full
        percent = HEALTH_WIDTH
    } else {
        percent = (Float(se!.ammo) / Float(ammoMax)) * HEALTH_WIDTH
    }

    //color of the bar
    aColor[0] = 1.0
    aColor[1] = 1.0
    aColor[2] = 0.0
    aColor[3] = 0.4

    //color of the border
    bColor[0] = 0.0
    bColor[1] = 0.0
    bColor[2] = 0.0
    bColor[3] = 0.3

    //color of greyed out "missing health"
    cColor[0] = 0.5
    cColor[1] = 0.5
    cColor[2] = 0.5
    cColor[3] = 0.4

    //draw the background (black)
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
    // Raven wrote: CG_DrawRect(x, y, HEALTH_WIDTH, HEALTH_HEIGHT, 1.0f, colorTable[CT_BLACK])
    portMissing("CG_DrawSiegeInfo", source: "oracle/codemp/cgame/cg_draw.c:4489")

    //now draw the part to show how much health there is in the color specified
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
    // Raven wrote: CG_FillRect(x+1.0f, y+1.0f, percent-1.0f, HEALTH_HEIGHT-1.0f, aColor)
    portMissing("CG_DrawSiegeInfo", source: "oracle/codemp/cgame/cg_draw.c:4489")

    //then draw the other part greyed out
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
    // Raven wrote: CG_FillRect(x+percent, y+1.0f, HEALTH_WIDTH-percent-1.0f, HEALTH_HEIGHT-1.0f, cColor)
    portMissing("CG_DrawSiegeInfo", source: "oracle/codemp/cgame/cg_draw.c:4489")
}

//draw the health bar based on current "health" and maxhealth
/// Source: oracle/codemp/cgame/cg_draw.c:4632
func CG_DrawHealthBar(_ cent: Centity, _ chX: Float, _ chY: Float, _ chW: Float, _ chH: Float) {
    var aColor = vec4_t()
    var bColor = vec4_t()
    var cColor = vec4_t()
    let x: Float = chX + ((chW / 2) - (HEALTH_WIDTH / 2))
    let y: Float = (chY + chH) + 8.0
    let percent: Float = (Float(cent.currentState.health) / Float(cent.currentState.maxhealth)) * HEALTH_WIDTH
    if percent <= 0 {
        return
    }

    //color of the bar
    if cent.currentState.teamowner == 0 || cgs.gametype < GT_TEAM {
        //not owned by a team or teamplay
        aColor[0] = 1.0
        aColor[1] = 1.0
        aColor[2] = 0.0
        aColor[3] = 0.4
    } else if cent.currentState.teamowner == cg.predictedPlayerState.persistant[PERS_TEAM] {
        //owned by my team
        aColor[0] = 0.0
        aColor[1] = 1.0
        aColor[2] = 0.0
        aColor[3] = 0.4
    } else {
        //hostile
        aColor[0] = 1.0
        aColor[1] = 0.0
        aColor[2] = 0.0
        aColor[3] = 0.4
    }

    //color of the border
    bColor[0] = 0.0
    bColor[1] = 0.0
    bColor[2] = 0.0
    bColor[3] = 0.3

    //color of greyed out "missing health"
    cColor[0] = 0.5
    cColor[1] = 0.5
    cColor[2] = 0.5
    cColor[3] = 0.4

    //draw the background (black)
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
    // Raven wrote: CG_DrawRect(x, y, HEALTH_WIDTH, HEALTH_HEIGHT, 1.0f, colorTable[CT_BLACK])
    portMissing("CG_DrawHealthBar", source: "oracle/codemp/cgame/cg_draw.c:4632")

    //now draw the part to show how much health there is in the color specified
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
    // Raven wrote: CG_FillRect(x+1.0f, y+1.0f, percent-1.0f, HEALTH_HEIGHT-1.0f, aColor)
    portMissing("CG_DrawHealthBar", source: "oracle/codemp/cgame/cg_draw.c:4632")

    //then draw the other part greyed out
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
    // Raven wrote: CG_FillRect(x+percent, y+1.0f, HEALTH_WIDTH-percent-1.0f, HEALTH_HEIGHT-1.0f, cColor)
    portMissing("CG_DrawHealthBar", source: "oracle/codemp/cgame/cg_draw.c:4632")
}

//same routine (at least for now), draw progress of a "hack" or whatever
/// Source: oracle/codemp/cgame/cg_draw.c:4691
func CG_DrawHaqrBar(_ chX: Float, _ chY: Float, _ chW: Float, _ chH: Float) {
    var aColor = vec4_t()
    var bColor = vec4_t()
    var cColor = vec4_t()
    let x: Float = chX + ((chW / 2) - (HEALTH_WIDTH / 2))
    let y: Float = (chY + chH) + 8.0
    let percent: Float = ((Float(cg.predictedPlayerState.hackingTime) - Float(cg.time)) / Float(cg.predictedPlayerState.hackingBaseTime)) * HEALTH_WIDTH

    if percent > HEALTH_WIDTH || percent < 1.0 {
        return
    }

    //color of the bar
    aColor[0] = 1.0
    aColor[1] = 1.0
    aColor[2] = 0.0
    aColor[3] = 0.4

    //color of the border
    bColor[0] = 0.0
    bColor[1] = 0.0
    bColor[2] = 0.0
    bColor[3] = 0.3

    //color of greyed out done area
    cColor[0] = 0.5
    cColor[1] = 0.5
    cColor[2] = 0.5
    cColor[3] = 0.1

    //draw the background (black)
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
    // Raven wrote: CG_DrawRect(x, y, HEALTH_WIDTH, HEALTH_HEIGHT, 1.0f, colorTable[CT_BLACK])
    portMissing("CG_DrawHaqrBar", source: "oracle/codemp/cgame/cg_draw.c:4691")

    //now draw the part to show how much health there is in the color specified
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
    // Raven wrote: CG_FillRect(x+1.0f, y+1.0f, percent-1.0f, HEALTH_HEIGHT-1.0f, aColor)
    portMissing("CG_DrawHaqrBar", source: "oracle/codemp/cgame/cg_draw.c:4691")

    //then draw the other part greyed out
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
    // Raven wrote: CG_FillRect(x+percent, y+1.0f, HEALTH_WIDTH-percent-1.0f, HEALTH_HEIGHT-1.0f, cColor)
    portMissing("CG_DrawHaqrBar", source: "oracle/codemp/cgame/cg_draw.c:4691")

    //draw the hacker icon
    CG_DrawPic(x, y - HEALTH_WIDTH, HEALTH_WIDTH, HEALTH_WIDTH, cgs.media.hackerIconShader)
}

/// Source: oracle/codemp/cgame/cg_draw.c:4745
func CG_DrawGenericTimerBar() {
    var aColor = vec4_t()
    var bColor = vec4_t()
    var cColor = vec4_t()
    let x: Float = CGTIMERBAR_X
    let y: Float = CGTIMERBAR_Y
    var percent: Float = (Float((cg_genericTimerBar - cg.time)) / Float(cg_genericTimerDur)) * CGTIMERBAR_H

    if percent > CGTIMERBAR_H {
        return
    }

    if percent < 0.1 {
        percent = 0.1
    }

    //color of the bar
    aColor[0] = cg_genericTimerColor[0]
    aColor[1] = cg_genericTimerColor[1]
    aColor[2] = cg_genericTimerColor[2]
    aColor[3] = cg_genericTimerColor[3]

    //color of the border
    bColor[0] = 0.0
    bColor[1] = 0.0
    bColor[2] = 0.0
    bColor[3] = 0.3

    //color of greyed out "missing fuel"
    cColor[0] = 0.5
    cColor[1] = 0.5
    cColor[2] = 0.5
    cColor[3] = 0.1

    //draw the background (black)
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
    // Raven wrote: CG_DrawRect(x, y, CGTIMERBAR_W, CGTIMERBAR_H, 1.0f, colorTable[CT_BLACK])
    portMissing("CG_DrawGenericTimerBar", source: "oracle/codemp/cgame/cg_draw.c:4745")

    //now draw the part to show how much health there is in the color specified
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
    // Raven wrote: CG_FillRect(x+1.0f, y+1.0f+(CGTIMERBAR_H-percent), CGTIMERBAR_W-2.0f, CGTIMERBAR_H-1.0f-(CGTIMERBAR_H-percent), aColor)
    portMissing("CG_DrawGenericTimerBar", source: "oracle/codemp/cgame/cg_draw.c:4745")

    //then draw the other part greyed out
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
    // Raven wrote: CG_FillRect(x+1.0f, y+1.0f, CGTIMERBAR_W-2.0f, CGTIMERBAR_H-percent, cColor)
    portMissing("CG_DrawGenericTimerBar", source: "oracle/codemp/cgame/cg_draw.c:4745")
}

/// Source: oracle/codemp/cgame/cg_draw.c:4806
func CG_LerpCrosshairPos(_ x: inout Float, _ y: inout Float) {
    if cg_crosshairPrevPosX != 0 {
        //blend from old pos
        var maxMove: Float = 30.0 * (Float(cg.frametime) / 500.0) * 640.0 / 480.0
        let xDiff: Float = (x - cg_crosshairPrevPosX)
        if abs(xDiff) > CRAZY_CROSSHAIR_MAX_ERROR_X {
            maxMove = CRAZY_CROSSHAIR_MAX_ERROR_X
        }
        if xDiff > maxMove {
            x = cg_crosshairPrevPosX + maxMove
        } else if xDiff < -maxMove {
            x = cg_crosshairPrevPosX - maxMove
        }
    }
    cg_crosshairPrevPosX = x

    if cg_crosshairPrevPosY != 0 {
        //blend from old pos
        var maxMove: Float = 30.0 * (Float(cg.frametime) / 500.0)
        let yDiff: Float = (y - cg_crosshairPrevPosY)
        if abs(yDiff) > CRAZY_CROSSHAIR_MAX_ERROR_Y {
            maxMove = CRAZY_CROSSHAIR_MAX_ERROR_X
        }
        if yDiff > maxMove {
            y = cg_crosshairPrevPosY + maxMove
        } else if yDiff < -maxMove {
            y = cg_crosshairPrevPosY - maxMove
        }
    }
    cg_crosshairPrevPosY = y
}

/// Source: oracle/codemp/cgame/cg_draw.c:4848
private func CG_DrawCrosshair(_ worldPoint: JKAShared.vec3_t?, _ chEntValid: Int32) {
    var w: Float
    var h: Float
    var hShader: qhandle_t = 0
    var f: Float
    var x: Float = 0
    var y: Float = 0
    var corona: Bool = false
    var ecolor = vec4_t(0, 0, 0, 0)
    var crossEnt: Centity? = nil
    let chX: Float
    var chY: Float


    if worldPoint != nil {
        cg_crosshairPos = worldPoint!
    }

    if cg_drawCrosshair.integer == 0 {
        return
    }

    if cg.snap!.ps.fallingToDeath != 0 {
        return
    }

    if cg.predictedPlayerState.zoomMode != 0 {
        //not while scoped
        return
    }

    /*
    if ( cg_drawingRocketLockThisFrame
    && cg.snap->ps.m_iVehicleNum )
    {//in vehicle, rocket lock-on replaces crosshair
    return;
    }
    */

    if cg_crosshairHealth.integer != 0 {
        var hcolor = vec4_t()

        CG_ColorForHealth(&hcolor)
        trap_R_SetColor(hcolor)
    } else {
        //set color based on what kind of ent is under crosshair
        if cg.crosshairClientNum >= ENTITYNUM_WORLD {
            trap_R_SetColor(nil)
        } else if chEntValid != 0 && (cg_entities[cg.crosshairClientNum].currentState.number < MAX_CLIENTS || cg_entities[cg.crosshairClientNum].currentState.eType == ET_NPC || cg_entities[cg.crosshairClientNum].currentState.shouldtarget || cg_entities[cg.crosshairClientNum].currentState.health != 0 || (cg_entities[cg.crosshairClientNum].currentState.eType == ET_MOVER && cg_entities[cg.crosshairClientNum].currentState.bolt1 != 0 && cg.predictedPlayerState.weapon == WP_SABER) || (cg_entities[cg.crosshairClientNum].currentState.eType == ET_MOVER && cg_entities[cg.crosshairClientNum].currentState.teamowner != 0)) {
            //rwwFIXMEFIXME: Write this a different way, it's getting a bit too sloppy looking
            crossEnt = cg_entities[cg.crosshairClientNum]

            if (crossEnt!.currentState.powerups & (1 << PW_CLOAKED)) != 0 {
                //don't show up for cloaked guys
                ecolor[0] = 1.0 //R
                ecolor[1] = 1.0 //G
                ecolor[2] = 1.0 //B
            } else if crossEnt!.currentState.number < MAX_CLIENTS {
                if cgs.gametype >= GT_TEAM && cgs.clientinfo[crossEnt!.currentState.number].team == cgs.clientinfo[cg.snap!.ps.clientNum].team {
                    //Allies are green
                    ecolor[0] = 0.0 //R
                    ecolor[1] = 1.0 //G
                    ecolor[2] = 0.0 //B
                } else {
                    if cgs.gametype == GT_POWERDUEL && cgs.clientinfo[crossEnt!.currentState.number].duelTeam == cgs.clientinfo[cg.snap!.ps.clientNum].duelTeam {
                        //on the same duel team in powerduel, so he's a friend
                        ecolor[0] = 0.0 //R
                        ecolor[1] = 1.0 //G
                        ecolor[2] = 0.0 //B
                    } else {
                        //Enemies are red
                        ecolor[0] = 1.0 //R
                        ecolor[1] = 0.0 //G
                        ecolor[2] = 0.0 //B
                    }
                }

                if cg.snap!.ps.duelInProgress {
                    if crossEnt!.currentState.number != cg.snap!.ps.duelIndex {
                        //grey out crosshair for everyone but your foe if you're in a duel
                        ecolor[0] = 0.4
                        ecolor[1] = 0.4
                        ecolor[2] = 0.4
                    }
                } else if crossEnt!.currentState.bolt1 != 0 {
                    //this fellow is in a duel. We just checked if we were in a duel above, so
                    //this means we aren't and he is. Which of course means our crosshair greys out over him.
                    ecolor[0] = 0.4
                    ecolor[1] = 0.4
                    ecolor[2] = 0.4
                }
            } else if crossEnt!.currentState.shouldtarget || crossEnt!.currentState.eType == ET_NPC {
                //VectorCopy( crossEnt->startRGBA, ecolor );
                if ecolor[0] == 0 && ecolor[1] == 0 && ecolor[2] == 0 {
                    // We really don't want black, so set it to yellow
                    ecolor[0] = 1.0 //R
                    ecolor[1] = 0.8 //G
                    ecolor[2] = 0.3 //B
                }

                if crossEnt!.currentState.eType == ET_NPC {
                    let plTeam: Int32
                    if cgs.gametype == GT_SIEGE {
                        plTeam = cg.predictedPlayerState.persistant[PERS_TEAM]
                    } else {
                        plTeam = NPCTEAM_PLAYER
                    }

                    if (crossEnt!.currentState.powerups & (1 << PW_CLOAKED)) != 0 {
                        ecolor[0] = 1.0 //R
                        ecolor[1] = 1.0 //G
                        ecolor[2] = 1.0 //B
                    } else if crossEnt!.currentState.teamowner == 0 {
                        //not on a team
                        if crossEnt!.currentState.teamowner == 0 || crossEnt!.currentState.NPC_class == CLASS_VEHICLE {
                            //neutral
                            if crossEnt!.currentState.owner < MAX_CLIENTS {
                                //base color on who is pilotting this thing
                                let ci: ClientInfo? = cgs.clientinfo[crossEnt!.currentState.owner]

                                if cgs.gametype >= GT_TEAM && ci!.team == cg.predictedPlayerState.persistant[PERS_TEAM] {
                                    //friendly
                                    ecolor[0] = 0.0 //R
                                    ecolor[1] = 1.0 //G
                                    ecolor[2] = 0.0 //B
                                } else {
                                    //hostile
                                    ecolor[0] = 1.0 //R
                                    ecolor[1] = 0.0 //G
                                    ecolor[2] = 0.0 //B
                                }
                            } else {
                                //unmanned
                                ecolor[0] = 1.0 //R
                                ecolor[1] = 1.0 //G
                                ecolor[2] = 0.0 //B
                            }
                        } else {
                            ecolor[0] = 1.0 //R
                            ecolor[1] = 0.0 //G
                            ecolor[2] = 0.0 //B
                        }
                    } else if crossEnt!.currentState.teamowner != plTeam {
                        // on enemy team
                        ecolor[0] = 1.0 //R
                        ecolor[1] = 0.0 //G
                        ecolor[2] = 0.0 //B
                    } else {
                        //a friend
                        ecolor[0] = 0.0 //R
                        ecolor[1] = 1.0 //G
                        ecolor[2] = 0.0 //B
                    }
                } else if crossEnt!.currentState.teamowner == TEAM_RED || crossEnt!.currentState.teamowner == TEAM_BLUE {
                    if cgs.gametype < GT_TEAM {
                        //not teamplay, just neutral then
                        ecolor[0] = 1.0 //R
                        ecolor[1] = 1.0 //G
                        ecolor[2] = 0.0 //B
                    } else if crossEnt!.currentState.teamowner != cgs.clientinfo[cg.snap!.ps.clientNum].team {
                        //on the enemy team
                        ecolor[0] = 1.0 //R
                        ecolor[1] = 0.0 //G
                        ecolor[2] = 0.0 //B
                    } else {
                        //on my team
                        ecolor[0] = 0.0 //R
                        ecolor[1] = 1.0 //G
                        ecolor[2] = 0.0 //B
                    }
                } else if crossEnt!.currentState.owner == cg.snap!.ps.clientNum || (cgs.gametype >= GT_TEAM && crossEnt!.currentState.teamowner == cgs.clientinfo[cg.snap!.ps.clientNum].team) {
                    ecolor[0] = 0.0 //R
                    ecolor[1] = 1.0 //G
                    ecolor[2] = 0.0 //B
                } else if crossEnt!.currentState.teamowner == 16 || (cgs.gametype >= GT_TEAM && crossEnt!.currentState.teamowner != 0 && crossEnt!.currentState.teamowner != cgs.clientinfo[cg.snap!.ps.clientNum].team) {
                    ecolor[0] = 1.0 //R
                    ecolor[1] = 0.0 //G
                    ecolor[2] = 0.0 //B
                }
            } else if crossEnt!.currentState.eType == ET_MOVER && crossEnt!.currentState.bolt1 != 0 && cg.predictedPlayerState.weapon == WP_SABER {
                //can push/pull this mover. Only show it if we're using the saber.
                ecolor[0] = 0.2
                ecolor[1] = 0.5
                ecolor[2] = 1.0

                corona = true
            } else if crossEnt!.currentState.eType == ET_MOVER && crossEnt!.currentState.teamowner != 0 {
                //a team owns this - if it's my team green, if not red, if not teamplay then yellow
                if cgs.gametype < GT_TEAM {
                    ecolor[0] = 1.0 //R
                    ecolor[1] = 1.0 //G
                    ecolor[2] = 0.0 //B
                } else if cg.predictedPlayerState.persistant[PERS_TEAM] != crossEnt!.currentState.teamowner {
                    //not my team
                    ecolor[0] = 1.0 //R
                    ecolor[1] = 0.0 //G
                    ecolor[2] = 0.0 //B
                } else {
                    //my team
                    ecolor[0] = 0.0 //R
                    ecolor[1] = 1.0 //G
                    ecolor[2] = 0.0 //B
                }
            } else if crossEnt!.currentState.health != 0 {
                if crossEnt!.currentState.teamowner == 0 || cgs.gametype < GT_TEAM {
                    //not owned by a team or teamplay
                    ecolor[0] = 1.0
                    ecolor[1] = 1.0
                    ecolor[2] = 0.0
                } else if crossEnt!.currentState.teamowner == cg.predictedPlayerState.persistant[PERS_TEAM] {
                    //owned by my team
                    ecolor[0] = 0.0
                    ecolor[1] = 1.0
                    ecolor[2] = 0.0
                } else {
                    //hostile
                    ecolor[0] = 1.0
                    ecolor[1] = 0.0
                    ecolor[2] = 0.0
                }
            }

            ecolor[3] = 1.0

            trap_R_SetColor(ecolor)
        }
    }

    if cg.predictedPlayerState.m_iVehicleNum != 0 {
        //I'm in a vehicle
        let vehCent: Centity? = cg_entities[cg.predictedPlayerState.m_iVehicleNum]
        if vehCent != nil && vehCent!.m_pVehicle != nil && vehCent!.m_pVehicle!.m_pVehicleInfo != nil && vehCent!.m_pVehicle!.m_pVehicleInfo!.crosshairShaderHandle != 0 {
            hShader = vehCent!.m_pVehicle!.m_pVehicleInfo!.crosshairShaderHandle
        }
        //bigger by default
        w = cg_crosshairSize.value * 2.0
        h = w
    } else {
        h = cg_crosshairSize.value
        w = h
    }

    // pulse the size of the crosshair when picking up items
    f = Float(cg.time - cg.itemPickupBlendTime)
    if f > 0 && f < ITEM_BLOB_TIME {
        f /= ITEM_BLOB_TIME
        w *= (1 + f)
        h *= (1 + f)
    }

    if worldPoint != nil && VectorLength(worldPoint!) != 0 {
        if !CG_WorldCoordToScreenCoordFloat(worldPoint, &x, &y) {
            //off screen, don't draw it
            return
        }
        //CG_LerpCrosshairPos( &x, &y );
        x -= 320
        y -= 240
    } else {
        x = Float(cg_crosshairX.integer)
        y = Float(cg_crosshairY.integer)
    }

    if hShader == 0 {
        hShader = cgs.media.crosshairShader[cg_drawCrosshair.integer % NUM_CROSSHAIRS]
    }

    chX = Float(Double(x + cg.refdef.x) + 0.5 * Double(640 - w))
    chY = Float(Double(y + cg.refdef.y) + 0.5 * Double(480 - h))
    trap_R_DrawStretchPic(chX, chY, w, h, 0, 0, 1, 1, hShader)

    //draw a health bar directly under the crosshair if we're looking at something
    //that takes damage
    if crossEnt != nil && crossEnt!.currentState.maxhealth != 0 {
        CG_DrawHealthBar(crossEnt!, chX, chY, w, h)
        chY += HEALTH_HEIGHT * 2
    } else if crossEnt != nil && crossEnt!.currentState.number < MAX_CLIENTS {
        if cgs.gametype == GT_SIEGE {
            CG_DrawSiegeInfo(crossEnt!, chX, chY, w, h)
            chY += HEALTH_HEIGHT * 4
        }
        if cg.crosshairVehNum != 0 && cg.time == cg.crosshairVehTime {
            //it was in the crosshair this frame
            let hisVeh: Centity? = cg_entities[cg.crosshairVehNum]

            if hisVeh!.currentState.eType == ET_NPC && hisVeh!.currentState.NPC_class == CLASS_VEHICLE && hisVeh!.currentState.maxhealth != 0 && hisVeh!.m_pVehicle != nil {
                //draw the health for this vehicle
                CG_DrawHealthBar(hisVeh!, chX, chY, w, h)
                chY += HEALTH_HEIGHT * 2
            }
        }
    }

    if cg.predictedPlayerState.hackingTime != 0 {
        //hacking something
        CG_DrawHaqrBar(chX, chY, w, h)
    }

    if cg_genericTimerBar > cg.time {
        //draw generic timing bar, can be used for whatever
        CG_DrawGenericTimerBar()
    }

    if corona {
        ecolor[3] = 0.5
        ecolor[2] = (1 - ecolor[3]) * (sin(cg.time * 0.001) * 0.08 + 0.35) // don't draw full color
        ecolor[1] = ecolor[2] // don't draw full color
        ecolor[0] = ecolor[1] // don't draw full color
        ecolor[3] = 1.0

        trap_R_SetColor(ecolor)

        w *= 2.0
        h *= 2.0

        trap_R_DrawStretchPic(Float(Double(x + cg.refdef.x) + 0.5 * Double(640 - w)), Float(Double(y + cg.refdef.y) + 0.5 * Double(480 - h)), w, h, 0, 0, 1, 1, cgs.media.forceCoronaShader)
    }
}

/// Source: oracle/codemp/cgame/cg_draw.c:5270
func CG_WorldCoordToScreenCoordFloat(_ worldCoord: JKAShared.vec3_t?, _ x: inout Float, _ y: inout Float) -> Bool {
    let xcenter: Float
    let ycenter: Float
    var local = vec3_t()
    var transformed = vec3_t()
    var vfwd = vec3_t()
    var vright = vec3_t()
    var vup = vec3_t()
    let xzi: Float
    let yzi: Float

    //	xcenter = cg.refdef.width / 2;//gives screen coords adjusted for resolution
    //	ycenter = cg.refdef.height / 2;//gives screen coords adjusted for resolution

    //NOTE: did it this way because most draw functions expect virtual 640x480 coords
    //	and adjust them for current resolution
    xcenter = 640.0 / 2.0 //gives screen coords in virtual 640x480, to be adjusted when drawn
    ycenter = 480.0 / 2.0 //gives screen coords in virtual 640x480, to be adjusted when drawn

    AngleVectors(cg.refdef.viewangles, &vfwd, &vright, &vup)

    local = worldCoord! - cg.refdef.vieworg

    transformed[0] = _DotProduct(local, vright)
    transformed[1] = _DotProduct(local, vup)
    transformed[2] = _DotProduct(local, vfwd)

    // Make sure Z is not negative.
    if transformed[2] < 0.01 {
        return false
    }

    xzi = xcenter / transformed[2] * (96.0 / cg.refdef.fov_x)
    yzi = ycenter / transformed[2] * (102.0 / cg.refdef.fov_y)

    x = xcenter + xzi * transformed[0]
    y = ycenter - yzi * transformed[1]

    return true
}

/// Source: oracle/codemp/cgame/cg_draw.c:5311
func CG_WorldCoordToScreenCoord(_ worldCoord: JKAShared.vec3_t, _ x: inout Int32, _ y: inout Int32) -> Bool {
    var xF: Float = 0
    var yF: Float = 0
    let retVal: Bool = CG_WorldCoordToScreenCoordFloat(worldCoord, &xF, &yF)
    x = Int32(xF)
    y = Int32(yF)
    return retVal
}

/// Source: oracle/codemp/cgame/cg_draw.c:5327
func CG_SaberClashFlare() {
    var t: Int32 = 0
    let maxTime: Int32 = 150
    var dif = vec3_t()
    var color = vec3_t()
    var x: Int32 = 0
    var y: Int32 = 0
    var v: Float = 0
    var len: Float = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in

        t = cg.time - cg_saberFlashTime

        if t <= 0 || t >= maxTime {
            return true
        }

        // Don't do clashes for things that are behind us
        dif = cg_saberFlashPos - cg.refdef.vieworg

        if Double(_DotProduct(dif, cg.refdef.viewaxis[0])) < 0.2 {
            return true
        }

        CG_Trace(tr, cg.refdef.vieworg, nil, nil, cg_saberFlashPos, -1, CONTENTS_SOLID)

        if tr.fraction < 1.0 {
            return true
        }

        len = VectorNormalize(&dif)

        // clamp to a known range
        /*
        if ( len > 800 )
        {
        len = 800;
        }
        */
        if len > 1200 {
            return true
        }

        v = (1.0 - (Float(t) / maxTime)) * ((1.0 - (len / 800.0)) * 2.0 + 0.35)
        if v < 0.001 {
            v = 0.001
        }

        CG_WorldCoordToScreenCoord(cg_saberFlashPos, &x, &y)

        color = vec3_t(0.8, 0.8, 0.8)
        // Port-note: Raven passes his `vec3_t color` to `trap_R_SetColor`, which reads four floats. The fourth float is a read past the array, so the site needs a rule 19 ruling.
        // Raven wrote: trap_R_SetColor( color )
        portMissing("CG_SaberClashFlare", source: "oracle/codemp/cgame/cg_draw.c:5327")

        CG_DrawPic(x - (v * 300), y - (v * 300), v * 600, v * 600, trap_R_RegisterShader("gfx/effects/saberFlare"))
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/cgame/cg_draw.c:5388
func CG_DottedLine(_ x1: Float, _ y1: Float, _ x2: Float, _ y2: Float, _ dotSize: Float, _ numDots: Int32, _ color: JKAShared.vec4_t, _ alpha: Float) {
    var x: Float
    var y: Float
    let xDiff: Float
    let yDiff: Float
    let xStep: Float
    let yStep: Float
    var colorRGBA = vec4_t()
    var dotNum: Int32 = 0

    // Raven wrote: VectorCopy4( color, colorRGBA )
    colorRGBA = color
    colorRGBA[3] = alpha

    trap_R_SetColor(colorRGBA)

    xDiff = x2 - x1
    yDiff = y2 - y1
    xStep = xDiff / Float(numDots)
    yStep = yDiff / Float(numDots)

    dotNum = 0
    while dotNum < numDots {
        x = x1 + (xStep * dotNum) - (dotSize * 0.5)
        y = y1 + (yStep * dotNum) - (dotSize * 0.5)

        CG_DrawPic(x, y, dotSize, dotSize, cgs.media.whiteShader)
        dotNum += 1
    }
}

/// Source: oracle/codemp/cgame/cg_draw.c:5413
func CG_BracketEntity(_ cent: Centity, _ radius: Float) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in
        var dif = vec3_t()
        var len: Float = 0
        var size: Float = 0
        var lineLength: Float = 0
        var lineWidth: Float = 0
        var x: Float = 0
        var y: Float = 0
        var local: ClientInfo?
        var isEnemy: Bool = false

        dif = cent.lerpOrigin - cg.refdef.vieworg
        len = VectorNormalize(&dif)

        if cg.crosshairClientNum != cent.currentState.clientNum && (cg.snap == nil || cg.snap!.ps.rocketLockIndex != cent.currentState.clientNum) {
            //if they're the entity you're locking onto or under your crosshair, always draw bracket
            //Hmm... for now, if they're closer than 2000, don't bracket?
            if len < 2000.0 {
                return true
            }

            CG_Trace(tr, cg.refdef.vieworg, nil, nil, cent.lerpOrigin, -1, CONTENTS_OPAQUE)

            //don't bracket if can't see them
            if tr.fraction < 1.0 {
                return true
            }
        }

        if !CG_WorldCoordToScreenCoordFloat(cent.lerpOrigin, &x, &y) {
            //off-screen, don't draw it
            return true
        }

        //just to see if it's centered
        //CG_DrawPic( x-2, y-2, 4, 4, cgs.media.whiteShader );

        local = cgs.clientinfo[cg.snap!.ps.clientNum]
        if cent.currentState.m_iVehicleNum != 0 && cgs.clientinfo[cent.currentState.m_iVehicleNum - 1].infoValid {
            if cgs.gametype < GT_TEAM {
                //ffa?
                isEnemy = true
                // Port-note: No operator between the operands, the text there is ``.
                // Raven wrote: trap_R_SetColor ( g_color_table[ColorIndex(COLOR_RED)] )
                portMissing("CG_BracketEntity", source: "oracle/codemp/cgame/cg_draw.c:5413")
            } else if cgs.clientinfo[cent.currentState.m_iVehicleNum - 1].team == local!.team {
                // Port-note: No operator between the operands, the text there is ``.
                // Raven wrote: trap_R_SetColor ( g_color_table[ColorIndex(COLOR_GREEN)] )
                portMissing("CG_BracketEntity", source: "oracle/codemp/cgame/cg_draw.c:5413")
            } else {
                isEnemy = true
                // Port-note: No operator between the operands, the text there is ``.
                // Raven wrote: trap_R_SetColor ( g_color_table[ColorIndex(COLOR_RED)] )
                portMissing("CG_BracketEntity", source: "oracle/codemp/cgame/cg_draw.c:5413")
            }
        } else if cent.currentState.teamowner != 0 {
            if cgs.gametype < GT_TEAM {
                //ffa?
                isEnemy = true
                // Port-note: No operator between the operands, the text there is ``.
                // Raven wrote: trap_R_SetColor ( g_color_table[ColorIndex(COLOR_RED)] )
                portMissing("CG_BracketEntity", source: "oracle/codemp/cgame/cg_draw.c:5413")
            } else if cent.currentState.teamowner != cg.predictedPlayerState.persistant[PERS_TEAM] {
                // on enemy team
                isEnemy = true
                // Port-note: No operator between the operands, the text there is ``.
                // Raven wrote: trap_R_SetColor ( g_color_table[ColorIndex(COLOR_RED)] )
                portMissing("CG_BracketEntity", source: "oracle/codemp/cgame/cg_draw.c:5413")
            } else {
                //a friend
                // Port-note: No operator between the operands, the text there is ``.
                // Raven wrote: trap_R_SetColor ( g_color_table[ColorIndex(COLOR_GREEN)] )
                portMissing("CG_BracketEntity", source: "oracle/codemp/cgame/cg_draw.c:5413")
            }
        } else {
            //FIXME: if we want to ever bracket anything besides vehicles (like siege objectives we want to blow up), we should handle the coloring here
            trap_R_SetColor(nil)
        }

        if len <= 1.0 {
            //super-close, max out at 400 times radius (which is HUGE)
            size = radius * 400.0
        } else {
            //scale by dist
            size = radius * (400.0 / len)
        }

        if size < 1.0 {
            size = 1.0
        }

        //length scales with dist
        lineLength = (size * 0.1)
        if lineLength < 0.5 {
            //always visible
            lineLength = 0.5
        }
        //always visible width
        lineWidth = 1.0

        x -= (size * 0.5)
        y -= (size * 0.5)

        /*
        if ( x >= 0 && x <= 640
        && y >= 0 && y <= 480 )
        */
        do {
            //brackets would be drawn on the screen, so draw them
            //upper left corner
            //horz
            CG_DrawPic(x, y, lineLength, lineWidth, cgs.media.whiteShader)
            //vert
            CG_DrawPic(x, y, lineWidth, lineLength, cgs.media.whiteShader)
            //upper right corner
            //horz
            CG_DrawPic(x + size - lineLength, y, lineLength, lineWidth, cgs.media.whiteShader)
            //vert
            CG_DrawPic(x + size - lineWidth, y, lineWidth, lineLength, cgs.media.whiteShader)
            //lower left corner
            //horz
            CG_DrawPic(x, y + size - lineWidth, lineLength, lineWidth, cgs.media.whiteShader)
            //vert
            CG_DrawPic(x, y + size - lineLength, lineWidth, lineLength, cgs.media.whiteShader)
            //lower right corner
            //horz
            CG_DrawPic(x + size - lineLength, y + size - lineWidth, lineLength, lineWidth, cgs.media.whiteShader)
            //vert
            CG_DrawPic(x + size - lineWidth, y + size - lineLength, lineWidth, lineLength, cgs.media.whiteShader)
        }
        //Lead Indicator...
        if cg_drawVehLeadIndicator.integer != 0 {
            //draw the lead indicator
            if isEnemy {
                //an enemy object
                if cent.currentState.NPC_class == CLASS_VEHICLE {
                    //enemy vehicle
                    if VectorCompare(cent.currentState.pos.trDelta, vec3_origin) == 0 {
                        //enemy vehicle is moving
                        if cg.predictedPlayerState.m_iVehicleNum != 0 {
                            //I'm in a vehicle
                            let veh: Centity? = cg_entities[cg.predictedPlayerState.m_iVehicleNum]
                            if veh != nil && veh!.m_pVehicle != nil && veh!.m_pVehicle!.m_pVehicleInfo != nil && veh!.m_pVehicle!.m_pVehicleInfo!.weapon[0].ID > VEH_WEAPON_BASE {
                                let vehWeapon: VehWeaponInfo? = g_vehWeaponInfo[veh!.m_pVehicle!.m_pVehicleInfo!.weapon[0].ID]
                                if vehWeapon != nil && vehWeapon!.bIsProjectile && !vehWeapon!.bHasGravity && vehWeapon!.fHoming == 0 && vehWeapon!.fSpeed != 0 {
                                    //our primary weapon's projectile has a speed
                                    var vehDiff = vec3_t()
                                    var vehLeadPos = vec3_t()
                                    var vehDist: Float = 0
                                    var eta: Float = 0
                                    var leadX: Float = 0
                                    var leadY: Float = 0

                                    vehDiff = cent.lerpOrigin - cg.predictedVehicleState.origin
                                    vehDist = VectorNormalize(&vehDiff)
                                    eta = (vehDist / vehWeapon!.fSpeed) //how many seconds it would take for my primary weapon's projectile to get from my ship to theirs
                                    //now extrapolate their position that number of seconds into the future based on their velocity
                                    _VectorMA(cent.lerpOrigin, eta, cent.currentState.pos.trDelta, &vehLeadPos)
                                    //now we have where we should be aiming at, project that onto the screen at a 2D co-ord
                                    if !CG_WorldCoordToScreenCoordFloat(cent.lerpOrigin, &x, &y) {
                                        //off-screen, don't draw it
                                        return true
                                    }
                                    if !CG_WorldCoordToScreenCoordFloat(vehLeadPos, &leadX, &leadY) {
                                        //off-screen, don't draw it
                                        //just draw the line
                                        // Port-note: No operator between the operands, the text there is ``.
                                        // Raven wrote: CG_DottedLine( x, y, leadX, leadY, 1, 10, g_color_table[ColorIndex(COLOR_RED)], 0.5f )
                                        portMissing("CG_BracketEntity", source: "oracle/codemp/cgame/cg_draw.c:5413")
                                        return true
                                    }
                                    //draw a line from the ship's cur pos to the lead pos
                                    // Port-note: No operator between the operands, the text there is ``.
                                    // Raven wrote: CG_DottedLine( x, y, leadX, leadY, 1, 10, g_color_table[ColorIndex(COLOR_RED)], 0.5f )
                                    portMissing("CG_BracketEntity", source: "oracle/codemp/cgame/cg_draw.c:5413")
                                    //now draw the lead indicator
                                    // Port-note: No operator between the operands, the text there is ``.
                                    // Raven wrote: trap_R_SetColor ( g_color_table[ColorIndex(COLOR_RED)] )
                                    portMissing("CG_BracketEntity", source: "oracle/codemp/cgame/cg_draw.c:5413")
                                    CG_DrawPic(leadX - 8, leadY - 8, 16, 16, trap_R_RegisterShader("gfx/menus/radar/lead"))
                                }
                            }
                        }
                    }
                }
            }
        }
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/cgame/cg_draw.c:5602
func CG_InFighter() -> Bool {
    if cg.predictedPlayerState.m_iVehicleNum != 0 {
        //I'm in a vehicle
        let vehCent: Centity? = cg_entities[cg.predictedPlayerState.m_iVehicleNum]
        if vehCent != nil && vehCent!.m_pVehicle != nil && vehCent!.m_pVehicle!.m_pVehicleInfo != nil && vehCent!.m_pVehicle!.m_pVehicleInfo!.type == VH_FIGHTER {
            //I'm in a fighter
            return true
        }
    }
    return false
}

/// Source: oracle/codemp/cgame/cg_draw.c:5618
func CG_InATST() -> Bool {
    if cg.predictedPlayerState.m_iVehicleNum != 0 {
        //I'm in a vehicle
        let vehCent: Centity? = cg_entities[cg.predictedPlayerState.m_iVehicleNum]
        if vehCent != nil && vehCent!.m_pVehicle != nil && vehCent!.m_pVehicle!.m_pVehicleInfo != nil && vehCent!.m_pVehicle!.m_pVehicleInfo!.type == VH_WALKER {
            //I'm in an atst
            return true
        }
    }
    return false
}

/// Source: oracle/codemp/cgame/cg_draw.c:5634
func CG_DrawBracketedEntities() {
    var i: Int32
    i = 0
    while i < cg.bracketedEntityCount {
        let cent: Centity? = cg_entities[cg.bracketedEntities[i]]
        CG_BracketEntity(cent!, CG_RadiusForCent(cent!))
        i += 1
    }
}

//--------------------------------------------------------------
/// Source: oracle/codemp/cgame/cg_draw.c:5645
private func CG_DrawHolocronIcons() {
    let icon_size: Int32 = 40
    var i: Int32 = 0
    var startx: Int32 = 10
    var starty: Int32 = 10

    let endx: Int32 = icon_size
    let endy: Int32 = icon_size

    if cg.snap!.ps.zoomMode != 0 {
        //don't display over zoom mask
        return
    }

    if cgs.clientinfo[cg.snap!.ps.clientNum].team == TEAM_SPECTATOR {
        return
    }

    while i < NUM_FORCE_POWERS {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'forcePowerSorted' in scope".
        // Raven wrote: if (cg.snap->ps.holocronBits & (1 << forcePowerSorted[i])) { CG_DrawPic( startx, starty, endx, endy, cgs.media.forcePowerIcons[forcePowerSorted[i]]); starty += (icon_size+2); //+2 for spacing if ((starty+icon_size) >= SCREEN_HEIGHT-80) { starty = 10;//SCREEN_HEIGHT - icon_size*3; startx += (icon_size+2); } }
        portMissing("CG_DrawHolocronIcons", source: "oracle/codemp/cgame/cg_draw.c:5645")

        i += 1
    }
}

/// Source: oracle/codemp/cgame/cg_draw.c:5683
private func CG_IsDurationPower(_ power: Int32) -> Bool {
    if power == FP_HEAL || power == FP_SPEED || power == FP_TELEPATHY || power == FP_RAGE || power == FP_PROTECT || power == FP_ABSORB || power == FP_SEE {
        return true
    }

    return false
}

//--------------------------------------------------------------
/// Source: oracle/codemp/cgame/cg_draw.c:5700
private func CG_DrawActivePowers() {
    let icon_size: Int32 = 40
    var i: Int32 = 0
    var startx: Int32 = icon_size * 2 + 16
    var starty: Int32 = SCREEN_HEIGHT - icon_size * 2

    let endx: Int32 = icon_size
    let endy: Int32 = icon_size

    if cg.snap!.ps.zoomMode != 0 {
        //don't display over zoom mask
        return
    }

    if cgs.clientinfo[cg.snap!.ps.clientNum].team == TEAM_SPECTATOR {
        return
    }

    while i < NUM_FORCE_POWERS {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type '_' to expected argument type 'Bool'".
        // Raven wrote: if ((cg.snap->ps.fd.forcePowersActive & (1 << forcePowerSorted[i])) && CG_IsDurationPower(forcePowerSorted[i])) { CG_DrawPic( startx, starty, endx, endy, cgs.media.forcePowerIcons[forcePowerSorted[i]]); startx += (icon_size+2); //+2 for spacing if ((startx+icon_size) >= SCREEN_WIDTH-80) { startx = icon_size*2+16; starty += (icon_size+2); } }
        portMissing("CG_DrawActivePowers", source: "oracle/codemp/cgame/cg_draw.c:5700")

        i += 1
    }

    //additionally, draw an icon force force rage recovery
    if cg.snap!.ps.fd.forceRageRecoveryTime > cg.time {
        CG_DrawPic(Float(startx), Float(starty), Float(endx), Float(endy), cgs.media.rageRecShader)
    }
}

//static qboolean	cg_drawingRocketLockThisFrame = qfalse;
//--------------------------------------------------------------
/// Source: oracle/codemp/cgame/cg_draw.c:5747
private func CG_DrawRocketLocking(_ lockEntNum: Int32, _ lockTime: Int32) {
    var cx: Int32 = 0
    var cy: Int32 = 0
    var org = vec3_t()
    var oldDif: Int32 = 0
    let cent: Centity? = cg_entities[lockEntNum]
    var color = vec4_t(0.0, 0.0, 0.0, 0.0)
    var lockTimeInterval: Float = ((cgs.gametype == GT_SIEGE) ? 2400.0 : 1200.0) / 16.0
    //FIXME: if in a vehicle, use the vehicle's lockOnTime...
    var dif: Int32 = Int32((cg.time - cg.snap!.ps.rocketLockTime) / lockTimeInterval)
    var i: Int32

    //	cg_drawingRocketLockThisFrame = qfalse;

    if cg.snap!.ps.rocketLockTime == 0 {
        return
    }

    if cgs.clientinfo[cg.snap!.ps.clientNum].team == TEAM_SPECTATOR {
        return
    }

    if cg.snap!.ps.m_iVehicleNum != 0 {
        //driving a vehicle
        let veh: Centity? = cg_entities[cg.snap!.ps.m_iVehicleNum]
        if veh!.m_pVehicle != nil {
            var vehWeapon: VehWeaponInfo? = nil
            if cg.predictedVehicleState.weaponstate == WEAPON_CHARGING_ALT {
                if veh!.m_pVehicle!.m_pVehicleInfo!.weapon[1].ID > VEH_WEAPON_BASE && veh!.m_pVehicle!.m_pVehicleInfo!.weapon[1].ID < MAX_VEH_WEAPONS {
                    vehWeapon = g_vehWeaponInfo[veh!.m_pVehicle!.m_pVehicleInfo!.weapon[1].ID]
                }
            } else {
                if veh!.m_pVehicle!.m_pVehicleInfo!.weapon[0].ID > VEH_WEAPON_BASE && veh!.m_pVehicle!.m_pVehicleInfo!.weapon[0].ID < MAX_VEH_WEAPONS {
                    vehWeapon = g_vehWeaponInfo[veh!.m_pVehicle!.m_pVehicleInfo!.weapon[0].ID]
                }
            }
            if vehWeapon != nil {
                //we are trying to lock on with a valid vehicle weapon, so use *its* locktime, not the hard-coded one
                if vehWeapon!.iLockOnTime == 0 {
                    //instant lock-on
                    dif = 10
                } else {
                    //use the custom vehicle lockOnTime
                    lockTimeInterval = (vehWeapon!.iLockOnTime / 16.0)
                    dif = Int32((cg.time - cg.snap!.ps.rocketLockTime) / lockTimeInterval)
                }
            }
        }
    }
    //We can't check to see in pmove if players are on the same team, so we resort
    //to just not drawing the lock if a teammate is the locked on ent
    if cg.snap!.ps.rocketLockIndex >= 0 && cg.snap!.ps.rocketLockIndex < ENTITYNUM_NONE {
        var ci: ClientInfo? = nil

        if cg.snap!.ps.rocketLockIndex < MAX_CLIENTS {
            ci = cgs.clientinfo[cg.snap!.ps.rocketLockIndex]
        } else {
            ci = cg_entities[cg.snap!.ps.rocketLockIndex].npcClient
        }

        if ci != nil {
            if ci!.team == cgs.clientinfo[cg.snap!.ps.clientNum].team {
                if cgs.gametype >= GT_TEAM {
                    return
                }
            } else if cgs.gametype >= GT_TEAM {
                let hitEnt: Centity? = cg_entities[cg.snap!.ps.rocketLockIndex]
                if hitEnt!.currentState.eType == ET_NPC && hitEnt!.currentState.NPC_class == CLASS_VEHICLE && hitEnt!.currentState.owner < ENTITYNUM_WORLD {
                    //this is a vehicle, if it has a pilot and that pilot is on my team, then...
                    if hitEnt!.currentState.owner < MAX_CLIENTS {
                        ci = cgs.clientinfo[hitEnt!.currentState.owner]
                    } else {
                        ci = cg_entities[hitEnt!.currentState.owner].npcClient
                    }
                    if ci != nil && ci!.team == cgs.clientinfo[cg.snap!.ps.clientNum].team {
                        return
                    }
                }
            }
        }
    }

    if cg.snap!.ps.rocketLockTime != -1 {
        lastvalidlockdif = dif
    } else {
        dif = lastvalidlockdif
    }

    if cent == nil {
        return
    }

    org = cent!.lerpOrigin

    if CG_WorldCoordToScreenCoord(org, &cx, &cy) {
        // we care about distance from enemy to eye, so this is good enough
        var sz: Float = Distance(cent!.lerpOrigin, cg.refdef.vieworg) / 1024.0

        if sz > 1.0 {
            sz = 1.0
        } else if sz < 0.0 {
            sz = 0.0
        }

        sz = (1.0 - sz) * (1.0 - sz) * 32 + 6

        if cg.snap!.ps.m_iVehicleNum != 0 {
            sz *= 2.0
        }

        cy = Int32(Float(cy) + sz * 0.5)

        if dif < 0 {
            oldDif = 0
            return
        } else if dif > 8 {
            dif = 8
        }

        // do sounds
        if oldDif != dif {
            if dif == 8 {
                if cg.snap!.ps.m_iVehicleNum != 0 {
                    trap_S_StartSound(&org, 0, CHAN_AUTO, trap_S_RegisterSound("sound/vehicles/weapons/common/lock.wav"))
                } else {
                    trap_S_StartSound(&org, 0, CHAN_AUTO, trap_S_RegisterSound("sound/weapons/rocket/lock.wav"))
                }
            } else {
                if cg.snap!.ps.m_iVehicleNum != 0 {
                    trap_S_StartSound(&org, 0, CHAN_AUTO, trap_S_RegisterSound("sound/vehicles/weapons/common/tick.wav"))
                } else {
                    trap_S_StartSound(&org, 0, CHAN_AUTO, trap_S_RegisterSound("sound/weapons/rocket/tick.wav"))
                }
            }
        }

        oldDif = dif

        i = 0
        while i < dif {
            color[0] = 1.0
            color[1] = 0.0
            color[2] = 0.0
            color[3] = 0.1 * i + 0.2

            trap_R_SetColor(color)

            // our slices are offset by about 45 degrees.
            CG_DrawRotatePic(cx - sz, cy - sz, sz, sz, i * 45.0, trap_R_RegisterShaderNoMip("gfx/2d/wedge"))
            i += 1
        }

        // we are locked and loaded baby
        if dif == 8 {
            color[2] = sin(cg.time * 0.05) * 0.5 + 0.5
            color[1] = color[2]
            color[0] = color[1]
            color[3] = 1.0 // this art is additive, so the alpha value does nothing

            trap_R_SetColor(color)

            CG_DrawPic(cx - sz, cy - sz * 2, sz * 2, sz * 2, trap_R_RegisterShaderNoMip("gfx/2d/lock"))
        }
        //		cg_drawingRocketLockThisFrame = qtrue;
    }
}

/// Source: oracle/codemp/cgame/cg_draw.c:5963
func CG_CalcVehicleMuzzlePoint(_ entityNum: Int32, _ start: inout JKAShared.vec3_t, _ d_f: inout JKAShared.vec3_t, _ d_rt: inout JKAShared.vec3_t, _ d_up: inout JKAShared.vec3_t) -> Bool {
    let vehCent: Centity? = cg_entities[entityNum]
    if vehCent!.m_pVehicle != nil && vehCent!.m_pVehicle!.m_pVehicleInfo!.type == VH_WALKER {
        //draw from barrels
        start = vehCent!.lerpOrigin
        start[2] += vehCent!.m_pVehicle!.m_pVehicleInfo!.height - DEFAULT_MINS_2 - 48
        AngleVectors(vehCent!.lerpAngles, &d_f, &d_rt, &d_up)
        /*
        mdxaBone_t		boltMatrix;
        int				bolt;
        vec3_t			yawOnlyAngles;

        VectorSet( yawOnlyAngles, 0, vehCent->lerpAngles[YAW], 0 );

        bolt = trap_G2API_AddBolt( vehCent->ghoul2, 0, "*flash1");
        trap_G2API_GetBoltMatrix( vehCent->ghoul2, 0, bolt, &boltMatrix,
        yawOnlyAngles, vehCent->lerpOrigin, cg.time,
        NULL, vehCent->modelScale );

        // work the matrix axis stuff into the original axis and origins used.
        BG_GiveMeVectorFromMatrix( &boltMatrix, ORIGIN, start );
        BG_GiveMeVectorFromMatrix( &boltMatrix, POSITIVE_X, d_f );
        VectorClear( d_rt );//don't really need this, do we?
        VectorClear( d_up );//don't really need this, do we?
        */
    } else {
        //check to see if we're a turret gunner on this vehicle
        if cg.predictedPlayerState.generic1 != 0 {
            //passenger in a vehicle
            if vehCent!.m_pVehicle != nil && vehCent!.m_pVehicle!.m_pVehicleInfo != nil && vehCent!.m_pVehicle!.m_pVehicleInfo!.maxPassengers != 0 {
                //a vehicle capable of carrying passengers
                var turretNum: Int32
                turretNum = 0
                while turretNum < MAX_VEHICLE_TURRETS {
                    if vehCent!.m_pVehicle!.m_pVehicleInfo!.turret[turretNum].iAmmoMax != 0 {
                        // valid turret
                        if vehCent!.m_pVehicle!.m_pVehicleInfo!.turret[turretNum].passengerNum == cg.predictedPlayerState.generic1 {
                            //I control this turret
                            //Go through all muzzles, average their positions and directions and use the result for crosshair trace
                            var vehMuzzle: Int32
                            var numMuzzles: Int32 = 0
                            var muzzlesAvgPos = vec3_t(0, 0, 0)
                            var muzzlesAvgDir = vec3_t(0, 0, 0)
                            var i: Int32

                            i = 0
                            while i < MAX_VEHICLE_TURRET_MUZZLES {
                                vehMuzzle = vehCent!.m_pVehicle!.m_pVehicleInfo!.turret[turretNum].iMuzzle[i]
                                if vehMuzzle != 0 {
                                    vehMuzzle -= 1
                                    CG_CalcVehMuzzle(vehCent!.m_pVehicle!, vehCent!, vehMuzzle)
                                    muzzlesAvgPos = muzzlesAvgPos + vehCent!.m_pVehicle!.m_vMuzzlePos[vehMuzzle]
                                    muzzlesAvgDir = muzzlesAvgDir + vehCent!.m_pVehicle!.m_vMuzzleDir[vehMuzzle]
                                    numMuzzles += 1
                                }
                                if numMuzzles != 0 {
                                    start = muzzlesAvgPos * (1.0 / Float(numMuzzles))
                                    d_f = muzzlesAvgDir * (1.0 / Float(numMuzzles))
                                    d_rt = vec3_t()
                                    d_up = vec3_t()
                                    return true
                                }
                                i += 1
                            }
                        }
                    }
                    turretNum += 1
                }
            }
        }
        start = vehCent!.lerpOrigin
        AngleVectors(vehCent!.lerpAngles, &d_f, &d_rt, &d_up)
    }
    return false
}

//calc the muzzle point from the e-web itself
/// Source: oracle/codemp/cgame/cg_draw.c:6043
func CG_CalcEWebMuzzlePoint(_ cent: Centity, _ start: inout JKAShared.vec3_t, _ d_f: inout JKAShared.vec3_t, _ d_rt: inout JKAShared.vec3_t, _ d_up: inout JKAShared.vec3_t) {
    let bolt: Int32 = trap_G2API_AddBolt(cent.ghoul2, 0, "*cannonflash")


    if bolt != -1 {
        // Raven's record lives to the end of his block, so the block is the closure.
        MdxaBone.scratch { boltMatrix in

            trap_G2API_GetBoltMatrix_NoRecNoRot(cent.ghoul2, 0, bolt, boltMatrix, cent.lerpAngles, cent.lerpOrigin, cg.time, nil, &cent.modelScale)
            BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &start)
            BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_X, &d_f)

            //these things start the shot a little inside the bbox to assure not starting in something solid
            _VectorMA(start, -16.0, d_f, &start)

            //I guess
            d_rt = vec3_t() //don't really need this, do we?
            d_up = vec3_t() //don't really need this, do we?
        }
    }
}

/// Source: oracle/codemp/cgame/cg_draw.c:6072
private func CG_ScanForCrosshairEntity() {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { trace -> Bool in
        var start = vec3_t()
        var end = vec3_t()
        var content: Int32 = 0
        var ignore: Int32 = 0
        var bVehCheckTraceFromCamPos: Bool = false

        ignore = cg.predictedPlayerState.clientNum

        if cg_dynamicCrosshair.integer != 0 {
            var d_f = vec3_t()
            var d_rt = vec3_t()
            var d_up = vec3_t()
            /*
            if ( cg.snap->ps.weapon == WP_NONE ||
            cg.snap->ps.weapon == WP_SABER ||
            cg.snap->ps.weapon == WP_STUN_BATON)
            {
            VectorCopy( cg.refdef.vieworg, start );
            AngleVectors( cg.refdef.viewangles, d_f, d_rt, d_up );
            }
            else
            */
            //For now we still want to draw the crosshair in relation to the player's world coordinates
            //even if we have a melee weapon/no weapon.
            if cg.predictedPlayerState.m_iVehicleNum != 0 && (cg.predictedPlayerState.eFlags & EF_NODRAW) != 0 {
                //we're *inside* a vehicle
                //do the vehicle's crosshair instead
                let veh: Centity? = cg_entities[cg.predictedPlayerState.m_iVehicleNum]
                var gunner: Bool = false

                //if (veh->currentState.owner == cg.predictedPlayerState.clientNum)
                do {
                    //the pilot
                    ignore = cg.predictedPlayerState.m_iVehicleNum
                    gunner = CG_CalcVehicleMuzzlePoint(cg.predictedPlayerState.m_iVehicleNum, &start, &d_f, &d_rt, &d_up)
                }
                /*
                else
                { //a passenger
                ignore = cg.predictedPlayerState.m_iVehicleNum;
                VectorCopy( veh->lerpOrigin, start );
                AngleVectors( veh->lerpAngles, d_f, d_rt, d_up );
                VectorMA(start, 32.0f, d_f, start); //super hack
                }
                */
                if veh!.m_pVehicle != nil && veh!.m_pVehicle!.m_pVehicleInfo != nil && veh!.m_pVehicle!.m_pVehicleInfo!.type == VH_FIGHTER && cg.distanceCull > MAX_XHAIR_DIST_ACCURACY && !gunner {
                    //NOTE: on huge maps, the crosshair gets inaccurate at close range,
                    //		so we'll do an extra G2 trace from the cg.refdef.vieworg
                    //		to see if we hit anything closer and auto-aim at it if so
                    bVehCheckTraceFromCamPos = true
                }
            } else if cg.snap != nil && cg.snap!.ps.weapon == WP_EMPLACED_GUN && cg.snap!.ps.emplacedIndex != 0 && cg_entities[cg.snap!.ps.emplacedIndex].ghoul2 != nil && cg_entities[cg.snap!.ps.emplacedIndex].currentState.weapon == WP_NONE {
                //locked into our e-web, calc the muzzle from it
                CG_CalcEWebMuzzlePoint(cg_entities[cg.snap!.ps.emplacedIndex], &start, &d_f, &d_rt, &d_up)
            } else {
                if cg.snap != nil && cg.snap!.ps.weapon == WP_EMPLACED_GUN && cg.snap!.ps.emplacedIndex != 0 {
                    var pitchConstraint = vec3_t()

                    ignore = cg.snap!.ps.emplacedIndex

                    pitchConstraint = cg.refdef.viewangles

                    if cg.renderingThirdPerson {
                        pitchConstraint = cg.predictedPlayerState.viewangles
                    } else {
                        pitchConstraint = cg.refdef.viewangles
                    }

                    if pitchConstraint[PITCH] > 40 {
                        pitchConstraint[PITCH] = 40
                    }

                    AngleVectors(pitchConstraint, &d_f, &d_rt, &d_up)
                } else {
                    var pitchConstraint = vec3_t()

                    if cg.renderingThirdPerson {
                        pitchConstraint = cg.predictedPlayerState.viewangles
                    } else {
                        pitchConstraint = cg.refdef.viewangles
                    }

                    AngleVectors(pitchConstraint, &d_f, &d_rt, &d_up)
                }
                CG_CalcMuzzlePoint(cg.snap!.ps.clientNum, &start)
            }

            _VectorMA(start, cg.distanceCull, d_f, &end)
        } else {
            start = cg.refdef.vieworg
            _VectorMA(start, 131072, cg.refdef.viewaxis[0], &end)
        }

        if cg_dynamicCrosshair.integer != 0 && cg_dynamicCrosshairPrecision.integer != 0 {
            //then do a trace with ghoul2 models in mind
            CG_G2Trace(trace, start, vec3_origin, vec3_origin, end, ignore, CONTENTS_SOLID | CONTENTS_BODY)
            if bVehCheckTraceFromCamPos {
                //NOTE: this MUST stay up to date with the method used in WP_VehCheckTraceFromCamPos
                let veh: Centity? = cg_entities[cg.predictedPlayerState.m_iVehicleNum]
                // Raven's record lives to the end of his block, so the block is the closure.
                Trace.scratch { extraTrace in
                    var viewDir2End = vec3_t()
                    var extraEnd = vec3_t()
                    let minAutoAimDist: Float = Distance(veh!.lerpOrigin, cg.refdef.vieworg) + (veh!.m_pVehicle!.m_pVehicleInfo!.length / 2.0) + 200.0

                    viewDir2End = end - cg.refdef.vieworg
                    VectorNormalize(&viewDir2End)
                    _VectorMA(cg.refdef.vieworg, MAX_XHAIR_DIST_ACCURACY, viewDir2End, &extraEnd)
                    CG_G2Trace(extraTrace, cg.refdef.vieworg, vec3_origin, vec3_origin, extraEnd, ignore, CONTENTS_SOLID | CONTENTS_BODY)
                    if extraTrace.allsolid == 0 && extraTrace.startsolid == 0 {
                        if extraTrace.fraction < 1.0 {
                            if (extraTrace.fraction * MAX_XHAIR_DIST_ACCURACY) > minAutoAimDist {
                                if ((extraTrace.fraction * MAX_XHAIR_DIST_ACCURACY) - Distance(veh!.lerpOrigin, cg.refdef.vieworg)) < (trace.fraction * cg.distanceCull) {
                                    //this trace hit *something* that's closer than the thing the main trace hit, so use this result instead
                                    trace.copy(from: extraTrace)
                                }
                            }
                        }
                    }
                }
            }
        } else {
            CG_Trace(trace, start, vec3_origin, vec3_origin, end, ignore, CONTENTS_SOLID | CONTENTS_BODY)
        }

        if trace.entityNum < MAX_CLIENTS {
            if CG_IsMindTricked(cg_entities[trace.entityNum].currentState.trickedentindex, cg_entities[trace.entityNum].currentState.trickedentindex2, cg_entities[trace.entityNum].currentState.trickedentindex3, cg_entities[trace.entityNum].currentState.trickedentindex4, cg.snap!.ps.clientNum) != 0 {
                if cg.crosshairClientNum == trace.entityNum {
                    cg.crosshairClientNum = ENTITYNUM_NONE
                    cg.crosshairClientTime = 0
                }

                CG_DrawCrosshair(trace.endpos, 0)

                return true //this entity is mind-tricking the current client, so don't render it
            }
        }

        if cg.snap!.ps.persistant[PERS_TEAM] != TEAM_SPECTATOR {
            if trace.entityNum < ENTITYNUM_WORLD {
                cg.crosshairClientNum = trace.entityNum
                cg.crosshairClientTime = cg.time

                if cg.crosshairClientNum < ENTITYNUM_WORLD {
                    let veh: Centity? = cg_entities[cg.crosshairClientNum]

                    if veh!.currentState.eType == ET_NPC && veh!.currentState.NPC_class == CLASS_VEHICLE && veh!.currentState.owner < MAX_CLIENTS {
                        //draw the name of the pilot then
                        cg.crosshairClientNum = veh!.currentState.owner
                        cg.crosshairVehNum = veh!.currentState.number
                        cg.crosshairVehTime = cg.time
                    }
                }

                CG_DrawCrosshair(trace.endpos, 1)
            } else {
                CG_DrawCrosshair(trace.endpos, 0)
            }
        }

        //	if ( trace.entityNum >= MAX_CLIENTS ) {
        //		return;
        //	}

        // if the player is in fog, don't show it
        content = trap_CM_PointContents(trace.endpos, 0)
        if (content & CONTENTS_FOG) != 0 {
            return true
        }

        // update the fade timer
        cg.crosshairClientNum = trace.entityNum
        cg.crosshairClientTime = cg.time
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/cgame/cg_draw.c:6288
func CG_SanitizeString(_ `in`: String, _ out: inout JKAShared.CharBuf) {
    let `in` = CharBuf(`in`)
    var i: Int32 = 0
    var r: Int32 = 0
    var outIndex: Int32 = 0

    // Raven wrote: while (in[i]) { if (i >= 128-1) { //the ui truncates the name here.. break; } if (in[i] == '^') { if (in[i+1] >= 48 && //'0' in[i+1] <= 57) //'9' { //only skip it if there's a number after it for the color i += 2; continue; } else { //just skip the ^ i++; continue; } } if (in[i] < 32) { i++; continue; } out[r] = in[i]; r++; i++; }
    while `in`[i] != 0 {
        if i >= 128 - 1 {
            //the ui truncates the name here..
            break
        }

        if `in`[i] == Int32(ascii: "^") {
            if `in`[i + 1] >= 48 && //'0'
                `in`[i + 1] <= 57 { //'9'
                //only skip it if there's a number after it for the color
                i += 2
                continue
            } else {
                //just skip the ^
                i += 1
                continue
            }
        }

        if `in`[i] < 32 {
            i += 1
            continue
        }

        out[outIndex + r] = `in`[i]
        r += 1
        i += 1
    }
    out[outIndex + r] = 0
}

/**
```
=====================
CG_DrawCrosshairNames
=====================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:6333
private func CG_DrawCrosshairNames() {
    // Port-note: A pointer local `float * color` with no view.
    // Raven wrote: float *color;
    portMissing("CG_DrawCrosshairNames", source: "oracle/codemp/cgame/cg_draw.c:6333")
    var tcolor = vec4_t()
    let name: String
    var sanitized = CharBuf(1024)
    var baseColor: Int32
    var isVeh: Bool = false

    if cg_drawCrosshair.integer == 0 {
        return
    }

    // scan the known entities to see if the crosshair is sighted on one
    CG_ScanForCrosshairEntity()

    if cg_drawCrosshairNames.integer == 0 {
        return
    }
    //rww - still do the trace, our dynamic crosshair depends on it

    if cg.crosshairClientNum < ENTITYNUM_WORLD {
        let veh: Centity? = cg_entities[cg.crosshairClientNum]

        if veh!.currentState.eType == ET_NPC && veh!.currentState.NPC_class == CLASS_VEHICLE && veh!.currentState.owner < MAX_CLIENTS {
            //draw the name of the pilot then
            cg.crosshairClientNum = veh!.currentState.owner
            cg.crosshairVehNum = veh!.currentState.number
            cg.crosshairVehTime = cg.time
            isVeh = true //so we know we're drawing the pilot's name
        }
    }

    if cg.crosshairClientNum >= MAX_CLIENTS {
        return
    }

    if (cg_entities[cg.crosshairClientNum].currentState.powerups & (1 << PW_CLOAKED)) != 0 {
        return
    }

    // draw the name of the player being looked at
    // Port-note: A store into `color`, a local the draft left as a hole.
    // Raven wrote: color = CG_FadeColor( cg.crosshairClientTime, 1000 )
    portMissing("CG_DrawCrosshairNames", source: "oracle/codemp/cgame/cg_draw.c:6333")
    // Port-note: A read of `color`, a local the draft left as a hole.
    // Raven wrote: if ( !color ) { trap_R_SetColor( NULL ); return; }
    portMissing("CG_DrawCrosshairNames", source: "oracle/codemp/cgame/cg_draw.c:6333")

    name = cgs.clientinfo[cg.crosshairClientNum].name

    if cgs.gametype >= GT_TEAM {
        //if (cgs.gametype == GT_SIEGE)
        if 1 != 0 {
            //instead of team-based we'll make it oriented based on which team we're on
            if cgs.clientinfo[cg.crosshairClientNum].team == cg.predictedPlayerState.persistant[PERS_TEAM] {
                baseColor = CT_GREEN
            } else {
                baseColor = CT_RED
            }
        } else {
            if cgs.clientinfo[cg.crosshairClientNum].team == TEAM_RED {
                baseColor = CT_RED
            } else {
                baseColor = CT_BLUE
            }
        }
    } else {
        //baseColor = CT_WHITE;
        if cgs.gametype == GT_POWERDUEL && cgs.clientinfo[cg.snap!.ps.clientNum].team != TEAM_SPECTATOR && cgs.clientinfo[cg.crosshairClientNum].duelTeam == cgs.clientinfo[cg.predictedPlayerState.clientNum].duelTeam {
            //on the same duel team in powerduel, so he's a friend
            baseColor = CT_GREEN
        } else {
            baseColor = CT_RED //just make it red in nonteam modes since everyone is hostile and crosshair will be red on them too
        }
    }

    if cg.snap!.ps.duelInProgress {
        if cg.crosshairClientNum != cg.snap!.ps.duelIndex {
            //grey out crosshair for everyone but your foe if you're in a duel
            baseColor = CT_BLACK
        }
    } else if cg_entities[cg.crosshairClientNum].currentState.bolt1 != 0 {
        //this fellow is in a duel. We just checked if we were in a duel above, so
        //this means we aren't and he is. Which of course means our crosshair greys out over him.
        baseColor = CT_BLACK
    }

    tcolor[0] = colorTable[baseColor][0]
    tcolor[1] = colorTable[baseColor][1]
    tcolor[2] = colorTable[baseColor][2]
    // Port-note: A read of `color`, a local the draft left as a hole.
    // Raven wrote: tcolor[3] = color[3]*0.5f
    portMissing("CG_DrawCrosshairNames", source: "oracle/codemp/cgame/cg_draw.c:6333")

    CG_SanitizeString(name, &sanitized)

    if isVeh {
        var str = CharBuf(1024)
        Com_sprintf(&str, MAX_STRING_CHARS, "%s (pilot)", sanitized)
        UI_DrawProportionalString(320, 170, String(str), UI_CENTER, tcolor)
    } else {
        UI_DrawProportionalString(320, 170, String(sanitized), UI_CENTER, tcolor)
    }

    trap_R_SetColor(nil)
}

/**
```
=================
CG_DrawSpectator
=================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:6470
private func CG_DrawSpectator() {
    var s: String

    s = CG_GetStringEdString("MP_INGAME", "SPECTATOR")
    if (cgs.gametype == GT_DUEL || cgs.gametype == GT_POWERDUEL) && cgs.duelist1 != -1 && cgs.duelist2 != -1 {
        var text = CharBuf(1024)
        let size: Int32 = 64

        if cgs.gametype == GT_POWERDUEL && cgs.duelist3 != -1 {
            Com_sprintf(&text, Int32((text).count), "%s^7 %s %s^7 %s %s", cgs.clientinfo[cgs.duelist1].name, CG_GetStringEdString("MP_INGAME", "SPECHUD_VERSUS"), cgs.clientinfo[cgs.duelist2].name, CG_GetStringEdString("MP_INGAME", "AND"), cgs.clientinfo[cgs.duelist3].name)
        } else {
            Com_sprintf(&text, Int32((text).count), "%s^7 %s %s", cgs.clientinfo[cgs.duelist1].name, CG_GetStringEdString("MP_INGAME", "SPECHUD_VERSUS"), cgs.clientinfo[cgs.duelist2].name)
        }
        CG_Text_Paint(Float(320 - CG_Text_Width(String(text), 1.0, 3) / 2), 420, 1.0, colorWhite, String(text), 0, 0, 0, 3)

        trap_R_SetColor(colorTable[CT_WHITE])
        if cgs.clientinfo[cgs.duelist1].modelIcon != 0 {
            CG_DrawPic(10, Float(Double(SCREEN_HEIGHT) - (Double(size) * 1.5)), Float(size), Float(size), cgs.clientinfo[cgs.duelist1].modelIcon)
        }
        if cgs.clientinfo[cgs.duelist2].modelIcon != 0 {
            CG_DrawPic(Float(SCREEN_WIDTH - size - 10), Float(Double(SCREEN_HEIGHT) - (Double(size) * 1.5)), Float(size), Float(size), cgs.clientinfo[cgs.duelist2].modelIcon)
        }

        // nmckenzie: DUEL_HEALTH
        if cgs.gametype == GT_DUEL {
            if cgs.showDuelHealths >= 1 {
                // draw the healths on the two guys - how does this interact with power duel, though?
                CG_DrawDuelistHealth(10, Float(Double(SCREEN_HEIGHT) - (Double(size) * 1.5) - 12), 64, 8, 1)
                CG_DrawDuelistHealth(Float(SCREEN_WIDTH - size - 10), Float(Double(SCREEN_HEIGHT) - (Double(size) * 1.5) - 12), 64, 8, 2)
            }
        }

        if cgs.gametype != GT_POWERDUEL {
            Com_sprintf(&text, Int32((text).count), "%i/%i", cgs.clientinfo[cgs.duelist1].score, cgs.fraglimit)
            CG_Text_Paint(Float(42 - CG_Text_Width(String(text), 1.0, 2) / 2), Float(Double(SCREEN_HEIGHT) - (Double(size) * 1.5) + 64), 1.0, colorWhite, String(text), 0, 0, 0, 2)

            Com_sprintf(&text, Int32((text).count), "%i/%i", cgs.clientinfo[cgs.duelist2].score, cgs.fraglimit)
            CG_Text_Paint(Float(SCREEN_WIDTH - size + 22 - CG_Text_Width(String(text), 1.0, 2) / 2), Float(Double(SCREEN_HEIGHT) - (Double(size) * 1.5) + 64), 1.0, colorWhite, String(text), 0, 0, 0, 2)
        }

        if cgs.gametype == GT_POWERDUEL && cgs.duelist3 != -1 {
            if cgs.clientinfo[cgs.duelist3].modelIcon != 0 {
                CG_DrawPic(Float(SCREEN_WIDTH - size - 10), Float(Double(SCREEN_HEIGHT) - (Double(size) * 2.8)), Float(size), Float(size), cgs.clientinfo[cgs.duelist3].modelIcon)
            }
        }
    } else {
        CG_Text_Paint(Float(320 - CG_Text_Width(s, 1.0, 3) / 2), 420, 1.0, colorWhite, s, 0, 0, 0, 3)
    }

    if cgs.gametype == GT_DUEL || cgs.gametype == GT_POWERDUEL {
        s = CG_GetStringEdString("MP_INGAME", "WAITING_TO_PLAY") // "waiting to play";
        CG_Text_Paint(Float(320 - CG_Text_Width(s, 1.0, 3) / 2), 440, 1.0, colorWhite, s, 0, 0, 0, 3)
    } else {
        //s = "press ESC and use the JOIN menu to play";
        s = CG_GetStringEdString("MP_INGAME", "SPEC_CHOOSEJOIN")
        CG_Text_Paint(Float(320 - CG_Text_Width(s, 1.0, 3) / 2), 440, 1.0, colorWhite, s, 0, 0, 0, 3)
    }
}

/**
```
=================
CG_DrawVote
=================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:6552
private func CG_DrawVote() {
    var s: String
    var sec: Int32
    var sYes = CharBuf(20)
    var sNo = CharBuf(20)
    var sVote = CharBuf(20)
    var sCmd = CharBuf(100)
    // Raven wrote: const char* sParm = 0;
    var sParm: String? = nil

    if cgs.voteTime == 0 {
        return
    }

    // play a talk beep whenever it is modified
    if cgs.voteModified {
        cgs.voteModified = false
        //		trap_S_StartLocalSound( cgs.media.talkSound, CHAN_LOCAL_SOUND );
    }

    sec = (VOTE_TIME - (cg.time - cgs.voteTime)) / 1000
    if sec < 0 {
        sec = 0
    }

    if strncmp(cgs.voteString, "map_restart", 11) == 0 {
        strcpy(&sCmd, trap_SP_GetStringTextString("MENUS_RESTART_MAP", Int32((sCmd).count)).1)
    } else if strncmp(cgs.voteString, "vstr nextmap", 12) == 0 {
        strcpy(&sCmd, trap_SP_GetStringTextString("MENUS_NEXT_MAP", Int32((sCmd).count)).1)
    } else if strncmp(cgs.voteString, "g_doWarmup", 10) == 0 {
        strcpy(&sCmd, trap_SP_GetStringTextString("MENUS_WARMUP", Int32((sCmd).count)).1)
    } else if strncmp(cgs.voteString, "g_gametype", 10) == 0 {
        strcpy(&sCmd, trap_SP_GetStringTextString("MENUS_GAME_TYPE", Int32((sCmd).count)).1)
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'stricmp' in scope".
        // Raven wrote: if ( stricmp("Free For All", cgs.voteString+11)==0 ) { sParm = CG_GetStringEdString("MENUS", "FREE_FOR_ALL"); } else if ( stricmp("Duel", cgs.voteString+11)==0 ) { sParm = CG_GetStringEdString("MENUS", "DUEL"); } else if ( stricmp("Holocron FFA", cgs.voteString+11)==0 ) { sParm = CG_GetStringEdString("MENUS", "HOLOCRON_FFA"); } else if ( stricmp("Power Duel", cgs.voteString+11)==0 ) { sParm = CG_GetStringEdString("MENUS", "POWERDUEL"); } else if ( stricmp("Team FFA", cgs.voteString+11)==0 ) { sParm = CG_GetStringEdString("MENUS", "TEAM_FFA"); } else if ( stricmp("Siege", cgs.voteString+11)==0 ) { sParm = CG_GetStringEdString("MENUS", "SIEGE"); } else if ( stricmp("Capture the Flag", cgs.voteString+11)==0 ) { sParm = CG_GetStringEdString("MENUS", "CAPTURE_THE_FLAG"); } else if ( stricmp("Capture the Ysalamiri", cgs.voteString+11)==0 ) { sParm = CG_GetStringEdString("MENUS", "CAPTURE_THE_YSALIMARI"); }
        portMissing("CG_DrawVote", source: "oracle/codemp/cgame/cg_draw.c:6552")
    } else if strncmp(cgs.voteString, "map", 3) == 0 {
        strcpy(&sCmd, trap_SP_GetStringTextString("MENUS_NEW_MAP", Int32((sCmd).count)).1)
        // Raven wrote: sParm = cgs.voteString+4
        sParm = String(CharBuf(cgs.voteString)[4...])
    } else if strncmp(cgs.voteString, "kick", 4) == 0 {
        strcpy(&sCmd, trap_SP_GetStringTextString("MENUS_KICK_PLAYER", Int32((sCmd).count)).1)
        // Raven wrote: sParm = cgs.voteString+5
        sParm = String(CharBuf(cgs.voteString)[5...])
    }



    strcpy(&sVote, trap_SP_GetStringTextString("MENUS_VOTE", Int32((sVote).count)).1)
    strcpy(&sYes, trap_SP_GetStringTextString("MENUS_YES", Int32((sYes).count)).1)
    strcpy(&sNo, trap_SP_GetStringTextString("MENUS_NO", Int32((sNo).count)).1)

    // Raven wrote: if (sParm && sParm[0]) { s = va("%s(%i):<%s %s> %s:%i %s:%i", sVote, sec, sCmd, sParm, sYes, cgs.voteYes, sNo, cgs.voteNo); } else { s = va("%s(%i):<%s> %s:%i %s:%i", sVote, sec, sCmd, sYes, cgs.voteYes, sNo, cgs.voteNo); }
    if sParm != nil && !sParm!.isEmpty {
        s = va("%s(%i):<%s %s> %s:%i %s:%i", sVote, sec, sCmd, sParm!, sYes, cgs.voteYes, sNo, cgs.voteNo)
    } else {
        s = va("%s(%i):<%s> %s:%i %s:%i", sVote, sec, sCmd, sYes, cgs.voteYes, sNo, cgs.voteNo)
    }
    CG_DrawSmallString(4, 58, s, 1.0)
    s = CG_GetStringEdString("MP_INGAME", "OR_PRESS_ESC_THEN_CLICK_VOTE") //	s = "or press ESC then click Vote";
    CG_DrawSmallString(4, 58 + SMALLCHAR_HEIGHT + 2, s, 1.0)
}

/**
```
=================
CG_DrawTeamVote
=================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:6659
private func CG_DrawTeamVote() {
    var s: String
    var sec: Int32
    var cs_offset: Int32

    // Raven wrote: if ( cgs.clientinfo->team == TEAM_RED ) cs_offset = 0; else if ( cgs.clientinfo->team == TEAM_BLUE ) cs_offset = 1; else return
    if cgs.clientinfo[0].team == TEAM_RED {
        cs_offset = 0
    } else if cgs.clientinfo[0].team == TEAM_BLUE {
        cs_offset = 1
    } else {
        return
    }

    if cgs.teamVoteTime[cs_offset] == 0 {
        return
    }

    // play a talk beep whenever it is modified
    if cgs.teamVoteModified[cs_offset] {
        cgs.teamVoteModified[cs_offset] = false
        //		trap_S_StartLocalSound( cgs.media.talkSound, CHAN_LOCAL_SOUND );
    }

    sec = (VOTE_TIME - (cg.time - cgs.teamVoteTime[cs_offset])) / 1000
    if sec < 0 {
        sec = 0
    }
    if strstr(cgs.teamVoteString[cs_offset], "leader") != nil {
        var i: Int32 = 0

        // Raven wrote: while (cgs.teamVoteString[cs_offset][i] && cgs.teamVoteString[cs_offset][i] != ' ') { i++; }
        let teamVoteString = CharBuf(cgs.teamVoteString[cs_offset])
        while teamVoteString[i] != 0 && teamVoteString[i] != Int32(ascii: " ") {
            i += 1
        }

        // Raven wrote: if (cgs.teamVoteString[cs_offset][i] == ' ') { int voteIndex = 0; char voteIndexStr[256]; i++; while (cgs.teamVoteString[cs_offset][i]) { voteIndexStr[voteIndex] = cgs.teamVoteString[cs_offset][i]; voteIndex++; i++; } voteIndexStr[voteIndex] = 0; voteIndex = atoi(voteIndexStr); s = va("TEAMVOTE(%i):(Make %s the new team leader) yes:%i no:%i", sec, cgs.clientinfo[voteIndex].name, cgs.teamVoteYes[cs_offset], cgs.teamVoteNo[cs_offset] ); } else { s = va("TEAMVOTE(%i):%s yes:%i no:%i", sec, cgs.teamVoteString[cs_offset], cgs.teamVoteYes[cs_offset], cgs.teamVoteNo[cs_offset] ); }
        if teamVoteString[i] == Int32(ascii: " ") {
            var voteIndex: Int32 = 0
            var voteIndexStr = CharBuf(256)
            i += 1

            while teamVoteString[i] != 0 {
                voteIndexStr[voteIndex] = teamVoteString[i]
                voteIndex += 1
                i += 1
            }
            voteIndexStr[voteIndex] = 0

            voteIndex = atoi(voteIndexStr)

            s = va("TEAMVOTE(%i):(Make %s the new team leader) yes:%i no:%i", sec, cgs.clientinfo[voteIndex].name, cgs.teamVoteYes[cs_offset], cgs.teamVoteNo[cs_offset])
        } else {
            s = va("TEAMVOTE(%i):%s yes:%i no:%i", sec, cgs.teamVoteString[cs_offset], cgs.teamVoteYes[cs_offset], cgs.teamVoteNo[cs_offset])
        }
    } else {
        s = va("TEAMVOTE(%i):%s yes:%i no:%i", sec, cgs.teamVoteString[cs_offset], cgs.teamVoteYes[cs_offset], cgs.teamVoteNo[cs_offset])
    }
    CG_DrawSmallString(4, 90, s, 1.0)
}

/// Source: oracle/codemp/cgame/cg_draw.c:6727
private func CG_DrawScoreboard() -> Bool {
    return CG_DrawOldScoreboard()


    // should never happen in Team Arena

    // don't draw scoreboard during death while warmup up

    // next time scoreboard comes up, don't print killer




    // load any models that have been deferred
}

/**
```
=================
CG_DrawIntermission
=================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:6800
private func CG_DrawIntermission() {
    //	int key;
    //if (cg_singlePlayer.integer) {
    //	CG_DrawCenterString();
    //	return;
    //}
    cg.scoreFadeTime = cg.time
    cg.scoreBoardShowing = CG_DrawScoreboard()
}

/**
```
=================
CG_DrawFollow
=================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:6815
private func CG_DrawFollow() -> Bool {
    var s: String

    if !((cg.snap!.ps.pm_flags & PMF_FOLLOW) != 0) {
        return false
    }

    //	s = "following";
    if cgs.gametype == GT_POWERDUEL {
        let ci: ClientInfo? = cgs.clientinfo[cg.snap!.ps.clientNum]

        if ci!.duelTeam == DUELTEAM_LONE {
            s = CG_GetStringEdString("MP_INGAME", "FOLLOWINGLONE")
        } else if ci!.duelTeam == DUELTEAM_DOUBLE {
            s = CG_GetStringEdString("MP_INGAME", "FOLLOWINGDOUBLE")
        } else {
            s = CG_GetStringEdString("MP_INGAME", "FOLLOWING")
        }
    } else {
        s = CG_GetStringEdString("MP_INGAME", "FOLLOWING")
    }

    CG_Text_Paint(Float(320 - CG_Text_Width(s, 1.0, FONT_MEDIUM) / 2), 60, 1.0, colorWhite, s, 0, 0, 0, FONT_MEDIUM)

    s = cgs.clientinfo[cg.snap!.ps.clientNum].name
    CG_Text_Paint(Float(320 - CG_Text_Width(s, 2.0, FONT_MEDIUM) / 2), 80, 2.0, colorWhite, s, 0, 0, 0, FONT_MEDIUM)

    return true
}

/**
```
=================
CG_DrawAmmoWarning
=================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:6888
private func CG_DrawAmmoWarning() {
}

/**
```
=================
CG_DrawWarmup
=================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:6923
private func CG_DrawWarmup() {
    var w: Int32
    var sec: Int32
    var i: Int32
    var scale: Float
    var cw: Int32
    var s: String

    sec = cg.warmup
    if sec == 0 {
        return
    }

    if sec < 0 {
        //		s = "Waiting for players";
        s = CG_GetStringEdString("MP_INGAME", "WAITING_FOR_PLAYERS")
        w = CG_DrawStrlen(s) * BIGCHAR_WIDTH
        CG_DrawBigString(320 - w / 2, 24, s, 1.0)
        cg.warmupCount = 0
        return
    }

    if cgs.gametype == GT_DUEL || cgs.gametype == GT_POWERDUEL {
        // find the two active players
        var ci1: ClientInfo?
        var ci2: ClientInfo?
        var ci3: ClientInfo?

        ci1 = nil
        ci2 = nil
        ci3 = nil

        if cgs.gametype == GT_POWERDUEL {
            if cgs.duelist1 != -1 {
                ci1 = cgs.clientinfo[cgs.duelist1]
            }
            if cgs.duelist2 != -1 {
                ci2 = cgs.clientinfo[cgs.duelist2]
            }
            if cgs.duelist3 != -1 {
                ci3 = cgs.clientinfo[cgs.duelist3]
            }
        } else {
            i = 0
            while i < cgs.maxclients {
                if cgs.clientinfo[i].infoValid && cgs.clientinfo[i].team == TEAM_FREE {
                    if ci1 == nil {
                        ci1 = cgs.clientinfo[i]
                    } else {
                        ci2 = cgs.clientinfo[i]
                    }
                }
                i += 1
            }
        }
        if ci1 != nil && ci2 != nil {
            if ci3 != nil {
                s = va("%s vs %s and %s", ci1!.name, ci2!.name, ci3!.name)
            } else {
                s = va("%s vs %s", ci1!.name, ci2!.name)
            }
            w = CG_Text_Width(s, 0.6, FONT_MEDIUM)
            CG_Text_Paint(Float(320 - w / 2), 60, 0.6, colorWhite, s, 0, 0, ITEM_TEXTSTYLE_SHADOWEDMORE, FONT_MEDIUM)
        }
    } else {
        if cgs.gametype == GT_FFA {
            s = CG_GetStringEdString("MENUS", "FREE_FOR_ALL") //"Free For All";
        } else if cgs.gametype == GT_HOLOCRON {
            s = CG_GetStringEdString("MENUS", "HOLOCRON_FFA") //"Holocron FFA";
        } else if cgs.gametype == GT_JEDIMASTER {
            s = CG_GetStringEdString("MENUS", "POWERDUEL") //"Jedi Master";??
        } else if cgs.gametype == GT_TEAM {
            s = CG_GetStringEdString("MENUS", "TEAM_FFA") //"Team FFA";
        } else if cgs.gametype == GT_SIEGE {
            s = CG_GetStringEdString("MENUS", "SIEGE") //"Siege";
        } else if cgs.gametype == GT_CTF {
            s = CG_GetStringEdString("MENUS", "CAPTURE_THE_FLAG") //"Capture the Flag";
        } else if cgs.gametype == GT_CTY {
            s = CG_GetStringEdString("MENUS", "CAPTURE_THE_YSALIMARI") //"Capture the Ysalamiri";
        } else {
            s = ""
        }
        w = CG_Text_Width(s, 1.5, FONT_MEDIUM)
        CG_Text_Paint(Float(320 - w / 2), 90, 1.5, colorWhite, s, 0, 0, ITEM_TEXTSTYLE_SHADOWEDMORE, FONT_MEDIUM)
    }

    sec = (sec - cg.time) / 1000
    if sec < 0 {
        cg.warmup = 0
        sec = 0
    }
    //	s = va( "Starts in: %i", sec + 1 );
    s = va("%s: %i", CG_GetStringEdString("MP_INGAME", "STARTS_IN"), sec + 1)
    if sec != cg.warmupCount {
        cg.warmupCount = sec

        if cgs.gametype != GT_SIEGE {
            switch sec {
            case 0:
                trap_S_StartLocalSound(cgs.media.count1Sound, CHAN_ANNOUNCER)

            case 1:
                trap_S_StartLocalSound(cgs.media.count2Sound, CHAN_ANNOUNCER)

            case 2:
                trap_S_StartLocalSound(cgs.media.count3Sound, CHAN_ANNOUNCER)

            default:
                break
            }
        }
    }
    scale = 0.45
    switch cg.warmupCount {
    case 0:
        cw = 28
        scale = 1.25

    case 1:
        cw = 24
        scale = 1.15

    case 2:
        cw = 20
        scale = 1.05

    default:
        cw = 16
        scale = 0.9
    }

    w = CG_Text_Width(s, scale, FONT_MEDIUM)
    CG_Text_Paint(Float(320 - w / 2), 125, scale, colorWhite, s, 0, 0, ITEM_TEXTSTYLE_SHADOWEDMORE, FONT_MEDIUM)
}

//==================================================================================
/**
```
=================
CG_DrawTimedMenus
=================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:7073
func CG_DrawTimedMenus() {
    if cg.voiceTime != 0 {
        let t: Int32 = cg.time - cg.voiceTime
        if t > 2500 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menus_CloseByName' in scope".
            // Raven wrote: Menus_CloseByName("voiceMenu")
            portMissing("CG_DrawTimedMenus", source: "oracle/codemp/cgame/cg_draw.c:7073")
            trap_Cvar_Set("cl_conXOffset", "0")
            cg.voiceTime = 0
        }
    }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7084
func CG_DrawFlagStatus() {
    var myFlagTakenShader: Int32 = 0
    var theirFlagShader: Int32 = 0
    var team: Int32 = 0
    var startDrawPos: Int32 = 2
    let ico_size: Int32 = 32

    if cg.snap == nil {
        return
    }

    if cgs.gametype != GT_CTF && cgs.gametype != GT_CTY {
        return
    }

    team = cg.snap!.ps.persistant[PERS_TEAM]

    if cgs.gametype == GT_CTY {
        if team == TEAM_RED {
            myFlagTakenShader = trap_R_RegisterShaderNoMip("gfx/hud/mpi_rflag_x")
            theirFlagShader = trap_R_RegisterShaderNoMip("gfx/hud/mpi_bflag_ys")
        } else {
            myFlagTakenShader = trap_R_RegisterShaderNoMip("gfx/hud/mpi_bflag_x")
            theirFlagShader = trap_R_RegisterShaderNoMip("gfx/hud/mpi_rflag_ys")
        }
    } else {
        if team == TEAM_RED {
            myFlagTakenShader = trap_R_RegisterShaderNoMip("gfx/hud/mpi_rflag_x")
            theirFlagShader = trap_R_RegisterShaderNoMip("gfx/hud/mpi_bflag")
        } else {
            myFlagTakenShader = trap_R_RegisterShaderNoMip("gfx/hud/mpi_bflag_x")
            theirFlagShader = trap_R_RegisterShaderNoMip("gfx/hud/mpi_rflag")
        }
    }

    if CG_YourTeamHasFlag() {
        //CG_DrawPic( startDrawPos, 330, ico_size, ico_size, theirFlagShader );
        CG_DrawPic(2, Float(330 - startDrawPos), Float(ico_size), Float(ico_size), theirFlagShader)
        startDrawPos += ico_size + 2
    }

    if CG_OtherTeamHasFlag() {
        //CG_DrawPic( startDrawPos, 330, ico_size, ico_size, myFlagTakenShader );
        CG_DrawPic(2, Float(330 - startDrawPos), Float(ico_size), Float(ico_size), myFlagTakenShader)
    }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7150
func CG_DrawJetpackFuel() {
    var aColor = vec4_t()
    var bColor = vec4_t()
    var cColor = vec4_t()
    let x: Float = JPFUELBAR_X
    let y: Float = JPFUELBAR_Y
    var percent: Float = (Float(cg.snap!.ps.jetpackFuel) / 100.0) * JPFUELBAR_H

    if percent > JPFUELBAR_H {
        return
    }

    if percent < 0.1 {
        percent = 0.1
    }

    //color of the bar
    aColor[0] = 0.5
    aColor[1] = 0.0
    aColor[2] = 0.0
    aColor[3] = 0.8

    //color of the border
    bColor[0] = 0.0
    bColor[1] = 0.0
    bColor[2] = 0.0
    bColor[3] = 0.3

    //color of greyed out "missing fuel"
    cColor[0] = 0.5
    cColor[1] = 0.5
    cColor[2] = 0.5
    cColor[3] = 0.1

    //draw the background (black)
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
    // Raven wrote: CG_DrawRect(x, y, JPFUELBAR_W, JPFUELBAR_H, 1.0f, colorTable[CT_BLACK])
    portMissing("CG_DrawJetpackFuel", source: "oracle/codemp/cgame/cg_draw.c:7150")

    //now draw the part to show how much health there is in the color specified
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
    // Raven wrote: CG_FillRect(x+1.0f, y+1.0f+(JPFUELBAR_H-percent), JPFUELBAR_W-1.0f, JPFUELBAR_H-1.0f-(JPFUELBAR_H-percent), aColor)
    portMissing("CG_DrawJetpackFuel", source: "oracle/codemp/cgame/cg_draw.c:7150")

    //then draw the other part greyed out
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
    // Raven wrote: CG_FillRect(x+1.0f, y+1.0f, JPFUELBAR_W-1.0f, JPFUELBAR_H-percent, cColor)
    portMissing("CG_DrawJetpackFuel", source: "oracle/codemp/cgame/cg_draw.c:7150")
}

/// Source: oracle/codemp/cgame/cg_draw.c:7202
func CG_DrawEWebHealth() {
    var aColor = vec4_t()
    var bColor = vec4_t()
    var cColor = vec4_t()
    var x: Float = EWEBHEALTH_X
    let y: Float = EWEBHEALTH_Y
    let eweb: Centity? = cg_entities[cg.predictedPlayerState.emplacedIndex]
    var percent: Float = (Float(eweb!.currentState.health) / eweb!.currentState.maxhealth) * EWEBHEALTH_H

    if percent > EWEBHEALTH_H {
        return
    }

    if percent < 0.1 {
        percent = 0.1
    }

    //kind of hacky, need to pass a coordinate in here
    if cg.snap!.ps.jetpackFuel < 100 {
        x -= (JPFUELBAR_W + 8.0)
    }
    if cg.snap!.ps.cloakFuel < 100 {
        x -= (JPFUELBAR_W + 8.0)
    }

    //color of the bar
    aColor[0] = 0.5
    aColor[1] = 0.0
    aColor[2] = 0.0
    aColor[3] = 0.8

    //color of the border
    bColor[0] = 0.0
    bColor[1] = 0.0
    bColor[2] = 0.0
    bColor[3] = 0.3

    //color of greyed out "missing fuel"
    cColor[0] = 0.5
    cColor[1] = 0.5
    cColor[2] = 0.5
    cColor[3] = 0.1

    //draw the background (black)
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
    // Raven wrote: CG_DrawRect(x, y, EWEBHEALTH_W, EWEBHEALTH_H, 1.0f, colorTable[CT_BLACK])
    portMissing("CG_DrawEWebHealth", source: "oracle/codemp/cgame/cg_draw.c:7202")

    //now draw the part to show how much health there is in the color specified
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
    // Raven wrote: CG_FillRect(x+1.0f, y+1.0f+(EWEBHEALTH_H-percent), EWEBHEALTH_W-1.0f, EWEBHEALTH_H-1.0f-(EWEBHEALTH_H-percent), aColor)
    portMissing("CG_DrawEWebHealth", source: "oracle/codemp/cgame/cg_draw.c:7202")

    //then draw the other part greyed out
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
    // Raven wrote: CG_FillRect(x+1.0f, y+1.0f, EWEBHEALTH_W-1.0f, EWEBHEALTH_H-percent, cColor)
    portMissing("CG_DrawEWebHealth", source: "oracle/codemp/cgame/cg_draw.c:7202")
}

/// Source: oracle/codemp/cgame/cg_draw.c:7265
func CG_DrawCloakFuel() {
    var aColor = vec4_t()
    var bColor = vec4_t()
    var cColor = vec4_t()
    var x: Float = CLFUELBAR_X
    let y: Float = CLFUELBAR_Y
    var percent: Float = (Float(cg.snap!.ps.cloakFuel) / 100.0) * CLFUELBAR_H

    if percent > CLFUELBAR_H {
        return
    }

    if cg.snap!.ps.jetpackFuel < 100 {
        //if drawing jetpack fuel bar too, then move this over...?
        x -= (JPFUELBAR_W + 8.0)
    }

    if percent < 0.1 {
        percent = 0.1
    }

    //color of the bar
    aColor[0] = 0.0
    aColor[1] = 0.0
    aColor[2] = 0.6
    aColor[3] = 0.8

    //color of the border
    bColor[0] = 0.0
    bColor[1] = 0.0
    bColor[2] = 0.0
    bColor[3] = 0.3

    //color of greyed out "missing fuel"
    cColor[0] = 0.1
    cColor[1] = 0.1
    cColor[2] = 0.3
    cColor[3] = 0.1

    //draw the background (black)
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
    // Raven wrote: CG_DrawRect(x, y, CLFUELBAR_W, CLFUELBAR_H, 1.0f, colorTable[CT_BLACK])
    portMissing("CG_DrawCloakFuel", source: "oracle/codemp/cgame/cg_draw.c:7265")

    //now draw the part to show how much fuel there is in the color specified
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
    // Raven wrote: CG_FillRect(x+1.0f, y+1.0f+(CLFUELBAR_H-percent), CLFUELBAR_W-1.0f, CLFUELBAR_H-1.0f-(CLFUELBAR_H-percent), aColor)
    portMissing("CG_DrawCloakFuel", source: "oracle/codemp/cgame/cg_draw.c:7265")

    //then draw the other part greyed out
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
    // Raven wrote: CG_FillRect(x+1.0f, y+1.0f, CLFUELBAR_W-1.0f, CLFUELBAR_H-percent, cColor)
    portMissing("CG_DrawCloakFuel", source: "oracle/codemp/cgame/cg_draw.c:7265")
}

/// Source: oracle/codemp/cgame/cg_draw.c:7356
private func CG_DrawSiegeTimer(_ timeRemaining: Int32, _ isMyTeam: Bool) {
    //rwwFIXMEFIXME: Make someone make assets and use them.
    //this function is pretty much totally placeholder.
    //	int x = 0;
    //	int y = SCREEN_HEIGHT-160;
    var fColor: Int32 = 0
    var minutes: Int32 = 0
    var seconds: Int32 = 0
    var timeStr = CharBuf(1024)
    var menuHUD: MenuDef? = nil
    var item: ItemDef? = nil

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menus_FindByName' in scope".
    // Raven wrote: menuHUD = Menus_FindByName("mp_timer")
    portMissing("CG_DrawSiegeTimer", source: "oracle/codemp/cgame/cg_draw.c:7356")
    if menuHUD == nil {
        return
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
    // Raven wrote: item = Menu_FindItemByName(menuHUD, "frame")
    portMissing("CG_DrawSiegeTimer", source: "oracle/codemp/cgame/cg_draw.c:7356")

    if item != nil {
        trap_R_SetColor(vec4_t(item!.window.foreColor[0], item!.window.foreColor[1], item!.window.foreColor[2], item!.window.foreColor[3]))
        CG_DrawPic(item!.window.rect.x, item!.window.rect.y, item!.window.rect.w, item!.window.rect.h, item!.window.background)
    }

    seconds = timeRemaining

    while seconds >= 60 {
        minutes += 1
        seconds -= 60
    }

    strcpy(&timeStr, va("%i:%02i", minutes, seconds))

    if isMyTeam {
        fColor = CT_HUD_RED
    } else {
        fColor = CT_HUD_GREEN
    }

    //	trap_Cvar_Set("ui_siegeTimer", timeStr);

    //	UI_DrawProportionalString( x+16, y+40, timeStr,
    //		UI_SMALLFONT|UI_DROPSHADOW, colorTable[fColor] );

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
    // Raven wrote: item = Menu_FindItemByName(menuHUD, "timer")
    portMissing("CG_DrawSiegeTimer", source: "oracle/codemp/cgame/cg_draw.c:7356")
    if item != nil {
        UI_DrawProportionalString(Int32(item!.window.rect.x), Int32(item!.window.rect.y), String(timeStr), UI_SMALLFONT | UI_DROPSHADOW, colorTable[fColor])
    }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7424
private func CG_DrawSiegeDeathTimer(_ timeRemaining: Int32) {
    var minutes: Int32 = 0
    var seconds: Int32 = 0
    var timeStr = CharBuf(1024)
    var menuHUD: MenuDef? = nil
    var item: ItemDef? = nil

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menus_FindByName' in scope".
    // Raven wrote: menuHUD = Menus_FindByName("mp_timer")
    portMissing("CG_DrawSiegeDeathTimer", source: "oracle/codemp/cgame/cg_draw.c:7424")
    if menuHUD == nil {
        return
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
    // Raven wrote: item = Menu_FindItemByName(menuHUD, "frame")
    portMissing("CG_DrawSiegeDeathTimer", source: "oracle/codemp/cgame/cg_draw.c:7424")

    if item != nil {
        trap_R_SetColor(vec4_t(item!.window.foreColor[0], item!.window.foreColor[1], item!.window.foreColor[2], item!.window.foreColor[3]))
        CG_DrawPic(item!.window.rect.x, item!.window.rect.y, item!.window.rect.w, item!.window.rect.h, item!.window.background)
    }

    seconds = timeRemaining

    while seconds >= 60 {
        minutes += 1
        seconds -= 60
    }

    if seconds < 10 {
        strcpy(&timeStr, va("%i:0%i", minutes, seconds))
    } else {
        strcpy(&timeStr, va("%i:%i", minutes, seconds))
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_FindItemByName' in scope".
    // Raven wrote: item = Menu_FindItemByName(menuHUD, "deathtimer")
    portMissing("CG_DrawSiegeDeathTimer", source: "oracle/codemp/cgame/cg_draw.c:7424")
    if item != nil {
        UI_DrawProportionalString(Int32(item!.window.rect.x), Int32(item!.window.rect.y), String(timeStr), UI_SMALLFONT | UI_DROPSHADOW, vec4_t(item!.window.foreColor[0], item!.window.foreColor[1], item!.window.foreColor[2], item!.window.foreColor[3]))
    }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7483
private func CG_DrawSiegeHUDItem() {
    var g2: OpaquePointer? = nil
    let handle: qhandle_t
    var origin = vec3_t()
    var angles = vec3_t()
    var mins = vec3_t()
    var maxs = vec3_t()
    let len: Float
    let cent: Centity? = cg_entities[cgSiegeEntityRender]

    if cent!.ghoul2 != nil {
        g2 = cent!.ghoul2
        handle = 0
    } else {
        handle = cgs.gameModels[cent!.currentState.modelindex]
        g2 = nil
    }

    if handle != 0 {
        trap_R_ModelBounds(handle, &mins, &maxs)
    } else {
        mins = vec3_t(-16, -16, -20)
        maxs = vec3_t(16, 16, 32)
    }

    origin[2] = Float(-0.5 * Double(mins[2] + maxs[2]))
    origin[1] = Float(0.5 * Double(mins[1] + maxs[1]))
    len = Float(0.5 * Double(maxs[2] - mins[2]))
    origin[0] = Float(Double(len) / 0.268)

    angles = vec3_t()
    angles[YAW] = cg.autoAngles[YAW]

    CG_Draw3DModel(8, 8, 64, 64, handle, g2, cent!.currentState.g2radius, 0, origin, angles)

    cgSiegeEntityRender = 0 //reset for next frame
}

//utility func, insert a string into a string at the specified
//place (assuming this will not overflow the buffer)
/// Source: oracle/codemp/cgame/cg_draw.c:7534
func CG_ChatBox_StrInsert(_ buffer: inout JKAShared.CharBuf, _ place: Int32, _ str: String) {
    let str = CharBuf(str)
    let insLen: Int32 = strlen(str)
    var i: Int32 = strlen(buffer)
    var k: Int32 = 0
    var bufferIndex: Int32 = 0

    buffer[bufferIndex + i + insLen + 1] = 0 //terminate the string at its new length
    while i >= place {
        buffer[bufferIndex + i + insLen] = buffer[bufferIndex + i]
        i -= 1
    }

    i += 1
    while k < insLen {
        // Raven wrote: buffer[i] = str[k]
        buffer[bufferIndex + i] = str[k]
        i += 1
        k += 1
    }
}

//add chatbox string
/// Source: oracle/codemp/cgame/cg_draw.c:7557
func CG_ChatBox_AddString(_ chatStr: inout JKAShared.CharBuf) {
    let chat: ChatBoxItem? = cg.chatItems[cg.chatItemActive]
    var chatLen: Float
    var chatStrIndex: Int32 = 0

    if cg_chatBox.integer <= 0 {
        //don't bother then.
        return
    }

    // Raven wrote: memset(chat, 0, sizeof(chatBoxItem_t))
    chat!.clear()

    if strlen(chatStr) > 150 {
        //too long, terminate at proper len.
        chatStr[chatStrIndex + 150 - 1] = 0
    }

    strcpy(&chat!.stringBuffer, chatStr)
    chat!.time = cg.time + cg_chatBox.integer

    chat!.lines = 1

    chatLen = Float(CG_Text_Width(chat!.string, 1.0, FONT_SMALL))
    if chatLen > CHATBOX_CUTOFF_LEN {
        //we have to break it into segments...
        var i: Int32 = 0
        var lastLinePt: Int32 = 0
        var s = CharBuf(2)

        chatLen = 0
        // Raven wrote: while (chat->string[i]) { s[0] = chat->string[i]; s[1] = 0; chatLen += CG_Text_Width(s, 0.65f, FONT_SMALL); if (chatLen >= CHATBOX_CUTOFF_LEN) { int j = i; while (j > 0 && j > lastLinePt) { if (chat->string[j] == ' ') { break; } j--; } if (chat->string[j] == ' ') { i = j; } chat->lines++; CG_ChatBox_StrInsert(chat->string, i, "\n"); i++; chatLen = 0; lastLinePt = i+1; } i++; }
        while chat!.stringBuffer[i] != 0 {
            s[0] = chat!.stringBuffer[i]
            s[1] = 0
            chatLen += CG_Text_Width(String(s), 0.65, FONT_SMALL)

            if chatLen >= CHATBOX_CUTOFF_LEN {
                var j: Int32 = i
                while j > 0 && j > lastLinePt {
                    if chat!.stringBuffer[j] == Int32(ascii: " ") {
                        break
                    }
                    j -= 1
                }
                if chat!.stringBuffer[j] == Int32(ascii: " ") {
                    i = j
                }

                chat!.lines += 1
                CG_ChatBox_StrInsert(&chat!.stringBuffer, i, "\n")
                i += 1
                chatLen = 0
                lastLinePt = i + 1
            }
            i += 1
        }
    }

    cg.chatItemActive += 1
    if cg.chatItemActive >= MAX_CHATBOX_ITEMS {
        cg.chatItemActive = 0
    }
}

//insert item into array (rearranging the array if necessary)
/// Source: oracle/codemp/cgame/cg_draw.c:7627
func CG_ChatBox_ArrayInsert(_ array: inout ChatBoxItem?, _ insPoint: Int32, _ maxNum: Int32, _ item: ChatBoxItem) {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "value of type 'ChatBoxItem?' has no subscripts".
    // Raven wrote: if (array[insPoint]) { //recursively call, to move everything up to the top if (insPoint+1 >= maxNum) { CG_Error("CG_ChatBox_ArrayInsert: Exceeded array size"); } CG_ChatBox_ArrayInsert(array, insPoint+1, maxNum, array[insPoint]); }
    portMissing("CG_ChatBox_ArrayInsert", source: "oracle/codemp/cgame/cg_draw.c:7627")

    //now that we have moved anything that would be in this slot up, insert what we want into the slot
    // Port-note: The draft of this statement did not compile, and the compiler wrote "value of type 'ChatBoxItem?' has no subscripts".
    // Raven wrote: array[insPoint] = item
    portMissing("CG_ChatBox_ArrayInsert", source: "oracle/codemp/cgame/cg_draw.c:7627")
}

//go through all the chat strings and draw them if they are not yet expired
/// Source: oracle/codemp/cgame/cg_draw.c:7643
private func CG_ChatBox_DrawStrings() {
    // Raven wrote: chatBoxItem_t *drawThese[MAX_CHATBOX_ITEMS];
    var drawThese = [ChatBoxItem?](repeating: nil, count: Int(MAX_CHATBOX_ITEMS))
    var numToDraw: Int32 = 0
    var linesToDraw: Int32 = 0
    var i: Int32 = 0
    let x: Int32 = 30
    var y: Int32 = cg.scoreBoardShowing ? 475 : cg_chatBoxHeight.integer
    let fontScale: Float = 0.65

    if cg_chatBox.integer == 0 {
        return
    }

    // Raven wrote: memset(drawThese, 0, sizeof(drawThese))
    drawThese.fill(nil)

    while i < MAX_CHATBOX_ITEMS {
        if cg.chatItems[i].time >= cg.time {
            var check: Int32 = numToDraw
            var insertionPoint: Int32 = numToDraw

            while check >= 0 {
                // Raven wrote: if (drawThese[check] && cg.chatItems[i].time < drawThese[check]->time) { //insert here insertionPoint = check; }
                if drawThese[check] != nil && cg.chatItems[i].time < drawThese[check]!.time {
                    //insert here
                    insertionPoint = check
                }
                check -= 1
            }
            // Port-note: A read of `drawThese`, a local the draft left as a hole.
            // Raven wrote: CG_ChatBox_ArrayInsert(drawThese, insertionPoint, MAX_CHATBOX_ITEMS, &cg.chatItems[i])
            portMissing("CG_ChatBox_DrawStrings", source: "oracle/codemp/cgame/cg_draw.c:7643")
            numToDraw += 1
            linesToDraw += cg.chatItems[i].lines
        }
        i += 1
    }

    if numToDraw == 0 {
        //nothing, then, just get out of here now.
        return
    }

    //move initial point up so we draw bottom-up (visually)
    y = Int32(Float(y) - (CHATBOX_FONT_HEIGHT * fontScale) * linesToDraw)

    //we have the items we want to draw, just quickly loop through them now
    i = 0
    while i < numToDraw {
        // Raven wrote: CG_Text_Paint(x, y, fontScale, colorWhite, drawThese[i]->string, 0, 0, ITEM_TEXTSTYLE_OUTLINED, FONT_SMALL )
        CG_Text_Paint(Float(x), Float(y), fontScale, colorWhite, drawThese[i]!.string, 0, 0, ITEM_TEXTSTYLE_OUTLINED, FONT_SMALL)
        // Raven wrote: y += ((CHATBOX_FONT_HEIGHT*fontScale)*drawThese[i]->lines)
        y = Int32(y + ((CHATBOX_FONT_HEIGHT * fontScale) * drawThese[i]!.lines))
        i += 1
    }
}

/// Source: oracle/codemp/cgame/cg_draw.c:7701
private func CG_Draw2DScreenTints() {
    var rageTime: Float
    var rageRecTime: Float
    var absorbTime: Float
    var protectTime: Float
    var ysalTime: Float
    var hcolor = vec4_t()
    if cgs.clientinfo[cg.snap!.ps.clientNum].team != TEAM_SPECTATOR {
        if (cg.snap!.ps.fd.forcePowersActive & (1 << FP_RAGE)) != 0 {
            if cgRageTime == 0 {
                cgRageTime = cg.time
            }

            rageTime = Float((cg.time - cgRageTime))

            rageTime /= 9000

            if rageTime < 0 {
                rageTime = 0
            }
            if Double(rageTime) > 0.15 {
                rageTime = 0.15
            }

            hcolor[3] = rageTime
            hcolor[0] = 0.7
            hcolor[1] = 0
            hcolor[2] = 0

            if !cg.renderingThirdPerson {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
                // Raven wrote: CG_DrawRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_WIDTH*SCREEN_HEIGHT, hcolor)
                portMissing("CG_Draw2DScreenTints", source: "oracle/codemp/cgame/cg_draw.c:7701")
            }

            cgRageFadeTime = 0
            cgRageFadeVal = 0
        } else if cgRageTime != 0 {
            if cgRageFadeTime == 0 {
                cgRageFadeTime = cg.time
                cgRageFadeVal = 0.15
            }

            rageTime = cgRageFadeVal

            cgRageFadeVal = Float(Double(cgRageFadeVal) - Double(cg.time - cgRageFadeTime) * 0.000005)

            if rageTime < 0 {
                rageTime = 0
            }
            if Double(rageTime) > 0.15 {
                rageTime = 0.15
            }

            if cg.snap!.ps.fd.forceRageRecoveryTime > cg.time {
                var checkRageRecTime: Float = rageTime

                if Double(checkRageRecTime) < 0.15 {
                    checkRageRecTime = 0.15
                }

                hcolor[3] = checkRageRecTime
                hcolor[0] = rageTime * 4
                if Double(hcolor[0]) < 0.2 {
                    hcolor[0] = 0.2
                }
                hcolor[1] = 0.2
                hcolor[2] = 0.2
            } else {
                hcolor[3] = rageTime
                hcolor[0] = 0.7
                hcolor[1] = 0
                hcolor[2] = 0
            }

            if !cg.renderingThirdPerson && rageTime != 0 {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
                // Raven wrote: CG_DrawRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_WIDTH*SCREEN_HEIGHT, hcolor)
                portMissing("CG_Draw2DScreenTints", source: "oracle/codemp/cgame/cg_draw.c:7701")
            } else {
                if cg.snap!.ps.fd.forceRageRecoveryTime > cg.time {
                    hcolor[3] = 0.15
                    hcolor[0] = 0.2
                    hcolor[1] = 0.2
                    hcolor[2] = 0.2
                    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
                    // Raven wrote: CG_DrawRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_WIDTH*SCREEN_HEIGHT, hcolor)
                    portMissing("CG_Draw2DScreenTints", source: "oracle/codemp/cgame/cg_draw.c:7701")
                }
                cgRageTime = 0
            }
        } else if cg.snap!.ps.fd.forceRageRecoveryTime > cg.time {
            if cgRageRecTime == 0 {
                cgRageRecTime = cg.time
            }

            rageRecTime = Float((cg.time - cgRageRecTime))

            rageRecTime /= 9000

            if Double(rageRecTime) < 0.15 {
                rageRecTime = 0.15 //0;
            }
            if Double(rageRecTime) > 0.15 {
                rageRecTime = 0.15
            }

            hcolor[3] = rageRecTime
            hcolor[0] = 0.2
            hcolor[1] = 0.2
            hcolor[2] = 0.2

            if !cg.renderingThirdPerson {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
                // Raven wrote: CG_DrawRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_WIDTH*SCREEN_HEIGHT, hcolor)
                portMissing("CG_Draw2DScreenTints", source: "oracle/codemp/cgame/cg_draw.c:7701")
            }

            cgRageRecFadeTime = 0
            cgRageRecFadeVal = 0
        } else if cgRageRecTime != 0 {
            if cgRageRecFadeTime == 0 {
                cgRageRecFadeTime = cg.time
                cgRageRecFadeVal = 0.15
            }

            rageRecTime = cgRageRecFadeVal

            cgRageRecFadeVal = Float(Double(cgRageRecFadeVal) - Double(cg.time - cgRageRecFadeTime) * 0.000005)

            if rageRecTime < 0 {
                rageRecTime = 0
            }
            if Double(rageRecTime) > 0.15 {
                rageRecTime = 0.15
            }

            hcolor[3] = rageRecTime
            hcolor[0] = 0.2
            hcolor[1] = 0.2
            hcolor[2] = 0.2

            if !cg.renderingThirdPerson && rageRecTime != 0 {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
                // Raven wrote: CG_DrawRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_WIDTH*SCREEN_HEIGHT, hcolor)
                portMissing("CG_Draw2DScreenTints", source: "oracle/codemp/cgame/cg_draw.c:7701")
            } else {
                cgRageRecTime = 0
            }
        }

        if (cg.snap!.ps.fd.forcePowersActive & (1 << FP_ABSORB)) != 0 {
            if cgAbsorbTime == 0 {
                cgAbsorbTime = cg.time
            }

            absorbTime = Float((cg.time - cgAbsorbTime))

            absorbTime /= 9000

            if absorbTime < 0 {
                absorbTime = 0
            }
            if Double(absorbTime) > 0.15 {
                absorbTime = 0.15
            }

            hcolor[3] = absorbTime / 2
            hcolor[0] = 0
            hcolor[1] = 0
            hcolor[2] = 0.7

            if !cg.renderingThirdPerson {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
                // Raven wrote: CG_DrawRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_WIDTH*SCREEN_HEIGHT, hcolor)
                portMissing("CG_Draw2DScreenTints", source: "oracle/codemp/cgame/cg_draw.c:7701")
            }

            cgAbsorbFadeTime = 0
            cgAbsorbFadeVal = 0
        } else if cgAbsorbTime != 0 {
            if cgAbsorbFadeTime == 0 {
                cgAbsorbFadeTime = cg.time
                cgAbsorbFadeVal = 0.15
            }

            absorbTime = cgAbsorbFadeVal

            cgAbsorbFadeVal = Float(Double(cgAbsorbFadeVal) - Double(cg.time - cgAbsorbFadeTime) * 0.000005)

            if absorbTime < 0 {
                absorbTime = 0
            }
            if Double(absorbTime) > 0.15 {
                absorbTime = 0.15
            }

            hcolor[3] = absorbTime / 2
            hcolor[0] = 0
            hcolor[1] = 0
            hcolor[2] = 0.7

            if !cg.renderingThirdPerson && absorbTime != 0 {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
                // Raven wrote: CG_DrawRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_WIDTH*SCREEN_HEIGHT, hcolor)
                portMissing("CG_Draw2DScreenTints", source: "oracle/codemp/cgame/cg_draw.c:7701")
            } else {
                cgAbsorbTime = 0
            }
        }

        if (cg.snap!.ps.fd.forcePowersActive & (1 << FP_PROTECT)) != 0 {
            if cgProtectTime == 0 {
                cgProtectTime = cg.time
            }

            protectTime = Float((cg.time - cgProtectTime))

            protectTime /= 9000

            if protectTime < 0 {
                protectTime = 0
            }
            if Double(protectTime) > 0.15 {
                protectTime = 0.15
            }

            hcolor[3] = protectTime / 2
            hcolor[0] = 0
            hcolor[1] = 0.7
            hcolor[2] = 0

            if !cg.renderingThirdPerson {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
                // Raven wrote: CG_DrawRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_WIDTH*SCREEN_HEIGHT, hcolor)
                portMissing("CG_Draw2DScreenTints", source: "oracle/codemp/cgame/cg_draw.c:7701")
            }

            cgProtectFadeTime = 0
            cgProtectFadeVal = 0
        } else if cgProtectTime != 0 {
            if cgProtectFadeTime == 0 {
                cgProtectFadeTime = cg.time
                cgProtectFadeVal = 0.15
            }

            protectTime = cgProtectFadeVal

            cgProtectFadeVal = Float(Double(cgProtectFadeVal) - Double(cg.time - cgProtectFadeTime) * 0.000005)

            if protectTime < 0 {
                protectTime = 0
            }
            if Double(protectTime) > 0.15 {
                protectTime = 0.15
            }

            hcolor[3] = protectTime / 2
            hcolor[0] = 0
            hcolor[1] = 0.7
            hcolor[2] = 0

            if !cg.renderingThirdPerson && protectTime != 0 {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
                // Raven wrote: CG_DrawRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_WIDTH*SCREEN_HEIGHT, hcolor)
                portMissing("CG_Draw2DScreenTints", source: "oracle/codemp/cgame/cg_draw.c:7701")
            } else {
                cgProtectTime = 0
            }
        }

        if cg.snap!.ps.rocketLockIndex != ENTITYNUM_NONE && (cg.time - cg.snap!.ps.rocketLockTime) > 0 {
            CG_DrawRocketLocking(cg.snap!.ps.rocketLockIndex, Int32(cg.snap!.ps.rocketLockTime))
        }

        if BG_HasYsalamiri(cgs.gametype, cg.snap!.ps) {
            if cgYsalTime == 0 {
                cgYsalTime = cg.time
            }

            ysalTime = Float((cg.time - cgYsalTime))

            ysalTime /= 9000

            if ysalTime < 0 {
                ysalTime = 0
            }
            if Double(ysalTime) > 0.15 {
                ysalTime = 0.15
            }

            hcolor[3] = ysalTime / 2
            hcolor[0] = 0.7
            hcolor[1] = 0.7
            hcolor[2] = 0

            if !cg.renderingThirdPerson {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
                // Raven wrote: CG_DrawRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_WIDTH*SCREEN_HEIGHT, hcolor)
                portMissing("CG_Draw2DScreenTints", source: "oracle/codemp/cgame/cg_draw.c:7701")
            }

            cgYsalFadeTime = 0
            cgYsalFadeVal = 0
        } else if cgYsalTime != 0 {
            if cgYsalFadeTime == 0 {
                cgYsalFadeTime = cg.time
                cgYsalFadeVal = 0.15
            }

            ysalTime = cgYsalFadeVal

            cgYsalFadeVal = Float(Double(cgYsalFadeVal) - Double(cg.time - cgYsalFadeTime) * 0.000005)

            if ysalTime < 0 {
                ysalTime = 0
            }
            if Double(ysalTime) > 0.15 {
                ysalTime = 0.15
            }

            hcolor[3] = ysalTime / 2
            hcolor[0] = 0.7
            hcolor[1] = 0.7
            hcolor[2] = 0

            if !cg.renderingThirdPerson && ysalTime != 0 {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
                // Raven wrote: CG_DrawRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_WIDTH*SCREEN_HEIGHT, hcolor)
                portMissing("CG_Draw2DScreenTints", source: "oracle/codemp/cgame/cg_draw.c:7701")
            } else {
                cgYsalTime = 0
            }
        }
    }

    if (cg.refdef.viewContents & CONTENTS_LAVA) != 0 {
        //tint screen red
        let phase: Float = Float(Double(cg.time) / 1000.0 * WAVE_FREQUENCY * M_PI * 2)
        hcolor[3] = Float(0.5 + (0.15 * sin(Double(phase))))
        hcolor[0] = 0.7
        hcolor[1] = 0
        hcolor[2] = 0

        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
        // Raven wrote: CG_DrawRect( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_WIDTH*SCREEN_HEIGHT, hcolor )
        portMissing("CG_Draw2DScreenTints", source: "oracle/codemp/cgame/cg_draw.c:7701")
    } else if (cg.refdef.viewContents & CONTENTS_SLIME) != 0 {
        //tint screen green
        let phase: Float = Float(Double(cg.time) / 1000.0 * WAVE_FREQUENCY * M_PI * 2)
        hcolor[3] = Float(0.4 + (0.1 * sin(Double(phase))))
        hcolor[0] = 0
        hcolor[1] = 0.7
        hcolor[2] = 0

        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
        // Raven wrote: CG_DrawRect( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_WIDTH*SCREEN_HEIGHT, hcolor )
        portMissing("CG_Draw2DScreenTints", source: "oracle/codemp/cgame/cg_draw.c:7701")
    } else if (cg.refdef.viewContents & CONTENTS_WATER) != 0 {
        //tint screen light blue -- FIXME: don't do this if CONTENTS_FOG? (in case someone *does* make a water shader with fog in it?)
        let phase: Float = Float(Double(cg.time) / 1000.0 * WAVE_FREQUENCY * M_PI * 2)
        hcolor[3] = Float(0.3 + (0.05 * sin(Double(phase))))
        hcolor[0] = 0
        hcolor[1] = 0.2
        hcolor[2] = 0.8

        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
        // Raven wrote: CG_DrawRect( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_WIDTH*SCREEN_HEIGHT, hcolor )
        portMissing("CG_Draw2DScreenTints", source: "oracle/codemp/cgame/cg_draw.c:7701")
    }
}

/// Source: oracle/codemp/cgame/cg_draw.c:8118
private func CG_Draw2D() {
    let inTime: Float = cg.invenSelectTime + WEAPON_SELECT_TIME
    let wpTime: Float = Float(cg.weaponSelectTime + WEAPON_SELECT_TIME)
    var fallTime: Float
    let bestTime: Float
    var drawSelect: Int32 = 0

    // if we are taking a levelshot for the menu, don't draw anything
    if cg.levelShot {
        return
    }

    if cgs.clientinfo[cg.snap!.ps.clientNum].team == TEAM_SPECTATOR {
        cgRageTime = 0
        cgRageFadeTime = 0
        cgRageFadeVal = 0

        cgRageRecTime = 0
        cgRageRecFadeTime = 0
        cgRageRecFadeVal = 0

        cgAbsorbTime = 0
        cgAbsorbFadeTime = 0
        cgAbsorbFadeVal = 0

        cgProtectTime = 0
        cgProtectFadeTime = 0
        cgProtectFadeVal = 0

        cgYsalTime = 0
        cgYsalFadeTime = 0
        cgYsalFadeVal = 0
    }

    if cg_draw2D.integer == 0 {
        return
    }

    if cg.snap!.ps.pm_type == PM_INTERMISSION {
        CG_DrawIntermission()
        CG_ChatBox_DrawStrings()
        return
    }

    CG_Draw2DScreenTints()

    if cg.snap!.ps.rocketLockIndex != ENTITYNUM_NONE && (cg.time - cg.snap!.ps.rocketLockTime) > 0 {
        CG_DrawRocketLocking(cg.snap!.ps.rocketLockIndex, Int32(cg.snap!.ps.rocketLockTime))
    }

    if cg.snap!.ps.holocronBits != 0 {
        CG_DrawHolocronIcons()
    }
    if cg.snap!.ps.fd.forcePowersActive != 0 || cg.snap!.ps.fd.forceRageRecoveryTime > cg.time {
        CG_DrawActivePowers()
    }

    if cg.snap!.ps.jetpackFuel < 100 {
        //draw it as long as it isn't full
        CG_DrawJetpackFuel()
    }
    if cg.snap!.ps.cloakFuel < 100 {
        //draw it as long as it isn't full
        CG_DrawCloakFuel()
    }
    if cg.predictedPlayerState.emplacedIndex > 0 {
        let eweb: Centity? = cg_entities[cg.predictedPlayerState.emplacedIndex]

        if eweb!.currentState.weapon == WP_NONE {
            //using an e-web, draw its health
            CG_DrawEWebHealth()
        }
    }

    // Draw this before the text so that any text won't get clipped off
    CG_DrawZoomMask()

    /*
    if (cg.cameraMode) {
    return;
    }
    */
    if cg.snap!.ps.persistant[PERS_TEAM] == TEAM_SPECTATOR {
        CG_DrawSpectator()
        CG_DrawCrosshair(nil, 0)
        CG_DrawCrosshairNames()
        CG_SaberClashFlare()
    } else {
        // don't draw any status if dead or the scoreboard is being explicitly shown
        if !cg.showScores && cg.snap!.ps.stats[STAT_HEALTH] > 0 {
            if 0 != 0 {
                //Reenable if stats are drawn with menu system again
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'Menu_PaintAll' in scope".
                // Raven wrote: Menu_PaintAll()
                portMissing("CG_Draw2D", source: "oracle/codemp/cgame/cg_draw.c:8118")
                CG_DrawTimedMenus()
            }

            //CG_DrawTemporaryStats();

            CG_DrawAmmoWarning()

            CG_DrawCrosshairNames()

            if cg_drawStatus.integer != 0 {
                CG_DrawIconBackground()
            }

            if inTime > wpTime {
                drawSelect = 1
                bestTime = cg.invenSelectTime
            } else {
                drawSelect = 2
                bestTime = Float(cg.weaponSelectTime)
            }

            if cg.forceSelectTime > bestTime {
                drawSelect = 3
            }

            switch drawSelect {
            case 1:
                CG_DrawInvenSelect()

            case 2:
                CG_DrawWeaponSelect()

            case 3:
                CG_DrawForceSelect()

            default:
                break
            }

            if cg_drawStatus.integer != 0 {
                //Powerups now done with upperright stuff
                //CG_DrawPowerupIcons();

                CG_DrawFlagStatus()
            }

            CG_SaberClashFlare()

            if cg_drawStatus.integer != 0 {
                CG_DrawStats()
            }

            CG_DrawPickupItem()
            //Do we want to use this system again at some point?
            //CG_DrawReward();
        }
    }

    if cg.snap!.ps.fallingToDeath != 0 {
        var hcolor = vec4_t()

        fallTime = Float((cg.time - cg.snap!.ps.fallingToDeath))

        // Port-note: The draft of this statement did not compile, and the compiler wrote "ambiguous use of operator '/'".
        // Raven wrote: fallTime /= (FALL_FADE_TIME/2)
        portMissing("CG_Draw2D", source: "oracle/codemp/cgame/cg_draw.c:8118")

        if fallTime < 0 {
            fallTime = 0
        }
        if fallTime > 1 {
            fallTime = 1
        }

        hcolor[3] = fallTime
        hcolor[0] = 0
        hcolor[1] = 0
        hcolor[2] = 0

        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'Float'".
        // Raven wrote: CG_DrawRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_WIDTH*SCREEN_HEIGHT, hcolor)
        portMissing("CG_Draw2D", source: "oracle/codemp/cgame/cg_draw.c:8118")

        if !gCGHasFallVector {
            gCGFallVector = cg.snap!.ps.origin
            gCGHasFallVector = true
        }
    } else {
        if gCGHasFallVector {
            gCGHasFallVector = false
            gCGFallVector = vec3_t()
        }
    }

    CG_DrawVote()
    CG_DrawTeamVote()

    CG_DrawLagometer()


    if cg_paused.integer == 0 {
        CG_DrawBracketedEntities()
        CG_DrawUpperRight()
    }

    if !CG_DrawFollow() {
        CG_DrawWarmup()
    }

    if cgSiegeRoundState != 0 {
        var pStr = CharBuf(1024)
        var rTime: Int32 = 0

        //cgSiegeRoundBeganTime = 0;

        switch cgSiegeRoundState {
        case 1:
            CG_CenterPrint(CG_GetStringEdString("MP_INGAME", "WAITING_FOR_PLAYERS"), Int32(Double(SCREEN_HEIGHT) * 0.30), BIGCHAR_WIDTH)

        case 2:
            rTime = (SIEGE_ROUND_BEGIN_TIME - (cg.time - cgSiegeRoundTime))

            if rTime < 0 {
                rTime = 0
            }
            if rTime > SIEGE_ROUND_BEGIN_TIME {
                rTime = SIEGE_ROUND_BEGIN_TIME
            }

            rTime /= 1000

            rTime += 1

            if rTime < 1 {
                rTime = 1
            }

            if rTime <= 3 && rTime != cgSiegeRoundCountTime {
                cgSiegeRoundCountTime = rTime

                switch rTime {
                case 1:
                    trap_S_StartLocalSound(cgs.media.count1Sound, CHAN_ANNOUNCER)

                case 2:
                    trap_S_StartLocalSound(cgs.media.count2Sound, CHAN_ANNOUNCER)

                case 3:
                    trap_S_StartLocalSound(cgs.media.count3Sound, CHAN_ANNOUNCER)

                default:
                    break
                }
            }

            strcpy(&pStr, va("%s %i...", CG_GetStringEdString("MP_INGAME", "ROUNDBEGINSIN"), rTime))
            CG_CenterPrint(String(pStr), Int32(Double(SCREEN_HEIGHT) * 0.30), BIGCHAR_WIDTH)

        default:
            break
        }

        cgSiegeEntityRender = 0
    } else if cgSiegeRoundTime != 0 {
        CG_CenterPrint("", Int32(Double(SCREEN_HEIGHT) * 0.30), BIGCHAR_WIDTH)
        cgSiegeRoundTime = 0

        //cgSiegeRoundBeganTime = cg.time;
        cgSiegeEntityRender = 0
    } else if cgSiegeRoundBeganTime != 0 {
        //Draw how much time is left in the round based on local info.
        var timedTeam: Int32 = TEAM_FREE
        var timedValue: Int32 = 0

        if cgSiegeEntityRender != 0 {
            //render the objective item model since this client has it
            CG_DrawSiegeHUDItem()
        }

        if team1Timed != 0 {
            timedTeam = TEAM_RED //team 1
            if cg_beatingSiegeTime != 0 {
                timedValue = cg_beatingSiegeTime
            } else {
                timedValue = team1Timed
            }
        } else if team2Timed != 0 {
            timedTeam = TEAM_BLUE //team 2
            if cg_beatingSiegeTime != 0 {
                timedValue = cg_beatingSiegeTime
            } else {
                timedValue = team2Timed
            }
        }

        if timedTeam != TEAM_FREE {
            //one of the teams has a timer
            var timeRemaining: Int32
            var isMyTeam: Bool = false

            if cgs.siegeTeamSwitch != 0 && cg_beatingSiegeTime == 0 {
                //in switchy mode but not beating a time, so count up.
                timeRemaining = (cg.time - cgSiegeRoundBeganTime)
                if timeRemaining < 0 {
                    timeRemaining = 0
                }
            } else {
                timeRemaining = (((cgSiegeRoundBeganTime) + timedValue) - cg.time)
            }

            if timeRemaining > timedValue {
                timeRemaining = timedValue
            } else if timeRemaining < 0 {
                timeRemaining = 0
            }

            if timeRemaining != 0 {
                timeRemaining /= 1000
            }

            if cg.predictedPlayerState.persistant[PERS_TEAM] == timedTeam {
                //the team that's timed is the one this client is on
                isMyTeam = true
            }

            CG_DrawSiegeTimer(timeRemaining, isMyTeam)
        }
    } else {
        cgSiegeEntityRender = 0
    }

    if cg_siegeDeathTime != 0 {
        var timeRemaining: Int32 = (cg_siegeDeathTime - cg.time)

        if timeRemaining < 0 {
            timeRemaining = 0
            cg_siegeDeathTime = 0
        }

        if timeRemaining != 0 {
            timeRemaining /= 1000
        }

        CG_DrawSiegeDeathTimer(timeRemaining)
    }

    // don't draw center string if scoreboard is up
    cg.scoreBoardShowing = CG_DrawScoreboard()
    if !cg.scoreBoardShowing {
        CG_DrawCenterString()
    }

    // always draw chat
    CG_ChatBox_DrawStrings()
}

/// Source: oracle/codemp/cgame/cg_draw.c:8518
private func CG_DrawTourneyScoreboard() {
}

/**
```
=====================
CG_DrawActive

Perform all drawing needed to completely fill the screen
=====================
```
*/
/// Source: oracle/codemp/cgame/cg_draw.c:8528
func CG_DrawActive(_ stereoView: JKAMP.stereoFrame_t) {
    var separation: Float
    var baseOrg = vec3_t()

    // optionally draw the info screen instead
    if cg.snap == nil {
        CG_DrawInformation()
        return
    }

    // optionally draw the tournement scoreboard instead
    if cg.snap!.ps.persistant[PERS_TEAM] == TEAM_SPECTATOR && (cg.snap!.ps.pm_flags & PMF_SCOREBOARD) != 0 {
        CG_DrawTourneyScoreboard()
        return
    }

    switch stereoView {
    case STEREO_CENTER:
        separation = 0

    case STEREO_LEFT:
        separation = -cg_stereoSeparation.value / 2

    case STEREO_RIGHT:
        separation = cg_stereoSeparation.value / 2

    default:
        separation = 0
        CG_Error("CG_DrawActive: Undefined stereoView")
    }


    // clear around the rendered view if sized down
    CG_TileClear()

    // offset vieworg appropriately if we're doing stereo separation
    baseOrg = cg.refdef.vieworg
    if separation != 0 {
        _VectorMA(cg.refdef.vieworg, -separation, cg.refdef.viewaxis[1], &cg.refdef.vieworg)
    }

    cg.refdef.rdflags |= RDF_DRAWSKYBOX

    // draw 3D view
    trap_R_RenderScene(cg.refdef)

    // restore original viewpoint if running stereo
    if separation != 0 {
        cg.refdef.vieworg = baseOrg
    }

    // draw status bar and other floating elements
    CG_Draw2D()
}
