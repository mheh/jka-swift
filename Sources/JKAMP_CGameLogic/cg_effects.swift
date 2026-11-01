import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/cg_effects.c:254
var offX: [[Float]] {
    get { world.variables.offX }
    set { world.variables.offX = newValue }
}

/// Source: oracle/codemp/cgame/cg_effects.c:255
var offZ: [[Float]] {
    get { world.variables.offZ }
    set { world.variables.offZ = newValue }
}

/// Source: oracle/codemp/cgame/cg_effects.c:257
let FX_ALPHA_NONLINEAR = 0x00000004 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:258
let FX_APPLY_PHYSICS = 0x02000000 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:259
private let FX_USE_ALPHA = 0x08000000 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:452
let TIME_DECAY_SLOW = 0.1 as Float

/// Source: oracle/codemp/cgame/cg_effects.c:453
let TIME_DECAY_MED = 0.04 as Float

/// Source: oracle/codemp/cgame/cg_effects.c:454
let TIME_DECAY_FAST = 0.009 as Float

/// Source: oracle/codemp/cgame/cg_effects.c:756
let DEBRIS_SPECIALCASE_ROCK = -1 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:757
let DEBRIS_SPECIALCASE_CHUNKS = -2 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:758
let DEBRIS_SPECIALCASE_WOOD = -3 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:759
let DEBRIS_SPECIALCASE_GLASS = -4 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:761
let NUM_DEBRIS_MODELS_GLASS = 8 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:762
let NUM_DEBRIS_MODELS_WOOD = 8 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:763
let NUM_DEBRIS_MODELS_CHUNKS = 3 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:764
let NUM_DEBRIS_MODELS_ROCKS = 4 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:766
var dbModels_Glass: [Int32] {
    get { world.variables.dbModels_Glass }
    set { world.variables.dbModels_Glass = newValue }
}

/// Source: oracle/codemp/cgame/cg_effects.c:767
var dbModels_Wood: [Int32] {
    get { world.variables.dbModels_Wood }
    set { world.variables.dbModels_Wood = newValue }
}

/// Source: oracle/codemp/cgame/cg_effects.c:768
var dbModels_Chunks: [Int32] {
    get { world.variables.dbModels_Chunks }
    set { world.variables.dbModels_Chunks = newValue }
}

/// Source: oracle/codemp/cgame/cg_effects.c:769
var dbModels_Rocks: [Int32] {
    get { world.variables.dbModels_Rocks }
    set { world.variables.dbModels_Rocks = newValue }
}

/// Source: oracle/codemp/cgame/cg_effects.c:1384
let NUM_SPARKS = 12 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:1385
let NUM_PUFFS = 1 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:1386
let NUM_EXPLOSIONS = 4 as Int32

/**
```
==================
CG_BubbleTrail

Bullets shot underwater
==================
```
*/
/// Source: oracle/codemp/cgame/cg_effects.c:15
func CG_BubbleTrail(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ spacing: Float) {
    // TODO: Port CG_BubbleTrail
    portMissing("CG_BubbleTrail", source: "oracle/codemp/cgame/cg_effects.c:15")
}

/**
```
=====================
CG_SmokePuff

Adds a smoke puff or blood trail localEntity.
=====================
```
*/
/// Source: oracle/codemp/cgame/cg_effects.c:78
func CG_SmokePuff(_ p: JKAShared.vec3_t, _ vel: JKAShared.vec3_t, _ radius: Float, _ r: Float, _ g: Float, _ b: Float, _ a: Float, _ duration: Float, _ startTime: Int32, _ fadeInTime: Int32, _ leFlags: Int32, _ hShader: JKAShared.qhandle_t) -> LocalEntity? {
    // TODO: Port CG_SmokePuff
    portMissing("CG_SmokePuff", source: "oracle/codemp/cgame/cg_effects.c:78")
}

/// Source: oracle/codemp/cgame/cg_effects.c:135
func CGDEBUG_SaberColor(_ saberColor: Int32) -> Int32 {
    // TODO: Port CGDEBUG_SaberColor
    portMissing("CGDEBUG_SaberColor", source: "oracle/codemp/cgame/cg_effects.c:135")
}

/// Source: oracle/codemp/cgame/cg_effects.c:163
func CG_TestLine(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ time: Int32, _ color: UInt32, _ radius: Int32) {
    // TODO: Port CG_TestLine
    portMissing("CG_TestLine", source: "oracle/codemp/cgame/cg_effects.c:163")
}

/**
```
==================
CG_ThrowChunk
==================
```
*/
/// Source: oracle/codemp/cgame/cg_effects.c:211
func CG_ThrowChunk(_ origin: JKAShared.vec3_t, _ velocity: JKAShared.vec3_t, _ hModel: JKAShared.qhandle_t, _ optionalSound: Int32, _ startalpha: Int32) {
    // TODO: Port CG_ThrowChunk
    portMissing("CG_ThrowChunk", source: "oracle/codemp/cgame/cg_effects.c:211")
}

/// Source: oracle/codemp/cgame/cg_effects.c:261
private func CG_DoGlassQuad(_ p: inout [JKAShared.vec3_t], _ uv: inout [JKAShared.vec2_t], _ stick: Bool, _ time: Int32, _ dmgDir: JKAShared.vec3_t) {
    // TODO: Port CG_DoGlassQuad
    portMissing("CG_DoGlassQuad", source: "oracle/codemp/cgame/cg_effects.c:261")
}

/// Source: oracle/codemp/cgame/cg_effects.c:367
private func CG_CalcBiLerp(_ verts: inout [JKAShared.vec3_t], _ subVerts: inout [JKAShared.vec3_t], _ uv: inout [JKAShared.vec2_t]) {
    // TODO: Port CG_CalcBiLerp
    portMissing("CG_CalcBiLerp", source: "oracle/codemp/cgame/cg_effects.c:367")
}

/// Source: oracle/codemp/cgame/cg_effects.c:404
private func CG_CalcHeightWidth(_ verts: inout [JKAShared.vec3_t], _ height: inout Float, _ width: inout Float) {
    // TODO: Port CG_CalcHeightWidth
    portMissing("CG_CalcHeightWidth", source: "oracle/codemp/cgame/cg_effects.c:404")
}

/// Source: oracle/codemp/cgame/cg_effects.c:430
func CG_InitGlass() {
    // TODO: Port CG_InitGlass
    portMissing("CG_InitGlass", source: "oracle/codemp/cgame/cg_effects.c:430")
}

/// Source: oracle/codemp/cgame/cg_effects.c:446
func Vector2Set(_ a: [Float], _ b: Float, _ c: Float) {
    // TODO: Port Vector2Set
    portMissing("Vector2Set", source: "oracle/codemp/cgame/cg_effects.c:446")
}

/// Source: oracle/codemp/cgame/cg_effects.c:456
func CG_DoGlass(_ verts: inout [JKAShared.vec3_t], _ normal: JKAShared.vec3_t, _ dmgPt: JKAShared.vec3_t, _ dmgDir: JKAShared.vec3_t, _ dmgRadius: Float, _ maxShards: Int32) {
    // TODO: Port CG_DoGlass
    portMissing("CG_DoGlass", source: "oracle/codemp/cgame/cg_effects.c:456")
}

/**
```
==================
CG_GlassShatter
Break glass with fancy method
==================
```
*/
/// Source: oracle/codemp/cgame/cg_effects.c:656
func CG_GlassShatter(_ entnum: Int32, _ dmgPt: JKAShared.vec3_t, _ dmgDir: JKAShared.vec3_t, _ dmgRadius: Float, _ maxShards: Int32) {
    // TODO: Port CG_GlassShatter
    portMissing("CG_GlassShatter", source: "oracle/codemp/cgame/cg_effects.c:656")
}

/**
```
==================
CG_GlassShatter_Old
Throws glass shards from within a given bounding box in the world
==================
```
*/
/// Source: oracle/codemp/cgame/cg_effects.c:674
func CG_GlassShatter_Old(_ entnum: Int32, _ org: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t) {
    // TODO: Port CG_GlassShatter_Old
    portMissing("CG_GlassShatter_Old", source: "oracle/codemp/cgame/cg_effects.c:674")
}

/// Source: oracle/codemp/cgame/cg_effects.c:771
func CG_CreateDebris(_ entnum: Int32, _ org: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ debrissound: Int32, _ debrismodel: Int32) {
    // TODO: Port CG_CreateDebris
    portMissing("CG_CreateDebris", source: "oracle/codemp/cgame/cg_effects.c:771")
}

/// Source: oracle/codemp/cgame/cg_effects.c:919
func CG_ExplosionEffects(_ origin: JKAShared.vec3_t, _ intensity: Float, _ radius: Int32, _ time: Int32) {
    // TODO: Port CG_ExplosionEffects
    portMissing("CG_ExplosionEffects", source: "oracle/codemp/cgame/cg_effects.c:919")
}

/// Source: oracle/codemp/cgame/cg_effects.c:949
func CG_MiscModelExplosion(_ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ size: Int32, _ chunkType: JKAMP.material_t) {
    // TODO: Port CG_MiscModelExplosion
    portMissing("CG_MiscModelExplosion", source: "oracle/codemp/cgame/cg_effects.c:949")
}

/// Source: oracle/codemp/cgame/cg_effects.c:1061
func CG_Chunks(_ owner: Int32, _ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ speed: Float, _ numChunks: Int32, _ chunkType: JKAMP.material_t, _ customChunk: Int32, _ baseScale: Float) {
    // TODO: Port CG_Chunks
    portMissing("CG_Chunks", source: "oracle/codemp/cgame/cg_effects.c:1061")
}

/**
```
==================
CG_ScorePlum
==================
```
*/
/// Source: oracle/codemp/cgame/cg_effects.c:1261
func CG_ScorePlum(_ client: Int32, _ org: JKAShared.vec3_t, _ score: Int32) {
    // TODO: Port CG_ScorePlum
    portMissing("CG_ScorePlum", source: "oracle/codemp/cgame/cg_effects.c:1261")
}

/**
```
====================
CG_MakeExplosion
====================
```
*/
/// Source: oracle/codemp/cgame/cg_effects.c:1306
func CG_MakeExplosion(_ origin: JKAShared.vec3_t, _ dir: JKAShared.vec3_t, _ hModel: JKAShared.qhandle_t, _ numFrames: Int32, _ shader: JKAShared.qhandle_t, _ msec: Int32, _ isSprite: Bool, _ scale: Float, _ flags: Int32) -> LocalEntity? {
    // TODO: Port CG_MakeExplosion
    portMissing("CG_MakeExplosion", source: "oracle/codemp/cgame/cg_effects.c:1306")
}

/// Source: oracle/codemp/cgame/cg_effects.c:1388
func CG_SurfaceExplosion(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t, _ radius: Float, _ shake_speed: Float, _ smoke: Bool) {
    // TODO: Port CG_SurfaceExplosion
    portMissing("CG_SurfaceExplosion", source: "oracle/codemp/cgame/cg_effects.c:1388")
}

/**
```
=================
CG_Bleed

This is the spurt of blood when a character gets hit
=================
```
*/
/// Source: oracle/codemp/cgame/cg_effects.c:1489
func CG_Bleed(_ origin: JKAShared.vec3_t, _ entityNum: Int32) {
    // TODO: Port CG_Bleed
    portMissing("CG_Bleed", source: "oracle/codemp/cgame/cg_effects.c:1489")
}

/**
```
==================
CG_LaunchGib
==================
```
*/
/// Source: oracle/codemp/cgame/cg_effects.c:1522
func CG_LaunchGib(_ origin: JKAShared.vec3_t, _ velocity: JKAShared.vec3_t, _ hModel: JKAShared.qhandle_t) {
    // TODO: Port CG_LaunchGib
    portMissing("CG_LaunchGib", source: "oracle/codemp/cgame/cg_effects.c:1522")
}
