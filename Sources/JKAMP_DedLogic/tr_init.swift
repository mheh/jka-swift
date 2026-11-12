import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/renderer/tr_init.cpp:28
let G2_VERT_SPACE_SERVER_SIZE = 256 as Int32

/// Source: oracle/codemp/renderer/tr_init.cpp:29
/// Raven's instance, a hand property of `EngineWorld`, by the HAND_VARS ruling.
public var G2VertSpaceServer: CMiniHeap? {
    get { world.G2VertSpaceServer }
    set { world.G2VertSpaceServer = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:30
/// Raven's instance, a hand property of `EngineWorld`, by the HAND_VARS ruling.
public var CMiniHeap_singleton: CMiniHeap { world.CMiniHeap_singleton }

/// Source: oracle/codemp/renderer/tr_init.cpp:40
public var r_verbose: JKAMP.Cvar? {
    get { world.variables.r_verbose }
    set { world.variables.r_verbose = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:41
public var r_ignore: JKAMP.Cvar? {
    get { world.variables.r_ignore }
    set { world.variables.r_ignore = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:43
public var r_displayRefresh: JKAMP.Cvar? {
    get { world.variables.r_displayRefresh }
    set { world.variables.r_displayRefresh = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:45
public var r_detailTextures: JKAMP.Cvar? {
    get { world.variables.r_detailTextures }
    set { world.variables.r_detailTextures = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:47
public var r_znear: JKAMP.Cvar? {
    get { world.variables.r_znear }
    set { world.variables.r_znear = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:49
public var r_skipBackEnd: JKAMP.Cvar? {
    get { world.variables.r_skipBackEnd }
    set { world.variables.r_skipBackEnd = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:51
public var r_ignorehwgamma: JKAMP.Cvar? {
    get { world.variables.r_ignorehwgamma }
    set { world.variables.r_ignorehwgamma = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:52
public var r_measureOverdraw: JKAMP.Cvar? {
    get { world.variables.r_measureOverdraw }
    set { world.variables.r_measureOverdraw = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:54
public var r_inGameVideo: JKAMP.Cvar? {
    get { world.variables.r_inGameVideo }
    set { world.variables.r_inGameVideo = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:55
public var r_fastsky: JKAMP.Cvar? {
    get { world.variables.r_fastsky }
    set { world.variables.r_fastsky = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:56
public var r_drawSun: JKAMP.Cvar? {
    get { world.variables.r_drawSun }
    set { world.variables.r_drawSun = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:57
public var r_dynamiclight: JKAMP.Cvar? {
    get { world.variables.r_dynamiclight }
    set { world.variables.r_dynamiclight = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:60
public var r_lodbias: JKAMP.Cvar? {
    get { world.variables.r_lodbias }
    set { world.variables.r_lodbias = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:61
public var r_lodscale: JKAMP.Cvar? {
    get { world.variables.r_lodscale }
    set { world.variables.r_lodscale = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:62
public var r_autolodscalevalue: JKAMP.Cvar? {
    get { world.variables.r_autolodscalevalue }
    set { world.variables.r_autolodscalevalue = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:64
public var r_norefresh: JKAMP.Cvar? {
    get { world.variables.r_norefresh }
    set { world.variables.r_norefresh = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:65
public var r_drawentities: JKAMP.Cvar? {
    get { world.variables.r_drawentities }
    set { world.variables.r_drawentities = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:66
public var r_drawworld: JKAMP.Cvar? {
    get { world.variables.r_drawworld }
    set { world.variables.r_drawworld = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:67
public var r_drawfog: JKAMP.Cvar? {
    get { world.variables.r_drawfog }
    set { world.variables.r_drawfog = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:68
public var r_speeds: JKAMP.Cvar? {
    get { world.variables.r_speeds }
    set { world.variables.r_speeds = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:69
public var r_fullbright: JKAMP.Cvar? {
    get { world.variables.r_fullbright }
    set { world.variables.r_fullbright = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:70
public var r_novis: JKAMP.Cvar? {
    get { world.variables.r_novis }
    set { world.variables.r_novis = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:71
public var r_nocull: JKAMP.Cvar? {
    get { world.variables.r_nocull }
    set { world.variables.r_nocull = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:72
public var r_facePlaneCull: JKAMP.Cvar? {
    get { world.variables.r_facePlaneCull }
    set { world.variables.r_facePlaneCull = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:73
public var r_cullRoofFaces: JKAMP.Cvar? {
    get { world.variables.r_cullRoofFaces }
    set { world.variables.r_cullRoofFaces = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:74
public var r_roofCullCeilDist: JKAMP.Cvar? {
    get { world.variables.r_roofCullCeilDist }
    set { world.variables.r_roofCullCeilDist = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:75
public var r_roofCullFloorDist: JKAMP.Cvar? {
    get { world.variables.r_roofCullFloorDist }
    set { world.variables.r_roofCullFloorDist = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:76
public var r_showcluster: JKAMP.Cvar? {
    get { world.variables.r_showcluster }
    set { world.variables.r_showcluster = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:77
public var r_nocurves: JKAMP.Cvar? {
    get { world.variables.r_nocurves }
    set { world.variables.r_nocurves = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:79
public var r_autoMap: JKAMP.Cvar? {
    get { world.variables.r_autoMap }
    set { world.variables.r_autoMap = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:80
public var r_autoMapBackAlpha: JKAMP.Cvar? {
    get { world.variables.r_autoMapBackAlpha }
    set { world.variables.r_autoMapBackAlpha = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:81
public var r_autoMapDisable: JKAMP.Cvar? {
    get { world.variables.r_autoMapDisable }
    set { world.variables.r_autoMapDisable = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:83
public var r_dlightStyle: JKAMP.Cvar? {
    get { world.variables.r_dlightStyle }
    set { world.variables.r_dlightStyle = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:84
public var r_surfaceSprites: JKAMP.Cvar? {
    get { world.variables.r_surfaceSprites }
    set { world.variables.r_surfaceSprites = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:85
public var r_surfaceWeather: JKAMP.Cvar? {
    get { world.variables.r_surfaceWeather }
    set { world.variables.r_surfaceWeather = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:87
public var r_windSpeed: JKAMP.Cvar? {
    get { world.variables.r_windSpeed }
    set { world.variables.r_windSpeed = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:88
public var r_windAngle: JKAMP.Cvar? {
    get { world.variables.r_windAngle }
    set { world.variables.r_windAngle = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:89
public var r_windGust: JKAMP.Cvar? {
    get { world.variables.r_windGust }
    set { world.variables.r_windGust = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:90
public var r_windDampFactor: JKAMP.Cvar? {
    get { world.variables.r_windDampFactor }
    set { world.variables.r_windDampFactor = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:91
public var r_windPointForce: JKAMP.Cvar? {
    get { world.variables.r_windPointForce }
    set { world.variables.r_windPointForce = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:92
public var r_windPointX: JKAMP.Cvar? {
    get { world.variables.r_windPointX }
    set { world.variables.r_windPointX = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:93
public var r_windPointY: JKAMP.Cvar? {
    get { world.variables.r_windPointY }
    set { world.variables.r_windPointY = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:95
public var r_allowExtensions: JKAMP.Cvar? {
    get { world.variables.r_allowExtensions }
    set { world.variables.r_allowExtensions = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:97
public var r_ext_compressed_textures: JKAMP.Cvar? {
    get { world.variables.r_ext_compressed_textures }
    set { world.variables.r_ext_compressed_textures = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:98
public var r_ext_compressed_lightmaps: JKAMP.Cvar? {
    get { world.variables.r_ext_compressed_lightmaps }
    set { world.variables.r_ext_compressed_lightmaps = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:99
public var r_ext_preferred_tc_method: JKAMP.Cvar? {
    get { world.variables.r_ext_preferred_tc_method }
    set { world.variables.r_ext_preferred_tc_method = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:100
public var r_ext_gamma_control: JKAMP.Cvar? {
    get { world.variables.r_ext_gamma_control }
    set { world.variables.r_ext_gamma_control = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:101
public var r_ext_multitexture: JKAMP.Cvar? {
    get { world.variables.r_ext_multitexture }
    set { world.variables.r_ext_multitexture = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:102
public var r_ext_compiled_vertex_array: JKAMP.Cvar? {
    get { world.variables.r_ext_compiled_vertex_array }
    set { world.variables.r_ext_compiled_vertex_array = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:103
public var r_ext_texture_env_add: JKAMP.Cvar? {
    get { world.variables.r_ext_texture_env_add }
    set { world.variables.r_ext_texture_env_add = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:104
public var r_ext_texture_filter_anisotropic: JKAMP.Cvar? {
    get { world.variables.r_ext_texture_filter_anisotropic }
    set { world.variables.r_ext_texture_filter_anisotropic = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:106
public var r_DynamicGlow: JKAMP.Cvar? {
    get { world.variables.r_DynamicGlow }
    set { world.variables.r_DynamicGlow = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:107
public var r_DynamicGlowPasses: JKAMP.Cvar? {
    get { world.variables.r_DynamicGlowPasses }
    set { world.variables.r_DynamicGlowPasses = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:108
public var r_DynamicGlowDelta: JKAMP.Cvar? {
    get { world.variables.r_DynamicGlowDelta }
    set { world.variables.r_DynamicGlowDelta = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:109
public var r_DynamicGlowIntensity: JKAMP.Cvar? {
    get { world.variables.r_DynamicGlowIntensity }
    set { world.variables.r_DynamicGlowIntensity = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:110
public var r_DynamicGlowSoft: JKAMP.Cvar? {
    get { world.variables.r_DynamicGlowSoft }
    set { world.variables.r_DynamicGlowSoft = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:111
public var r_DynamicGlowWidth: JKAMP.Cvar? {
    get { world.variables.r_DynamicGlowWidth }
    set { world.variables.r_DynamicGlowWidth = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:112
public var r_DynamicGlowHeight: JKAMP.Cvar? {
    get { world.variables.r_DynamicGlowHeight }
    set { world.variables.r_DynamicGlowHeight = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:114
public var r_ignoreGLErrors: JKAMP.Cvar? {
    get { world.variables.r_ignoreGLErrors }
    set { world.variables.r_ignoreGLErrors = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:115
public var r_logFile: JKAMP.Cvar? {
    get { world.variables.r_logFile }
    set { world.variables.r_logFile = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:117
public var r_stencilbits: JKAMP.Cvar? {
    get { world.variables.r_stencilbits }
    set { world.variables.r_stencilbits = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:118
public var r_depthbits: JKAMP.Cvar? {
    get { world.variables.r_depthbits }
    set { world.variables.r_depthbits = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:119
public var r_colorbits: JKAMP.Cvar? {
    get { world.variables.r_colorbits }
    set { world.variables.r_colorbits = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:120
public var r_stereo: JKAMP.Cvar? {
    get { world.variables.r_stereo }
    set { world.variables.r_stereo = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:121
public var r_primitives: JKAMP.Cvar? {
    get { world.variables.r_primitives }
    set { world.variables.r_primitives = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:122
public var r_texturebits: JKAMP.Cvar? {
    get { world.variables.r_texturebits }
    set { world.variables.r_texturebits = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:123
public var r_texturebitslm: JKAMP.Cvar? {
    get { world.variables.r_texturebitslm }
    set { world.variables.r_texturebitslm = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:125
public var r_lightmap: JKAMP.Cvar? {
    get { world.variables.r_lightmap }
    set { world.variables.r_lightmap = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:126
public var r_vertexLight: JKAMP.Cvar? {
    get { world.variables.r_vertexLight }
    set { world.variables.r_vertexLight = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:127
public var r_uiFullScreen: JKAMP.Cvar? {
    get { world.variables.r_uiFullScreen }
    set { world.variables.r_uiFullScreen = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:128
public var r_shadows: JKAMP.Cvar? {
    get { world.variables.r_shadows }
    set { world.variables.r_shadows = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:129
public var r_shadowRange: JKAMP.Cvar? {
    get { world.variables.r_shadowRange }
    set { world.variables.r_shadowRange = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:130
public var r_flares: JKAMP.Cvar? {
    get { world.variables.r_flares }
    set { world.variables.r_flares = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:131
public var r_mode: JKAMP.Cvar? {
    get { world.variables.r_mode }
    set { world.variables.r_mode = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:132
public var r_nobind: JKAMP.Cvar? {
    get { world.variables.r_nobind }
    set { world.variables.r_nobind = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:133
public var r_singleShader: JKAMP.Cvar? {
    get { world.variables.r_singleShader }
    set { world.variables.r_singleShader = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:134
public var r_colorMipLevels: JKAMP.Cvar? {
    get { world.variables.r_colorMipLevels }
    set { world.variables.r_colorMipLevels = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:135
public var r_picmip: JKAMP.Cvar? {
    get { world.variables.r_picmip }
    set { world.variables.r_picmip = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:136
public var r_showtris: JKAMP.Cvar? {
    get { world.variables.r_showtris }
    set { world.variables.r_showtris = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:137
public var r_showsky: JKAMP.Cvar? {
    get { world.variables.r_showsky }
    set { world.variables.r_showsky = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:138
public var r_shownormals: JKAMP.Cvar? {
    get { world.variables.r_shownormals }
    set { world.variables.r_shownormals = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:139
public var r_finish: JKAMP.Cvar? {
    get { world.variables.r_finish }
    set { world.variables.r_finish = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:140
public var r_clear: JKAMP.Cvar? {
    get { world.variables.r_clear }
    set { world.variables.r_clear = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:141
public var r_swapInterval: JKAMP.Cvar? {
    get { world.variables.r_swapInterval }
    set { world.variables.r_swapInterval = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:142
public var r_markcount: JKAMP.Cvar? {
    get { world.variables.r_markcount }
    set { world.variables.r_markcount = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:143
public var r_textureMode: JKAMP.Cvar? {
    get { world.variables.r_textureMode }
    set { world.variables.r_textureMode = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:144
public var r_offsetFactor: JKAMP.Cvar? {
    get { world.variables.r_offsetFactor }
    set { world.variables.r_offsetFactor = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:145
public var r_offsetUnits: JKAMP.Cvar? {
    get { world.variables.r_offsetUnits }
    set { world.variables.r_offsetUnits = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:146
public var r_gamma: JKAMP.Cvar? {
    get { world.variables.r_gamma }
    set { world.variables.r_gamma = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:147
public var r_intensity: JKAMP.Cvar? {
    get { world.variables.r_intensity }
    set { world.variables.r_intensity = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:148
public var r_lockpvs: JKAMP.Cvar? {
    get { world.variables.r_lockpvs }
    set { world.variables.r_lockpvs = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:149
public var r_noportals: JKAMP.Cvar? {
    get { world.variables.r_noportals }
    set { world.variables.r_noportals = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:150
public var r_portalOnly: JKAMP.Cvar? {
    get { world.variables.r_portalOnly }
    set { world.variables.r_portalOnly = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:152
public var r_subdivisions: JKAMP.Cvar? {
    get { world.variables.r_subdivisions }
    set { world.variables.r_subdivisions = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:153
public var r_lodCurveError: JKAMP.Cvar? {
    get { world.variables.r_lodCurveError }
    set { world.variables.r_lodCurveError = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:155
public var r_fullscreen: JKAMP.Cvar? {
    get { world.variables.r_fullscreen }
    set { world.variables.r_fullscreen = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:157
public var r_customwidth: JKAMP.Cvar? {
    get { world.variables.r_customwidth }
    set { world.variables.r_customwidth = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:158
public var r_customheight: JKAMP.Cvar? {
    get { world.variables.r_customheight }
    set { world.variables.r_customheight = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:160
public var r_overBrightBits: JKAMP.Cvar? {
    get { world.variables.r_overBrightBits }
    set { world.variables.r_overBrightBits = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:162
public var r_debugSurface: JKAMP.Cvar? {
    get { world.variables.r_debugSurface }
    set { world.variables.r_debugSurface = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:163
public var r_simpleMipMaps: JKAMP.Cvar? {
    get { world.variables.r_simpleMipMaps }
    set { world.variables.r_simpleMipMaps = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:165
public var r_showImages: JKAMP.Cvar? {
    get { world.variables.r_showImages }
    set { world.variables.r_showImages = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:167
public var r_ambientScale: JKAMP.Cvar? {
    get { world.variables.r_ambientScale }
    set { world.variables.r_ambientScale = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:168
public var r_directedScale: JKAMP.Cvar? {
    get { world.variables.r_directedScale }
    set { world.variables.r_directedScale = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:169
public var r_debugLight: JKAMP.Cvar? {
    get { world.variables.r_debugLight }
    set { world.variables.r_debugLight = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:170
public var r_debugSort: JKAMP.Cvar? {
    get { world.variables.r_debugSort }
    set { world.variables.r_debugSort = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:172
public var r_maxpolys: JKAMP.Cvar? {
    get { world.variables.r_maxpolys }
    set { world.variables.r_maxpolys = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:173
public var max_polys: Int32 {
    get { world.variables.max_polys }
    set { world.variables.max_polys = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:174
public var r_maxpolyverts: JKAMP.Cvar? {
    get { world.variables.r_maxpolyverts }
    set { world.variables.r_maxpolyverts = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:175
public var max_polyverts: Int32 {
    get { world.variables.max_polyverts }
    set { world.variables.max_polyverts = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:177
public var r_modelpoolmegs: JKAMP.Cvar? {
    get { world.variables.r_modelpoolmegs }
    set { world.variables.r_modelpoolmegs = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:195
public var r_noServerGhoul2: JKAMP.Cvar? {
    get { world.variables.r_noServerGhoul2 }
    set { world.variables.r_noServerGhoul2 = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:196
public var r_Ghoul2AnimSmooth: JKAMP.Cvar? {
    get { world.variables.r_Ghoul2AnimSmooth }
    set { world.variables.r_Ghoul2AnimSmooth = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:197
public var r_Ghoul2UnSqashAfterSmooth: JKAMP.Cvar? {
    get { world.variables.r_Ghoul2UnSqashAfterSmooth }
    set { world.variables.r_Ghoul2UnSqashAfterSmooth = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:204
public var broadsword: JKAMP.Cvar? {
    get { world.variables.broadsword }
    set { world.variables.broadsword = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:205
public var broadsword_kickbones: JKAMP.Cvar? {
    get { world.variables.broadsword_kickbones }
    set { world.variables.broadsword_kickbones = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:206
public var broadsword_kickorigin: JKAMP.Cvar? {
    get { world.variables.broadsword_kickorigin }
    set { world.variables.broadsword_kickorigin = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:207
public var broadsword_playflop: JKAMP.Cvar? {
    get { world.variables.broadsword_playflop }
    set { world.variables.broadsword_playflop = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:208
public var broadsword_dontstopanim: JKAMP.Cvar? {
    get { world.variables.broadsword_dontstopanim }
    set { world.variables.broadsword_dontstopanim = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:209
public var broadsword_waitforshot: JKAMP.Cvar? {
    get { world.variables.broadsword_waitforshot }
    set { world.variables.broadsword_waitforshot = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:210
public var broadsword_smallbbox: JKAMP.Cvar? {
    get { world.variables.broadsword_smallbbox }
    set { world.variables.broadsword_smallbbox = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:211
public var broadsword_extra1: JKAMP.Cvar? {
    get { world.variables.broadsword_extra1 }
    set { world.variables.broadsword_extra1 = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:212
public var broadsword_extra2: JKAMP.Cvar? {
    get { world.variables.broadsword_extra2 }
    set { world.variables.broadsword_extra2 = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:214
public var broadsword_effcorr: JKAMP.Cvar? {
    get { world.variables.broadsword_effcorr }
    set { world.variables.broadsword_effcorr = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:215
public var broadsword_ragtobase: JKAMP.Cvar? {
    get { world.variables.broadsword_ragtobase }
    set { world.variables.broadsword_ragtobase = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:216
public var broadsword_dircap: JKAMP.Cvar? {
    get { world.variables.broadsword_dircap }
    set { world.variables.broadsword_dircap = newValue }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:465
// Raven wrote: const vidmode_t r_vidModes[]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/renderer/tr_init.cpp:481
// Raven wrote: static const int s_numVidModes = ( sizeof( r_vidModes ) / sizeof( r_vidModes[0] ) )
let s_numVidModes: Int32 = Int32(r_vidModes.count)

/// Source: oracle/codemp/renderer/tr_init.cpp:1460
// AI: Raven declares `re` static in GetRefAPI. The function uses one zeroed allocation on the storage class.
var re_GetRefAPI: Refexport { world.storage.re_GetRefAPI }

/// Source: oracle/codemp/renderer/tr_init.cpp:300
private func AssertCvarRange(_ cv: JKAMP.Cvar, _ minVal: Float, _ maxVal: Float, _ shouldBeIntegral: Bool) {
    if shouldBeIntegral {
        if Int32(cv.value) != cv.integer {
            Com_Printf(S_COLOR_YELLOW + "WARNING: cvar '%s' must be integral (%f)\n", cv.name ?? "(null)", cv.value)
            Cvar_Set(cv.name!, va("%d", cv.integer))
        }
    }

    if cv.value < minVal {
        Com_Printf(S_COLOR_YELLOW + "WARNING: cvar '%s' out of range (%f < %f)\n", cv.name ?? "(null)", cv.value, minVal)
        Cvar_Set(cv.name!, va("%f", minVal))
    } else if cv.value > maxVal {
        Com_Printf(S_COLOR_YELLOW + "WARNING: cvar '%s' out of range (%f > %f)\n", cv.name ?? "(null)", cv.value, maxVal)
        Cvar_Set(cv.name!, va("%f", maxVal))
    }
}

/// Source: oracle/codemp/renderer/tr_init.cpp:483
public func R_GetModeInfo(_ width: inout Int32, _ height: inout Int32, _ mode: Int32) -> Bool {
    var vm: Vidmode

    if mode < -1 {
        return false
    }
    if mode >= s_numVidModes {
        return false
    }

    if mode == -1 {
        width = r_customwidth!.integer
        height = r_customheight!.integer
        return true
    }

    vm = r_vidModes[mode]

    width = vm.width
    height = vm.height

    return true
}

/**
```
** R_ModeList_f
```
*/
/// Source: oracle/codemp/renderer/tr_init.cpp:510
private func R_ModeList_f() {
    var i: Int32

    Com_Printf("\n")
    i = 0
    while i < s_numVidModes {
        Com_Printf("%s\n", r_vidModes[i].description ?? "(null)")
        i += 1
    }
    Com_Printf("\n")
}

/**
```
===============
R_Register
===============
```
*/
/// Source: oracle/codemp/renderer/tr_init.cpp:985
public func R_Register() {
    //
    // latched and archived variables
    //
    r_allowExtensions = Cvar_Get("r_allowExtensions", "1", CVAR_ARCHIVE | CVAR_LATCH)
    r_ext_compressed_textures = Cvar_Get("r_ext_compress_textures", "1", CVAR_ARCHIVE | CVAR_LATCH)
    r_ext_compressed_lightmaps = Cvar_Get("r_ext_compress_lightmaps", "0", CVAR_ARCHIVE | CVAR_LATCH)
    r_ext_preferred_tc_method = Cvar_Get("r_ext_preferred_tc_method", "0", CVAR_ARCHIVE | CVAR_LATCH)
    r_ext_gamma_control = Cvar_Get("r_ext_gamma_control", "1", CVAR_ARCHIVE | CVAR_LATCH)
    r_ext_multitexture = Cvar_Get("r_ext_multitexture", "1", CVAR_ARCHIVE | CVAR_LATCH)
    r_ext_compiled_vertex_array = Cvar_Get("r_ext_compiled_vertex_array", "1", CVAR_ARCHIVE | CVAR_LATCH)
    r_ext_texture_env_add = Cvar_Get("r_ext_texture_env_add", "1", CVAR_ARCHIVE | CVAR_LATCH)
    r_ext_texture_filter_anisotropic = Cvar_Get("r_ext_texture_filter_anisotropic", "16", CVAR_ARCHIVE)

    r_DynamicGlow = Cvar_Get("r_DynamicGlow", "0", CVAR_ARCHIVE)
    r_DynamicGlowPasses = Cvar_Get("r_DynamicGlowPasses", "5", CVAR_CHEAT)
    r_DynamicGlowDelta = Cvar_Get("r_DynamicGlowDelta", "0.8f", CVAR_CHEAT)
    r_DynamicGlowIntensity = Cvar_Get("r_DynamicGlowIntensity", "1.13f", CVAR_CHEAT)
    r_DynamicGlowSoft = Cvar_Get("r_DynamicGlowSoft", "1", CVAR_CHEAT)
    r_DynamicGlowWidth = Cvar_Get("r_DynamicGlowWidth", "320", CVAR_CHEAT | CVAR_LATCH)
    r_DynamicGlowHeight = Cvar_Get("r_DynamicGlowHeight", "240", CVAR_CHEAT | CVAR_LATCH)

    r_picmip = Cvar_Get("r_picmip", "1", CVAR_ARCHIVE | CVAR_LATCH)
    r_colorMipLevels = Cvar_Get("r_colorMipLevels", "0", CVAR_LATCH)
    AssertCvarRange(r_picmip!, 0, 16, true)
    r_detailTextures = Cvar_Get("r_detailtextures", "1", CVAR_ARCHIVE | CVAR_LATCH)
    r_texturebits = Cvar_Get("r_texturebits", "0", CVAR_ARCHIVE | CVAR_LATCH)
    r_texturebitslm = Cvar_Get("r_texturebitslm", "0", CVAR_ARCHIVE | CVAR_LATCH)
    r_colorbits = Cvar_Get("r_colorbits", "0", CVAR_ARCHIVE | CVAR_LATCH)
    r_stereo = Cvar_Get("r_stereo", "0", CVAR_ARCHIVE | CVAR_LATCH)
    r_stencilbits = Cvar_Get("r_stencilbits", "8", CVAR_ARCHIVE | CVAR_LATCH)
    r_depthbits = Cvar_Get("r_depthbits", "0", CVAR_ARCHIVE | CVAR_LATCH)
    r_overBrightBits = Cvar_Get("r_overBrightBits", "0", CVAR_ARCHIVE | CVAR_LATCH)
    r_ignorehwgamma = Cvar_Get("r_ignorehwgamma", "0", CVAR_ARCHIVE | CVAR_LATCH)
    r_mode = Cvar_Get("r_mode", "4", CVAR_ARCHIVE | CVAR_LATCH)
    r_fullscreen = Cvar_Get("r_fullscreen", "1", CVAR_ARCHIVE | CVAR_LATCH)
    r_customwidth = Cvar_Get("r_customwidth", "1600", CVAR_ARCHIVE | CVAR_LATCH)
    r_customheight = Cvar_Get("r_customheight", "1024", CVAR_ARCHIVE | CVAR_LATCH)
    r_simpleMipMaps = Cvar_Get("r_simpleMipMaps", "1", CVAR_ARCHIVE | CVAR_LATCH)
    r_vertexLight = Cvar_Get("r_vertexLight", "0", CVAR_ARCHIVE | CVAR_LATCH)
    r_uiFullScreen = Cvar_Get("r_uifullscreen", "0", 0)
    r_subdivisions = Cvar_Get("r_subdivisions", "4", CVAR_ARCHIVE | CVAR_LATCH)

    //
    // temporary latched variables that can only change over a restart
    //
    r_displayRefresh = Cvar_Get("r_displayRefresh", "0", CVAR_LATCH)
    AssertCvarRange(r_displayRefresh!, 0, 200, true)
    r_fullbright = Cvar_Get("r_fullbright", "0", CVAR_CHEAT)
    r_intensity = Cvar_Get("r_intensity", "1", CVAR_LATCH)
    r_singleShader = Cvar_Get("r_singleShader", "0", CVAR_CHEAT | CVAR_LATCH)

    //
    // archived variables that can change at any time
    //
    r_lodCurveError = Cvar_Get("r_lodCurveError", "250", CVAR_ARCHIVE)
    r_lodbias = Cvar_Get("r_lodbias", "0", CVAR_ARCHIVE)
    r_autolodscalevalue = Cvar_Get("r_autolodscalevalue", "0", CVAR_ROM)

    r_flares = Cvar_Get("r_flares", "1", CVAR_ARCHIVE)
    r_znear = Cvar_Get("r_znear", "4", CVAR_CHEAT)
    AssertCvarRange(r_znear!, 0.001, 200, true)
    r_ignoreGLErrors = Cvar_Get("r_ignoreGLErrors", "1", CVAR_ARCHIVE)
    r_fastsky = Cvar_Get("r_fastsky", "0", CVAR_ARCHIVE)
    r_inGameVideo = Cvar_Get("r_inGameVideo", "1", CVAR_ARCHIVE)
    r_drawSun = Cvar_Get("r_drawSun", "0", CVAR_ARCHIVE)
    r_dynamiclight = Cvar_Get("r_dynamiclight", "1", CVAR_ARCHIVE)
    // rjr - removed for hacking r_dlightBacks = Cvar_Get( "r_dlightBacks", "1", CVAR_CHEAT );
    r_finish = Cvar_Get("r_finish", "0", CVAR_ARCHIVE)
    r_textureMode = Cvar_Get("r_textureMode", "GL_LINEAR_MIPMAP_NEAREST", CVAR_ARCHIVE)
    r_swapInterval = Cvar_Get("r_swapInterval", "0", CVAR_ARCHIVE)
    r_markcount = Cvar_Get("r_markcount", "100", CVAR_ARCHIVE)
    r_gamma = Cvar_Get("r_gamma", "1", CVAR_ARCHIVE)
    r_facePlaneCull = Cvar_Get("r_facePlaneCull", "1", CVAR_ARCHIVE)

    r_cullRoofFaces = Cvar_Get("r_cullRoofFaces", "0", CVAR_CHEAT) //attempted smart method of culling out upwards facing surfaces on roofs for automap shots -rww
    r_roofCullCeilDist = Cvar_Get("r_roofCullCeilDist", "256", CVAR_CHEAT) //attempted smart method of culling out upwards facing surfaces on roofs for automap shots -rww
    r_roofCullFloorDist = Cvar_Get("r_roofCeilFloorDist", "128", CVAR_CHEAT) //attempted smart method of culling out upwards facing surfaces on roofs for automap shots -rww

    r_primitives = Cvar_Get("r_primitives", "0", CVAR_ARCHIVE)

    r_ambientScale = Cvar_Get("r_ambientScale", "0.6", CVAR_CHEAT)
    r_directedScale = Cvar_Get("r_directedScale", "1", CVAR_CHEAT)

    r_autoMap = Cvar_Get("r_autoMap", "0", CVAR_ARCHIVE) //automap renderside toggle for debugging -rww
    r_autoMapBackAlpha = Cvar_Get("r_autoMapBackAlpha", "0", 0) //alpha of automap bg -rww
    r_autoMapDisable = Cvar_Get("r_autoMapDisable", "1", 0)

    //
    // temporary variables that can change at any time
    //
    r_showImages = Cvar_Get("r_showImages", "0", CVAR_CHEAT)

    r_debugLight = Cvar_Get("r_debuglight", "0", CVAR_TEMP)
    r_debugSort = Cvar_Get("r_debugSort", "0", CVAR_CHEAT)

    r_dlightStyle = Cvar_Get("r_dlightStyle", "1", CVAR_TEMP)
    r_surfaceSprites = Cvar_Get("r_surfaceSprites", "1", CVAR_TEMP)
    r_surfaceWeather = Cvar_Get("r_surfaceWeather", "0", CVAR_TEMP)

    r_windSpeed = Cvar_Get("r_windSpeed", "0", 0)
    r_windAngle = Cvar_Get("r_windAngle", "0", 0)
    r_windGust = Cvar_Get("r_windGust", "0", 0)
    r_windDampFactor = Cvar_Get("r_windDampFactor", "0.1", 0)
    r_windPointForce = Cvar_Get("r_windPointForce", "0", 0)
    r_windPointX = Cvar_Get("r_windPointX", "0", 0)
    r_windPointY = Cvar_Get("r_windPointY", "0", 0)

    r_nocurves = Cvar_Get("r_nocurves", "0", CVAR_CHEAT)
    r_drawworld = Cvar_Get("r_drawworld", "1", CVAR_CHEAT)
    r_drawfog = Cvar_Get("r_drawfog", "2", CVAR_CHEAT)
    r_lightmap = Cvar_Get("r_lightmap", "0", CVAR_CHEAT)
    r_portalOnly = Cvar_Get("r_portalOnly", "0", CVAR_CHEAT)

    r_skipBackEnd = Cvar_Get("r_skipBackEnd", "0", CVAR_CHEAT)

    r_measureOverdraw = Cvar_Get("r_measureOverdraw", "0", CVAR_CHEAT)
    r_lodscale = Cvar_Get("r_lodscale", "5", 0)
    r_norefresh = Cvar_Get("r_norefresh", "0", CVAR_CHEAT)
    r_drawentities = Cvar_Get("r_drawentities", "1", CVAR_CHEAT)
    r_ignore = Cvar_Get("r_ignore", "1", CVAR_CHEAT)
    r_nocull = Cvar_Get("r_nocull", "0", CVAR_CHEAT)
    r_novis = Cvar_Get("r_novis", "0", CVAR_CHEAT)
    r_showcluster = Cvar_Get("r_showcluster", "0", CVAR_CHEAT)
    r_speeds = Cvar_Get("r_speeds", "0", CVAR_CHEAT)
    r_verbose = Cvar_Get("r_verbose", "0", CVAR_CHEAT)
    r_logFile = Cvar_Get("r_logFile", "0", CVAR_CHEAT)
    r_debugSurface = Cvar_Get("r_debugSurface", "0", CVAR_CHEAT)
    r_nobind = Cvar_Get("r_nobind", "0", CVAR_CHEAT)
    r_showtris = Cvar_Get("r_showtris", "0", CVAR_CHEAT)
    r_showsky = Cvar_Get("r_showsky", "0", CVAR_CHEAT)
    r_shownormals = Cvar_Get("r_shownormals", "0", CVAR_CHEAT)
    r_clear = Cvar_Get("r_clear", "0", CVAR_CHEAT)
    r_offsetFactor = Cvar_Get("r_offsetfactor", "-1", CVAR_CHEAT)
    r_offsetUnits = Cvar_Get("r_offsetunits", "-2", CVAR_CHEAT)
    r_lockpvs = Cvar_Get("r_lockpvs", "0", CVAR_CHEAT)
    r_noportals = Cvar_Get("r_noportals", "0", CVAR_CHEAT)
    r_shadows = Cvar_Get("cg_shadows", "1", 0)
    r_shadowRange = Cvar_Get("r_shadowRange", "1000", 0)

    r_maxpolys = Cvar_Get("r_maxpolys", va("%d", MAX_POLYS), 0)
    r_maxpolyverts = Cvar_Get("r_maxpolyverts", va("%d", MAX_POLYVERTS), 0)
    /*
    Ghoul2 Insert Start
    */

    r_noServerGhoul2 = Cvar_Get("r_noserverghoul2", "0", CVAR_CHEAT)

    r_Ghoul2AnimSmooth = Cvar_Get("r_ghoul2animsmooth", "0.3", 0)
    r_Ghoul2UnSqashAfterSmooth = Cvar_Get("r_ghoul2unsqashaftersmooth", "1", 0)

    broadsword = Cvar_Get("broadsword", "0", 0)
    broadsword_kickbones = Cvar_Get("broadsword_kickbones", "1", 0)
    broadsword_kickorigin = Cvar_Get("broadsword_kickorigin", "1", 0)
    broadsword_dontstopanim = Cvar_Get("broadsword_dontstopanim", "0", 0)
    broadsword_waitforshot = Cvar_Get("broadsword_waitforshot", "0", 0)
    broadsword_playflop = Cvar_Get("broadsword_playflop", "1", 0)
    broadsword_smallbbox = Cvar_Get("broadsword_smallbbox", "0", 0)
    broadsword_extra1 = Cvar_Get("broadsword_extra1", "0", 0)
    broadsword_extra2 = Cvar_Get("broadsword_extra2", "0", 0)
    broadsword_effcorr = Cvar_Get("broadsword_effcorr", "1", 0)
    broadsword_ragtobase = Cvar_Get("broadsword_ragtobase", "2", 0)
    broadsword_dircap = Cvar_Get("broadsword_dircap", "64", 0)
    /*
    Ghoul2 Insert End
    */
    r_modelpoolmegs = Cvar_Get("r_modelpoolmegs", "20", CVAR_ARCHIVE)
    if Sys_LowPhysicalMemory() {
        Cvar_Set("r_modelpoolmegs", "0")
    }

    // make sure all the commands added here are also
    // removed in R_Shutdown
    Cmd_AddCommand("modellist", R_Modellist_f)
    Cmd_AddCommand("modelist", R_ModeList_f)
    Cmd_AddCommand("modelcacheinfo", RE_RegisterModels_Info_f)
}

/// Source: oracle/codemp/renderer/tr_init.cpp:1214
public func R_Init() {
    var i: Int32

    //	Com_Printf ("----- R_Init -----\n" );

    // clear all our internal state
    tr.clear()
    backEnd.clear()

    //	Swap_Init();

    //
    // init function tables
    //
    i = 0
    while i < FUNCTABLE_SIZE {
        tr.sinTable[i] = sin(DEG2RAD(i * 360.0 / (Float(FUNCTABLE_SIZE - 1))))
        tr.squareTable[i] = (i < FUNCTABLE_SIZE / 2) ? 1.0 : -1.0
        tr.sawToothTable[i] = Float(i) / FUNCTABLE_SIZE
        tr.inverseSawToothTable[i] = 1.0 - tr.sawToothTable[i]

        if i < FUNCTABLE_SIZE / 2 {
            if i < FUNCTABLE_SIZE / 4 {
                tr.triangleTable[i] = Float(i) / (FUNCTABLE_SIZE / 4)
            } else {
                tr.triangleTable[i] = 1.0 - tr.triangleTable[i - FUNCTABLE_SIZE / 4]
            }
        } else {
            tr.triangleTable[i] = -tr.triangleTable[i - FUNCTABLE_SIZE / 2]
        }
        i += 1
    }
    R_Register()

    max_polys = r_maxpolys!.integer
    if max_polys < MAX_POLYS {
        max_polys = MAX_POLYS
    }

    max_polyverts = r_maxpolyverts!.integer
    if max_polyverts < MAX_POLYVERTS {
        max_polyverts = MAX_POLYVERTS
    }

    let ptr = Hunk_Alloc(Int32(BackEndData.byteCount) + Int32(SrfPoly.byteCount) * max_polys + Int32(PolyVert.byteCount) * max_polyverts, h_low)
    backEndData = BackEndData(ptr)
    backEndData!.polys = SrfPoly(ptr + Int32(BackEndData.byteCount))
    backEndData!.polyVerts = PolyVert(ptr + Int32(BackEndData.byteCount) + Int32(SrfPoly.byteCount) * max_polys)
    R_ModelInit()
    G2VertSpaceServer = CMiniHeap_singleton
    //	Com_Printf ("----- finished R_Init -----\n" );
}

/**
```
===============
RE_Shutdown
===============
```
*/
/// Source: oracle/codemp/renderer/tr_init.cpp:1333
public func RE_Shutdown(_ destroyWindow: Bool) {

    //	Com_Printf ("RE_Shutdown( %i )\n", destroyWindow );

    Cmd_RemoveCommand("imagelist")
    Cmd_RemoveCommand("shaderlist")
    Cmd_RemoveCommand("skinlist")
    Cmd_RemoveCommand("screenshot")
    Cmd_RemoveCommand("screenshot_tga")
    Cmd_RemoveCommand("gfxinfo")
    Cmd_RemoveCommand("r_atihack")
    Cmd_RemoveCommand("r_we")
    Cmd_RemoveCommand("imagecacheinfo")
    Cmd_RemoveCommand("modellist")
    Cmd_RemoveCommand("modelist")
    Cmd_RemoveCommand("modelcacheinfo")

    tr.registered = false
}

/**
```
@@@@@@@@@@@@@@@@@@@@@
GetRefAPI

@@@@@@@@@@@@@@@@@@@@@
```
*/
/// Source: oracle/codemp/renderer/tr_init.cpp:1459
public func GetRefAPI(_ apiVersion: Int32) -> Refexport? {
    // The client's cl_main.cpp:2483 is the one caller, and the dedicated host does not link it, so the function is dead.
    re_GetRefAPI.clear()

    if apiVersion != REF_API_VERSION {
        Com_Printf("Mismatched REF_API_VERSION: expected %i, got %i\n", REF_API_VERSION, apiVersion)
        return nil
    }

    // the RE_ functions are Renderer Entry points

    re_GetRefAPI.Shutdown = RefexportThunks.RE_Shutdown
    return re_GetRefAPI
}

/// One static per function this file stores in a `Refexport` callback field, so each has one address for the life of the module.
/// The thunks stand in this file, because the functions they call are private to it.
private enum RefexportThunks {
    /// Source: oracle/codemp/renderer/tr_init.cpp:1333
    static let RE_Shutdown: RefexportShutdown = { JKAMP_DedLogic.RE_Shutdown($0 != 0) }
}
