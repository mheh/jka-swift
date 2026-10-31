import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/cg_marks.c:16
var cg_activeMarkPolys: MarkPoly { world.storage.cg_activeMarkPolys }

/// Source: oracle/codemp/cgame/cg_marks.c:17
/// Raven walks `cg_freeMarkPolys` over `cg_markPolys`, so the port holds the index of the slot it points at.
var cg_freeMarkPolysIndex: Int32 {
    get { world.variables.cg_freeMarkPolysIndex }
    set { world.variables.cg_freeMarkPolysIndex = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:18
var cg_markPolys: Slots<MarkPoly> { world.storage.cg_markPolys }

/// Source: oracle/codemp/cgame/cg_marks.c:19
var markTotal: Int32 {
    get { world.variables.markTotal }
    set { world.variables.markTotal = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:107
private let MAX_MARK_FRAGMENTS = 128 as Int32

/// Source: oracle/codemp/cgame/cg_marks.c:108
private let MAX_MARK_POINTS = 384 as Int32

/// Source: oracle/codemp/cgame/cg_marks.c:218
let MARK_TOTAL_TIME = 10000 as Int32

/// Source: oracle/codemp/cgame/cg_marks.c:219
let MARK_FADE_TIME = 1000 as Int32

/// Source: oracle/codemp/cgame/cg_marks.c:296
let BLOODRED = 2 as Int32

/// Source: oracle/codemp/cgame/cg_marks.c:297
let EMISIVEFADE = 3 as Int32

/// Source: oracle/codemp/cgame/cg_marks.c:298
let GREY75 = 4 as Int32

/// Source: oracle/codemp/cgame/cg_marks.c:360
let MAX_SHADER_ANIMS = 32 as Int32

/// Source: oracle/codemp/cgame/cg_marks.c:361
let MAX_SHADER_ANIM_FRAMES = 64 as Int32

/// Source: oracle/codemp/cgame/cg_marks.c:363
/// Raven's data table, a hand property of `CGameWorld`.
var shaderAnimNames: [String?] { world.shaderAnimNames }

/// Source: oracle/codemp/cgame/cg_marks.c:367
// Raven wrote: static qhandle_t shaderAnims[MAX_SHADER_ANIMS][MAX_SHADER_ANIM_FRAMES]
let shaderAnims: [[JKAShared.qhandle_t]] = [[JKAShared.qhandle_t]](repeating: [JKAShared.qhandle_t](repeating: 0, count: 64), count: 32)

/// Source: oracle/codemp/cgame/cg_marks.c:368
// Raven wrote: static int shaderAnimCounts[MAX_SHADER_ANIMS]
let shaderAnimCounts: [Int32] = { () -> [Int32] in portMissing("shaderAnimCounts", source: "oracle/codemp/cgame/cg_marks.c:368") }()

/// Source: oracle/codemp/cgame/cg_marks.c:371
// Raven wrote: static float shaderAnimSTRatio[MAX_SHADER_ANIMS]
let shaderAnimSTRatio: [Float] = { () -> [Float] in portMissing("shaderAnimSTRatio", source: "oracle/codemp/cgame/cg_marks.c:371") }()

/// Source: oracle/codemp/cgame/cg_marks.c:374
var numShaderAnims: Int32 {
    get { world.variables.numShaderAnims }
    set { world.variables.numShaderAnims = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:377
let PARTICLE_GRAVITY = 40 as Int32

/// Source: oracle/codemp/cgame/cg_marks.c:378
let MAX_PARTICLES = 1024 as Int32

/// Source: oracle/codemp/cgame/cg_marks.c:380
var active_particles: Cparticle? {
    get { world.variables.active_particles }
    set { world.variables.active_particles = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:380
var free_particles: Cparticle? {
    get { world.variables.free_particles }
    set { world.variables.free_particles = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:381
var particles: Slots<Cparticle> { world.storage.particles }

/// Source: oracle/codemp/cgame/cg_marks.c:382
// Raven wrote: int cl_numparticles = MAX_PARTICLES
let cl_numparticles: Int32 = { () -> Int32 in portMissing("cl_numparticles", source: "oracle/codemp/cgame/cg_marks.c:382") }()

/// Source: oracle/codemp/cgame/cg_marks.c:384
var initparticles: Bool {
    get { world.variables.initparticles }
    set { world.variables.initparticles = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:385
var pvforward: JKAShared.vec3_t {
    get { world.variables.pvforward }
    set { world.variables.pvforward = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:385
var pvright: JKAShared.vec3_t {
    get { world.variables.pvright }
    set { world.variables.pvright = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:385
var pvup: JKAShared.vec3_t {
    get { world.variables.pvup }
    set { world.variables.pvup = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:386
var rforward: JKAShared.vec3_t {
    get { world.variables.rforward }
    set { world.variables.rforward = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:386
var rright: JKAShared.vec3_t {
    get { world.variables.rright }
    set { world.variables.rright = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:386
var rup: JKAShared.vec3_t {
    get { world.variables.rup }
    set { world.variables.rup = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:388
var oldtime: Float {
    get { world.variables.oldtime }
    set { world.variables.oldtime = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:1074
var roll: Float {
    get { world.variables.roll }
    set { world.variables.roll = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:1904
let EXTRUDE_DIST = 0.5 as Double

/// Source: oracle/codemp/cgame/cg_marks.c:2008
let NORMALSIZE = 16 as Int32

/// Source: oracle/codemp/cgame/cg_marks.c:2009
let LARGESIZE = 32 as Int32

/**
```
===================
CG_InitMarkPolys

This is called at startup and for tournement restarts
===================
```
*/
/// Source: oracle/codemp/cgame/cg_marks.c:28
func CG_InitMarkPolys() {
    // TODO: Port CG_InitMarkPolys
    portMissing("CG_InitMarkPolys", source: "oracle/codemp/cgame/cg_marks.c:28")
}

/**
```
==================
CG_FreeMarkPoly
==================
```
*/
/// Source: oracle/codemp/cgame/cg_marks.c:47
func CG_FreeMarkPoly(_ le: MarkPoly) {
    // TODO: Port CG_FreeMarkPoly
    portMissing("CG_FreeMarkPoly", source: "oracle/codemp/cgame/cg_marks.c:47")
}

/**
```
===================
CG_AllocMark

Will allways succeed, even if it requires freeing an old active mark
===================
```
*/
/// Source: oracle/codemp/cgame/cg_marks.c:68
func CG_AllocMark() -> MarkPoly? {
    // TODO: Port CG_AllocMark
    portMissing("CG_AllocMark", source: "oracle/codemp/cgame/cg_marks.c:68")
}

/// Source: oracle/codemp/cgame/cg_marks.c:110
func CG_ImpactMark(_ markShader: JKAShared.qhandle_t, _ origin: JKAShared.vec3_t, _ dir: JKAShared.vec3_t, _ orientation: Float, _ red: Float, _ green: Float, _ blue: Float, _ alpha: Float, _ alphaFade: Bool, _ radius: Float, _ temporary: Bool) {
    // TODO: Port CG_ImpactMark
    portMissing("CG_ImpactMark", source: "oracle/codemp/cgame/cg_marks.c:110")
}

/// Source: oracle/codemp/cgame/cg_marks.c:221
func CG_AddMarks() {
    // TODO: Port CG_AddMarks
    portMissing("CG_AddMarks", source: "oracle/codemp/cgame/cg_marks.c:221")
}

/**
```
===============
CL_ClearParticles
===============
```
*/
/// Source: oracle/codemp/cgame/cg_marks.c:395
func CG_ClearParticles() {
    // TODO: Port CG_ClearParticles
    portMissing("CG_ClearParticles", source: "oracle/codemp/cgame/cg_marks.c:395")
}

/**
```
=====================
CG_AddParticleToScene
=====================
```
*/
/// Source: oracle/codemp/cgame/cg_marks.c:436
func CG_AddParticleToScene(_ p: Cparticle, _ org: JKAShared.vec3_t, _ alpha: Float) {
    // TODO: Port CG_AddParticleToScene
    portMissing("CG_AddParticleToScene", source: "oracle/codemp/cgame/cg_marks.c:436")
}

/**
```
===============
CG_AddParticles
===============
```
*/
/// Source: oracle/codemp/cgame/cg_marks.c:1081
func CG_AddParticles() {
    // TODO: Port CG_AddParticles
    portMissing("CG_AddParticles", source: "oracle/codemp/cgame/cg_marks.c:1081")
}

/**
```
======================
CG_AddParticles
======================
```
*/
/// Source: oracle/codemp/cgame/cg_marks.c:1215
func CG_ParticleSnowFlurry(_ pshader: JKAShared.qhandle_t, _ cent: Centity) {
    // TODO: Port CG_ParticleSnowFlurry
    portMissing("CG_ParticleSnowFlurry", source: "oracle/codemp/cgame/cg_marks.c:1215")
}

/// Source: oracle/codemp/cgame/cg_marks.c:1283
func CG_ParticleSnow(_ pshader: JKAShared.qhandle_t, _ origin: JKAShared.vec3_t, _ origin2: JKAShared.vec3_t, _ turb: Int32, _ range: Float, _ snum: Int32) {
    // TODO: Port CG_ParticleSnow
    portMissing("CG_ParticleSnow", source: "oracle/codemp/cgame/cg_marks.c:1283")
}

/// Source: oracle/codemp/cgame/cg_marks.c:1340
func CG_ParticleBubble(_ pshader: JKAShared.qhandle_t, _ origin: JKAShared.vec3_t, _ origin2: JKAShared.vec3_t, _ turb: Int32, _ range: Float, _ snum: Int32) {
    // TODO: Port CG_ParticleBubble
    portMissing("CG_ParticleBubble", source: "oracle/codemp/cgame/cg_marks.c:1340")
}

/// Source: oracle/codemp/cgame/cg_marks.c:1401
func CG_ParticleSmoke(_ pshader: JKAShared.qhandle_t, _ cent: Centity) {
    // TODO: Port CG_ParticleSmoke
    portMissing("CG_ParticleSmoke", source: "oracle/codemp/cgame/cg_marks.c:1401")
}

/// Source: oracle/codemp/cgame/cg_marks.c:1449
func CG_ParticleBulletDebris(_ org: JKAShared.vec3_t, _ vel: JKAShared.vec3_t, _ duration: Int32) {
    // TODO: Port CG_ParticleBulletDebris
    portMissing("CG_ParticleBulletDebris", source: "oracle/codemp/cgame/cg_marks.c:1449")
}

/// Source: oracle/codemp/cgame/cg_marks.c:1496
func CG_ParticleExplosion(_ animStr: String, _ origin: JKAShared.vec3_t, _ vel: JKAShared.vec3_t, _ duration: Int32, _ sizeStart: Int32, _ sizeEnd: Int32) {
    // TODO: Port CG_ParticleExplosion
    portMissing("CG_ParticleExplosion", source: "oracle/codemp/cgame/cg_marks.c:1496")
}

// Rafael Shrapnel
/// Source: oracle/codemp/cgame/cg_marks.c:1550
func CG_AddParticleShrapnel(_ le: LocalEntity) {
    // TODO: Port CG_AddParticleShrapnel
    portMissing("CG_AddParticleShrapnel", source: "oracle/codemp/cgame/cg_marks.c:1550")
}

/// Source: oracle/codemp/cgame/cg_marks.c:1556
func CG_NewParticleArea(_ num: Int32) -> Int32 {
    // TODO: Port CG_NewParticleArea
    portMissing("CG_NewParticleArea", source: "oracle/codemp/cgame/cg_marks.c:1556")
}

/// Source: oracle/codemp/cgame/cg_marks.c:1629
func CG_SnowLink(_ cent: Centity, _ particleOn: Bool) {
    // TODO: Port CG_SnowLink
    portMissing("CG_SnowLink", source: "oracle/codemp/cgame/cg_marks.c:1629")
}

/// Source: oracle/codemp/cgame/cg_marks.c:1654
func CG_ParticleImpactSmokePuff(_ pshader: JKAShared.qhandle_t, _ origin: JKAShared.vec3_t) {
    // TODO: Port CG_ParticleImpactSmokePuff
    portMissing("CG_ParticleImpactSmokePuff", source: "oracle/codemp/cgame/cg_marks.c:1654")
}

/// Source: oracle/codemp/cgame/cg_marks.c:1694
func CG_Particle_Bleed(_ pshader: JKAShared.qhandle_t, _ start: JKAShared.vec3_t, _ dir: JKAShared.vec3_t, _ fleshEntityNum: Int32, _ duration: Int32) {
    // TODO: Port CG_Particle_Bleed
    portMissing("CG_Particle_Bleed", source: "oracle/codemp/cgame/cg_marks.c:1694")
}

/// Source: oracle/codemp/cgame/cg_marks.c:1744
func CG_Particle_OilParticle(_ pshader: JKAShared.qhandle_t, _ cent: Centity) {
    // TODO: Port CG_Particle_OilParticle
    portMissing("CG_Particle_OilParticle", source: "oracle/codemp/cgame/cg_marks.c:1744")
}

/// Source: oracle/codemp/cgame/cg_marks.c:1808
func CG_Particle_OilSlick(_ pshader: JKAShared.qhandle_t, _ cent: Centity) {
    // TODO: Port CG_Particle_OilSlick
    portMissing("CG_Particle_OilSlick", source: "oracle/codemp/cgame/cg_marks.c:1808")
}

/// Source: oracle/codemp/cgame/cg_marks.c:1874
func CG_OilSlickRemove(_ cent: Centity) {
    // TODO: Port CG_OilSlickRemove
    portMissing("CG_OilSlickRemove", source: "oracle/codemp/cgame/cg_marks.c:1874")
}

/// Source: oracle/codemp/cgame/cg_marks.c:1902
func ValidBloodPool(_ start: JKAShared.vec3_t) -> Bool {
    // TODO: Port ValidBloodPool
    portMissing("ValidBloodPool", source: "oracle/codemp/cgame/cg_marks.c:1902")
}

/// Source: oracle/codemp/cgame/cg_marks.c:1948
func CG_BloodPool(_ le: LocalEntity, _ pshader: JKAShared.qhandle_t, _ tr: JKAMP.Trace) {
    // TODO: Port CG_BloodPool
    portMissing("CG_BloodPool", source: "oracle/codemp/cgame/cg_marks.c:1948")
}

/// Source: oracle/codemp/cgame/cg_marks.c:2011
func CG_ParticleBloodCloud(_ cent: Centity, _ origin: JKAShared.vec3_t, _ dir: JKAShared.vec3_t) {
    // TODO: Port CG_ParticleBloodCloud
    portMissing("CG_ParticleBloodCloud", source: "oracle/codemp/cgame/cg_marks.c:2011")
}

/// Source: oracle/codemp/cgame/cg_marks.c:2088
func CG_ParticleSparks(_ org: JKAShared.vec3_t, _ vel: JKAShared.vec3_t, _ duration: Int32, _ x: Float, _ y: Float, _ speed: Float) {
    // TODO: Port CG_ParticleSparks
    portMissing("CG_ParticleSparks", source: "oracle/codemp/cgame/cg_marks.c:2088")
}

/// Source: oracle/codemp/cgame/cg_marks.c:2136
func CG_ParticleDust(_ cent: Centity, _ origin: JKAShared.vec3_t, _ dir: inout JKAShared.vec3_t) {
    // TODO: Port CG_ParticleDust
    portMissing("CG_ParticleDust", source: "oracle/codemp/cgame/cg_marks.c:2136")
}

/// Source: oracle/codemp/cgame/cg_marks.c:2232
func CG_ParticleMisc(_ pshader: JKAShared.qhandle_t, _ origin: JKAShared.vec3_t, _ size: Int32, _ duration: Int32, _ alpha: Float) {
    // TODO: Port CG_ParticleMisc
    portMissing("CG_ParticleMisc", source: "oracle/codemp/cgame/cg_marks.c:2232")
}
