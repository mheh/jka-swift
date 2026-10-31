import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/cg_players.c:20
let TURN_ON = 0x00000000 as Int32

/// Source: oracle/codemp/cgame/cg_players.c:21
let TURN_OFF = 0x00000100 as Int32

/// Source: oracle/codemp/cgame/cg_players.c:25
/// Raven's data table, a hand property of `CGameWorld`.
var cg_customSoundNames: [String?] { world.cg_customSoundNames }

/// Source: oracle/codemp/cgame/cg_players.c:47
/// Raven's data table, a hand property of `CGameWorld`.
var cg_customCombatSoundNames: [String?] { world.cg_customCombatSoundNames }

/// Source: oracle/codemp/cgame/cg_players.c:71
/// Raven's data table, a hand property of `CGameWorld`.
var cg_customExtraSoundNames: [String?] { world.cg_customExtraSoundNames }

/// Source: oracle/codemp/cgame/cg_players.c:114
/// Raven's data table, a hand property of `CGameWorld`.
var cg_customJediSoundNames: [String?] { world.cg_customJediSoundNames }

/// Source: oracle/codemp/cgame/cg_players.c:142
/// Raven's data table, a hand property of `CGameWorld`.
var cg_customDuelSoundNames: [String?] { world.cg_customDuelSoundNames }

/// Source: oracle/codemp/cgame/cg_players.c:313
let MAX_SURF_LIST_SIZE = 1024 as Int32

/// Source: oracle/codemp/cgame/cg_players.c:797
let DEFAULT_FEMALE_SOUNDPATH = "chars/mp_generic_female/misc"

/// Source: oracle/codemp/cgame/cg_players.c:798
let DEFAULT_MALE_SOUNDPATH = "chars/mp_generic_male/misc"

/// Source: oracle/codemp/cgame/cg_players.c:1945
var cgQueueLoad: Bool {
    get { world.variables.cgQueueLoad }
    set { world.variables.cgQueueLoad = newValue }
}

/// Source: oracle/codemp/cgame/cg_players.c:1988
let FOOTSTEP_DISTANCE = 32 as Int32

/// Source: oracle/codemp/cgame/cg_players.c:3440
/// Raven's data table, a hand property of `CGameWorld`.
var cg_effectorStringTable: [String?] { world.cg_effectorStringTable }

/// Source: oracle/codemp/cgame/cg_players.c:4611
let SHADOW_DISTANCE = 128 as Int32

/// Source: oracle/codemp/cgame/cg_players.c:4797
let REFRACT_EFFECT_DURATION = 500 as Int32

/// Source: oracle/codemp/cgame/cg_players.c:4945
/// Raven's data table, a hand property of `CGameWorld`.
var cg_pushBoneNames: [String?] { world.cg_pushBoneNames }

/// Source: oracle/codemp/cgame/cg_players.c:5073
let MAX_SHIELD_TIME = 2000.0 as Double

/// Source: oracle/codemp/cgame/cg_players.c:5074
let MIN_SHIELD_TIME = 2000.0 as Double

/// Source: oracle/codemp/cgame/cg_players.c:5458
private let MAX_MARK_FRAGMENTS = 128 as Int32

/// Source: oracle/codemp/cgame/cg_players.c:5459
private let MAX_MARK_POINTS = 384 as Int32

/// Source: oracle/codemp/cgame/cg_players.c:5736
let CG_MAX_SABER_COMP_TIME = 400 as Int32

/// Source: oracle/codemp/cgame/cg_players.c:5986
let SABER_TRAIL_TIME = 40.0 as Float

/// Source: oracle/codemp/cgame/cg_players.c:5987
private let FX_USE_ALPHA = 0x08000000 as Int32

/// Source: oracle/codemp/cgame/cg_players.c:6520
let SPEED_TRAIL_DISTANCE = 6 as Int32

/// Source: oracle/codemp/cgame/cg_players.c:7887
var cg_g2JetpackInstance: OpaquePointer? {
    get { world.variables.cg_g2JetpackInstance }
    set { world.variables.cg_g2JetpackInstance = newValue }
}

/// Source: oracle/codemp/cgame/cg_players.c:7889
let JETPACK_MODEL = "models/weapons2/jetpack/model.glm"

/// Source: oracle/codemp/cgame/cg_players.c:7922
let RARMBIT = (1 << (JKAMP.G2_MODELPART_RARM - 10))

/// Source: oracle/codemp/cgame/cg_players.c:7923
let RHANDBIT = (1 << (JKAMP.G2_MODELPART_RHAND - 10))

/// Source: oracle/codemp/cgame/cg_players.c:7924
let WAISTBIT = (1 << (JKAMP.G2_MODELPART_WAIST - 10))

/// Source: oracle/codemp/cgame/cg_players.c:7978
/// Raven's data table, a hand property of `CGameWorld`.
var lastFlyBySound: [Int32] {
    get { world.lastFlyBySound }
    set { world.lastFlyBySound = newValue }
}

/// Source: oracle/codemp/cgame/cg_players.c:7979
let FLYBYSOUNDTIME = 2000 as Int32

/// Source: oracle/codemp/cgame/cg_players.c:7980
var cg_lastHyperSpaceEffectTime: Int32 {
    get { world.variables.cg_lastHyperSpaceEffectTime }
    set { world.variables.cg_lastHyperSpaceEffectTime = newValue }
}

/// Source: oracle/codemp/cgame/cg_players.c:8338
var cg_vehThirdPersonAlpha: Float {
    get { world.variables.cg_vehThirdPersonAlpha }
    set { world.variables.cg_vehThirdPersonAlpha = newValue }
}

/**
```
================
CG_CustomSound

================
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:170
func CG_CustomSound(_ clientNum: Int32, _ soundName: String) -> JKAShared.sfxHandle_t {
    // TODO: Port CG_CustomSound
    portMissing("CG_CustomSound", source: "oracle/codemp/cgame/cg_players.c:170")
}

/// Source: oracle/codemp/cgame/cg_players.c:314
func CG_ParseSurfsFile(_ modelName: String, _ skinName: String, _ surfOff: inout JKAShared.CharBuf, _ surfOn: inout JKAShared.CharBuf) -> Bool {
    // TODO: Port CG_ParseSurfsFile
    portMissing("CG_ParseSurfsFile", source: "oracle/codemp/cgame/cg_players.c:314")
}

/// Source: oracle/codemp/cgame/cg_players.c:421
private func CG_RegisterClientModelname(_ ci: ClientInfo, _ modelName: String, _ skinName: String, _ teamName: String, _ clientNum: Int32) -> Bool {
    // TODO: Port CG_RegisterClientModelname
    portMissing("CG_RegisterClientModelname", source: "oracle/codemp/cgame/cg_players.c:421")
}

/**
```
====================
CG_ColorFromString
====================
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:701
private func CG_ColorFromString(_ v: String, _ color: inout JKAShared.vec3_t) {
    // TODO: Port CG_ColorFromString
    portMissing("CG_ColorFromString", source: "oracle/codemp/cgame/cg_players.c:701")
}

/**
```
====================
CG_ColorFromInt
====================
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:729
private func CG_ColorFromInt(_ val: Int32, _ color: inout JKAShared.vec3_t) {
    // TODO: Port CG_ColorFromInt
    portMissing("CG_ColorFromInt", source: "oracle/codemp/cgame/cg_players.c:729")
}

//load anim info
/// Source: oracle/codemp/cgame/cg_players.c:749
func CG_G2SkelForModel(_ g2: OpaquePointer?) -> Int32 {
    // TODO: Port CG_G2SkelForModel
    portMissing("CG_G2SkelForModel", source: "oracle/codemp/cgame/cg_players.c:749")
}

//get the appropriate anim events file index
/// Source: oracle/codemp/cgame/cg_players.c:770
func CG_G2EvIndexForModel(_ g2: OpaquePointer?, _ animIndex: Int32) -> Int32 {
    // TODO: Port CG_G2EvIndexForModel
    portMissing("CG_G2EvIndexForModel", source: "oracle/codemp/cgame/cg_players.c:770")
}

/// Source: oracle/codemp/cgame/cg_players.c:799
func CG_LoadCISounds(_ ci: ClientInfo, _ modelloaded: Bool) {
    // TODO: Port CG_LoadCISounds
    portMissing("CG_LoadCISounds", source: "oracle/codemp/cgame/cg_players.c:799")
}

/**
```
===================
CG_LoadClientInfo

Load it now, taking the disk hits.
This will usually be deferred to a safe time
===================
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:1006
func CG_LoadClientInfo(_ ci: ClientInfo) {
    // TODO: Port CG_LoadClientInfo
    portMissing("CG_LoadClientInfo", source: "oracle/codemp/cgame/cg_players.c:1006")
}

//Take care of initializing all the ghoul2 saber stuff based on clientinfo data. -rww
/// Source: oracle/codemp/cgame/cg_players.c:1151
private func CG_InitG2SaberData(_ saberNum: Int32, _ ci: ClientInfo) {
    // TODO: Port CG_InitG2SaberData
    portMissing("CG_InitG2SaberData", source: "oracle/codemp/cgame/cg_players.c:1151")
}

/**
```
======================
CG_CopyClientInfoModel
======================
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:1211
private func CG_CopyClientInfoModel(_ from: ClientInfo, _ to: ClientInfo) {
    // TODO: Port CG_CopyClientInfoModel
    portMissing("CG_CopyClientInfoModel", source: "oracle/codemp/cgame/cg_players.c:1211")
}

/**
```
======================
CG_ScanForExistingClientInfo
======================
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:1288
private func CG_ScanForExistingClientInfo(_ ci: ClientInfo, _ clientNum: Int32) -> Bool {
    // TODO: Port CG_ScanForExistingClientInfo
    portMissing("CG_ScanForExistingClientInfo", source: "oracle/codemp/cgame/cg_players.c:1288")
}

/**
```
======================
CG_SetDeferredClientInfo

We aren't going to load it now, so grab some other
client's info to use until we have some spare time.
======================
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:1397
private func CG_SetDeferredClientInfo(_ ci: ClientInfo) {
    // TODO: Port CG_SetDeferredClientInfo
    portMissing("CG_SetDeferredClientInfo", source: "oracle/codemp/cgame/cg_players.c:1397")
}

/// Source: oracle/codemp/cgame/cg_players.c:1503
func CG_NewClientInfo(_ clientNum: Int32, _ entitiesInitialized: Bool) {
    // TODO: Port CG_NewClientInfo
    portMissing("CG_NewClientInfo", source: "oracle/codemp/cgame/cg_players.c:1503")
}

/**
```
======================
CG_ActualLoadDeferredPlayers

Called at the beginning of CG_Player if cgQueueLoad is set.
======================
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:1953
func CG_ActualLoadDeferredPlayers() {
    // TODO: Port CG_ActualLoadDeferredPlayers
    portMissing("CG_ActualLoadDeferredPlayers", source: "oracle/codemp/cgame/cg_players.c:1953")
}

/**
```
======================
CG_LoadDeferredPlayers

Called each frame when a player is dead
and the scoreboard is up
so deferred players can be loaded
======================
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:1976
func CG_LoadDeferredPlayers() {
    // TODO: Port CG_LoadDeferredPlayers
    portMissing("CG_LoadDeferredPlayers", source: "oracle/codemp/cgame/cg_players.c:1976")
}

/// Source: oracle/codemp/cgame/cg_players.c:1989
private func _PlayerFootStep(_ origin: JKAShared.vec3_t, _ orientation: Float, _ radius: Float, _ cent: Centity, _ footStepType: JKAShared.footstepType_t) {
    // TODO: Port _PlayerFootStep
    portMissing("_PlayerFootStep", source: "oracle/codemp/cgame/cg_players.c:1989")
}

/// Source: oracle/codemp/cgame/cg_players.c:2183
private func CG_PlayerFootsteps(_ cent: Centity, _ footStepType: JKAShared.footstepType_t) {
    // TODO: Port CG_PlayerFootsteps
    portMissing("CG_PlayerFootsteps", source: "oracle/codemp/cgame/cg_players.c:2183")
}

/// Source: oracle/codemp/cgame/cg_players.c:2237
func CG_PlayerAnimEventDo(_ cent: Centity, _ animEvent: JKAMP.Animevent) {
    // TODO: Port CG_PlayerAnimEventDo
    portMissing("CG_PlayerAnimEventDo", source: "oracle/codemp/cgame/cg_players.c:2237")
}

/**
```
void CG_PlayerAnimEvents( int animFileIndex, int eventFileIndex, qboolean torso, int oldFrame, int frame, const vec3_t org, int entNum )

play any keyframed sounds - only when start a new frame
This func is called once for legs and once for torso
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:2461
func CG_PlayerAnimEvents(_ animFileIndex: Int32, _ eventFileIndex: Int32, _ torso: Bool, _ oldFrame: Int32, _ frame: Int32, _ entNum: Int32) {
    // TODO: Port CG_PlayerAnimEvents
    portMissing("CG_PlayerAnimEvents", source: "oracle/codemp/cgame/cg_players.c:2461")
}

/// Source: oracle/codemp/cgame/cg_players.c:2676
func CG_TriggerAnimSounds(_ cent: Centity) {
    // TODO: Port CG_TriggerAnimSounds
    portMissing("CG_TriggerAnimSounds", source: "oracle/codemp/cgame/cg_players.c:2676")
}

/// Source: oracle/codemp/cgame/cg_players.c:2721
func CG_InRoll(_ cent: Centity) -> Bool {
    // TODO: Port CG_InRoll
    portMissing("CG_InRoll", source: "oracle/codemp/cgame/cg_players.c:2721")
}

/// Source: oracle/codemp/cgame/cg_players.c:2746
func CG_InRollAnim(_ cent: Centity) -> Bool {
    // TODO: Port CG_InRollAnim
    portMissing("CG_InRollAnim", source: "oracle/codemp/cgame/cg_players.c:2746")
}

/// Source: oracle/codemp/cgame/cg_players.c:2768
private func CG_SetLerpFrameAnimation(_ cent: Centity, _ ci: ClientInfo, _ lf: LerpFrame, _ newAnimation: Int32, _ animSpeedMult: Float, _ torsoOnly: Bool, _ flipState: Bool) {
    // TODO: Port CG_SetLerpFrameAnimation
    portMissing("CG_SetLerpFrameAnimation", source: "oracle/codemp/cgame/cg_players.c:2768")
}

/**
```
===============
CG_FirstAnimFrame

Returns true if the lerpframe is on its first frame of animation.
Otherwise false.

This is used to scale an animation into higher-speed without restarting
the animation before it completes at normal speed, in the case of a looping
animation (such as the leg running anim).
===============
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:3144
private func CG_FirstAnimFrame(_ lf: LerpFrame, _ torsoOnly: Bool, _ speedScale: Float) -> Bool {
    // TODO: Port CG_FirstAnimFrame
    portMissing("CG_FirstAnimFrame", source: "oracle/codemp/cgame/cg_players.c:3144")
}

/**
```
===============
CG_RunLerpFrame

Sets cg.snap, cg.oldFrame, and cg.backlerp
cg.time should be between oldFrameTime and frameTime after exit
===============
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:3185
private func CG_RunLerpFrame(_ cent: Centity, _ ci: ClientInfo, _ lf: LerpFrame, _ flipState: Bool, _ newAnimation: Int32, _ speedScale: Float, _ torsoOnly: Bool) {
    // TODO: Port CG_RunLerpFrame
    portMissing("CG_RunLerpFrame", source: "oracle/codemp/cgame/cg_players.c:3185")
}

/**
```
===============
CG_ClearLerpFrame
===============
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:3243
private func CG_ClearLerpFrame(_ cent: Centity, _ ci: ClientInfo, _ lf: LerpFrame, _ animationNumber: Int32, _ torsoOnly: Bool) {
    // TODO: Port CG_ClearLerpFrame
    portMissing("CG_ClearLerpFrame", source: "oracle/codemp/cgame/cg_players.c:3243")
}

/// Source: oracle/codemp/cgame/cg_players.c:3267
private func CG_PlayerAnimation(_ cent: Centity, _ legsOld: inout Int32, _ legs: inout Int32, _ legsBackLerp: inout Float, _ torsoOld: inout Int32, _ torso: inout Int32, _ torsoBackLerp: inout Float) {
    // TODO: Port CG_PlayerAnimation
    portMissing("CG_PlayerAnimation", source: "oracle/codemp/cgame/cg_players.c:3267")
}

/// Source: oracle/codemp/cgame/cg_players.c:3365
func CG_G2SetBoneAngles(_ ghoul2: OpaquePointer?, _ modelIndex: Int32, _ boneName: String, _ angles: JKAShared.vec3_t, _ flags: Int32, _ up: Int32, _ right: Int32, _ forward: Int32, _ modelList: Slots<qhandle_t>?, _ blendTime: Int32, _ currentTime: Int32) {
    // TODO: Port CG_G2SetBoneAngles
    portMissing("CG_G2SetBoneAngles", source: "oracle/codemp/cgame/cg_players.c:3365")
}

/**
```
================
CG_Rag_Trace

Variant on CG_Trace. Doesn't trace for ents because ragdoll engine trace code has no entity
trace access. Maybe correct this sometime, so bmodel col. at least works with ragdoll.
But I don't want to slow it down..
================
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:3407
func CG_Rag_Trace(_ result: JKAMP.Trace, _ start: JKAShared.vec3_t, _ mins: JKAShared.vec3_t?, _ maxs: JKAShared.vec3_t?, _ end: JKAShared.vec3_t, _ skipNumber: Int32, _ mask: Int32) {
    // TODO: Port CG_Rag_Trace
    portMissing("CG_Rag_Trace", source: "oracle/codemp/cgame/cg_players.c:3407")
}

//we want to see which way the pelvis is facing to get a relatively oriented base settling frame
//this is to avoid the arms stretching in opposite directions on the body trying to reach the base
//pose if the pelvis is flipped opposite of the base pose or something -rww
/// Source: oracle/codemp/cgame/cg_players.c:3460
private func CG_RagAnimForPositioning(_ cent: Centity) -> Int32 {
    // TODO: Port CG_RagAnimForPositioning
    portMissing("CG_RagAnimForPositioning", source: "oracle/codemp/cgame/cg_players.c:3460")
}

//rww - cgame interface for the ragdoll stuff.
//Returns qtrue if the entity is now in a ragdoll state, otherwise qfalse.
/// Source: oracle/codemp/cgame/cg_players.c:3486
func CG_RagDoll(_ cent: Centity, _ forcedAngles: JKAShared.vec3_t) -> Bool {
    // TODO: Port CG_RagDoll
    portMissing("CG_RagDoll", source: "oracle/codemp/cgame/cg_players.c:3486")
}

//set the bone angles of this client entity based on data from the server -rww
/// Source: oracle/codemp/cgame/cg_players.c:3914
func CG_G2ServerBoneAngles(_ cent: Centity) {
    // TODO: Port CG_G2ServerBoneAngles
    portMissing("CG_G2ServerBoneAngles", source: "oracle/codemp/cgame/cg_players.c:3914")
}

/**
```
-------------------------
CG_G2SetHeadBlink
-------------------------
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:3969
private func CG_G2SetHeadBlink(_ cent: Centity, _ bStart: Bool) {
    // TODO: Port CG_G2SetHeadBlink
    portMissing("CG_G2SetHeadBlink", source: "oracle/codemp/cgame/cg_players.c:3969")
}

/**
```
-------------------------
CG_G2SetHeadAnims
-------------------------
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:4013
private func CG_G2SetHeadAnim(_ cent: Centity, _ anim: Int32) {
    // TODO: Port CG_G2SetHeadAnim
    portMissing("CG_G2SetHeadAnim", source: "oracle/codemp/cgame/cg_players.c:4013")
}

/// Source: oracle/codemp/cgame/cg_players.c:4059
func CG_G2PlayerHeadAnims(_ cent: Centity) -> Bool {
    // TODO: Port CG_G2PlayerHeadAnims
    portMissing("CG_G2PlayerHeadAnims", source: "oracle/codemp/cgame/cg_players.c:4059")
}

/// Source: oracle/codemp/cgame/cg_players.c:4192
private func CG_G2PlayerAngles(_ cent: Centity, _ legs: inout [JKAShared.vec3_t], _ legsAngles: inout JKAShared.vec3_t) {
    // TODO: Port CG_G2PlayerAngles
    portMissing("CG_G2PlayerAngles", source: "oracle/codemp/cgame/cg_players.c:4192")
}

/**
```
===============
CG_PlayerFlag
===============
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:4367
private func CG_PlayerFlag(_ cent: Centity, _ hModel: JKAShared.qhandle_t) {
    // TODO: Port CG_PlayerFlag
    portMissing("CG_PlayerFlag", source: "oracle/codemp/cgame/cg_players.c:4367")
}

/**
```
===============
CG_PlayerPowerups
===============
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:4449
private func CG_PlayerPowerups(_ cent: Centity, _ torso: JKAMP.RefEntity) {
    // TODO: Port CG_PlayerPowerups
    portMissing("CG_PlayerPowerups", source: "oracle/codemp/cgame/cg_players.c:4449")
}

/**
```
===============
CG_PlayerFloatSprite

Float a sprite over the player's head
===============
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:4505
private func CG_PlayerFloatSprite(_ cent: Centity, _ shader: JKAShared.qhandle_t) {
    // TODO: Port CG_PlayerFloatSprite
    portMissing("CG_PlayerFloatSprite", source: "oracle/codemp/cgame/cg_players.c:4505")
}

/**
```
===============
CG_PlayerSprites

Float sprites over the player's head
===============
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:4572
private func CG_PlayerSprites(_ cent: Centity) {
    // TODO: Port CG_PlayerSprites
    portMissing("CG_PlayerSprites", source: "oracle/codemp/cgame/cg_players.c:4572")
}

/// Source: oracle/codemp/cgame/cg_players.c:4612
private func CG_PlayerShadow(_ cent: Centity, _ shadowPlane: inout Float) -> Bool {
    // TODO: Port CG_PlayerShadow
    portMissing("CG_PlayerShadow", source: "oracle/codemp/cgame/cg_players.c:4612")
}

/**
```
===============
CG_PlayerSplash

Draw a mark at the water surface
===============
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:4717
private func CG_PlayerSplash(_ cent: Centity) {
    // TODO: Port CG_PlayerSplash
    portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
}

/// Source: oracle/codemp/cgame/cg_players.c:4798
private func CG_ForcePushBlur(_ org: JKAShared.vec3_t, _ cent: Centity?) {
    // TODO: Port CG_ForcePushBlur
    portMissing("CG_ForcePushBlur", source: "oracle/codemp/cgame/cg_players.c:4798")
}

/// Source: oracle/codemp/cgame/cg_players.c:4958
private func CG_ForcePushBodyBlur(_ cent: Centity) {
    // TODO: Port CG_ForcePushBodyBlur
    portMissing("CG_ForcePushBodyBlur", source: "oracle/codemp/cgame/cg_players.c:4958")
}

/// Source: oracle/codemp/cgame/cg_players.c:5000
private func CG_ForceGripEffect(_ org: JKAShared.vec3_t) {
    // TODO: Port CG_ForceGripEffect
    portMissing("CG_ForceGripEffect", source: "oracle/codemp/cgame/cg_players.c:5000")
}

/**
```
===============
CG_AddRefEntityWithPowerups

Adds a piece with modifications or duplications for powerups
Also called by CG_Missile for quad rockets, but nobody can tell...
===============
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:5059
func CG_AddRefEntityWithPowerups(_ ent: JKAMP.RefEntity, _ state: JKAMP.EntityState, _ team: Int32) {
    // TODO: Port CG_AddRefEntityWithPowerups
    portMissing("CG_AddRefEntityWithPowerups", source: "oracle/codemp/cgame/cg_players.c:5059")
}

/// Source: oracle/codemp/cgame/cg_players.c:5077
func CG_PlayerShieldHit(_ entitynum: Int32, _ dir: inout JKAShared.vec3_t, _ amount: Int32) {
    // TODO: Port CG_PlayerShieldHit
    portMissing("CG_PlayerShieldHit", source: "oracle/codemp/cgame/cg_players.c:5077")
}

/// Source: oracle/codemp/cgame/cg_players.c:5107
func CG_DrawPlayerShield(_ cent: Centity, _ origin: JKAShared.vec3_t) {
    // TODO: Port CG_DrawPlayerShield
    portMissing("CG_DrawPlayerShield", source: "oracle/codemp/cgame/cg_players.c:5107")
}

/// Source: oracle/codemp/cgame/cg_players.c:5145
func CG_PlayerHitFX(_ cent: Centity) {
    // TODO: Port CG_PlayerHitFX
    portMissing("CG_PlayerHitFX", source: "oracle/codemp/cgame/cg_players.c:5145")
}

/**
```
=================
CG_LightVerts
=================
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:5167
func CG_LightVerts(_ normal: JKAShared.vec3_t, _ numVerts: Int32, _ verts: Slots<JKAMP.PolyVert>) -> Int32 {
    // TODO: Port CG_LightVerts
    portMissing("CG_LightVerts", source: "oracle/codemp/cgame/cg_players.c:5167")
}

/// Source: oracle/codemp/cgame/cg_players.c:5209
private func CG_RGBForSaberColor(_ color: JKAMP.saber_colors_t, _ rgb: inout JKAShared.vec3_t) {
    // TODO: Port CG_RGBForSaberColor
    portMissing("CG_RGBForSaberColor", source: "oracle/codemp/cgame/cg_players.c:5209")
}

/// Source: oracle/codemp/cgame/cg_players.c:5234
private func CG_DoSaberLight(_ saber: JKAMP.SaberInfo) {
    // TODO: Port CG_DoSaberLight
    portMissing("CG_DoSaberLight", source: "oracle/codemp/cgame/cg_players.c:5234")
}

/// Source: oracle/codemp/cgame/cg_players.c:5320
func CG_DoSaber(_ origin: JKAShared.vec3_t, _ dir: JKAShared.vec3_t, _ length: Float, _ lengthMax: Float, _ radius: Float, _ color: JKAMP.saber_colors_t, _ rfx: Int32, _ doLight: Bool) {
    // TODO: Port CG_DoSaber
    portMissing("CG_DoSaber", source: "oracle/codemp/cgame/cg_players.c:5320")
}

//--------------------------------------------------------------
// CG_GetTagWorldPosition
//
// Can pass in NULL for the axis
//--------------------------------------------------------------
/// Source: oracle/codemp/cgame/cg_players.c:5437
func CG_GetTagWorldPosition(_ model: JKAMP.RefEntity, _ tag: String, _ pos: inout JKAShared.vec3_t, _ axis: inout [JKAShared.vec3_t]) {
    // TODO: Port CG_GetTagWorldPosition
    portMissing("CG_GetTagWorldPosition", source: "oracle/codemp/cgame/cg_players.c:5437")
}

/// Source: oracle/codemp/cgame/cg_players.c:5462
func CG_CreateSaberMarks(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ normal: JKAShared.vec3_t) {
    // TODO: Port CG_CreateSaberMarks
    portMissing("CG_CreateSaberMarks", source: "oracle/codemp/cgame/cg_players.c:5462")
}

/// Source: oracle/codemp/cgame/cg_players.c:5632
func CG_G2TraceCollide(_ tr: JKAMP.Trace, _ mins: JKAShared.vec3_t?, _ maxs: JKAShared.vec3_t?, _ lastValidStart: JKAShared.vec3_t, _ lastValidEnd: JKAShared.vec3_t) -> Bool {
    // TODO: Port CG_G2TraceCollide
    portMissing("CG_G2TraceCollide", source: "oracle/codemp/cgame/cg_players.c:5632")
}

/// Source: oracle/codemp/cgame/cg_players.c:5691
func CG_G2SaberEffects(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ owner: Centity) {
    // TODO: Port CG_G2SaberEffects
    portMissing("CG_G2SaberEffects", source: "oracle/codemp/cgame/cg_players.c:5691")
}

/// Source: oracle/codemp/cgame/cg_players.c:5738
func CG_AddGhoul2Mark(_ shader: Int32, _ size: Float, _ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ entnum: Int32, _ entposition: JKAShared.vec3_t, _ entangle: Float, _ ghoul2: OpaquePointer?, _ scale: inout JKAShared.vec3_t, _ lifeTime: Int32) {
    // TODO: Port CG_AddGhoul2Mark
    portMissing("CG_AddGhoul2Mark", source: "oracle/codemp/cgame/cg_players.c:5738")
}

/// Source: oracle/codemp/cgame/cg_players.c:5798
func CG_SaberCompWork(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ owner: Centity, _ saberNum: Int32, _ bladeNum: Int32) {
    // TODO: Port CG_SaberCompWork
    portMissing("CG_SaberCompWork", source: "oracle/codemp/cgame/cg_players.c:5798")
}

/// Source: oracle/codemp/cgame/cg_players.c:5993
func CG_AddSaberBlade(_ cent: Centity, _ scent: Centity, _ saber: JKAMP.RefEntity?, _ renderfx: Int32, _ modelIndex: Int32, _ saberNum: Int32, _ bladeNum: Int32, _ origin: JKAShared.vec3_t, _ angles: JKAShared.vec3_t, _ fromSaber: Bool, _ dontDraw: Bool) {
    // TODO: Port CG_AddSaberBlade
    portMissing("CG_AddSaberBlade", source: "oracle/codemp/cgame/cg_players.c:5993")
}

/// Source: oracle/codemp/cgame/cg_players.c:6482
func CG_IsMindTricked(_ trickIndex1: Int32, _ trickIndex2: Int32, _ trickIndex3: Int32, _ trickIndex4: Int32, _ client: Int32) -> Int32 {
    // TODO: Port CG_IsMindTricked
    portMissing("CG_IsMindTricked", source: "oracle/codemp/cgame/cg_players.c:6482")
}

/// Source: oracle/codemp/cgame/cg_players.c:6522
func CG_DrawPlayerSphere(_ cent: Centity, _ origin: JKAShared.vec3_t, _ scale: Float, _ shader: Int32) {
    // TODO: Port CG_DrawPlayerSphere
    portMissing("CG_DrawPlayerSphere", source: "oracle/codemp/cgame/cg_players.c:6522")
}

/// Source: oracle/codemp/cgame/cg_players.c:6628
func CG_AddLightningBeam(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t) {
    // TODO: Port CG_AddLightningBeam
    portMissing("CG_AddLightningBeam", source: "oracle/codemp/cgame/cg_players.c:6628")
}

/// Source: oracle/codemp/cgame/cg_players.c:6699
func CG_AddRandomLightning(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t) {
    // TODO: Port CG_AddRandomLightning
    portMissing("CG_AddRandomLightning", source: "oracle/codemp/cgame/cg_players.c:6699")
}

/// Source: oracle/codemp/cgame/cg_players.c:6744
func CG_ThereIsAMaster() -> Bool {
    // TODO: Port CG_ThereIsAMaster
    portMissing("CG_ThereIsAMaster", source: "oracle/codemp/cgame/cg_players.c:6744")
}

//Checks to see if the model string has a * appended with a custom skin name after.
//If so, it terminates the model string correctly, parses the skin name out, and returns
//the handle of the registered skin.
/// Source: oracle/codemp/cgame/cg_players.c:6817
func CG_HandleAppendedSkin(_ modelName: String) -> Int32 {
    // TODO: Port CG_HandleAppendedSkin
    portMissing("CG_HandleAppendedSkin", source: "oracle/codemp/cgame/cg_players.c:6817")
}

/// Source: oracle/codemp/cgame/cg_players.c:6876
func CG_CacheG2AnimInfo(_ modelName: String) {
    // TODO: Port CG_CacheG2AnimInfo
    portMissing("CG_CacheG2AnimInfo", source: "oracle/codemp/cgame/cg_players.c:6876")
}

/// Source: oracle/codemp/cgame/cg_players.c:6941
private func CG_RegisterVehicleAssets(_ pVeh: JKAMP.Vehicle) {
    // TODO: Port CG_RegisterVehicleAssets
    portMissing("CG_RegisterVehicleAssets", source: "oracle/codemp/cgame/cg_players.c:6941")
}

/// Source: oracle/codemp/cgame/cg_players.c:6998
func CG_G2AnimEntModelLoad(_ cent: Centity) {
    // TODO: Port CG_G2AnimEntModelLoad
    portMissing("CG_G2AnimEntModelLoad", source: "oracle/codemp/cgame/cg_players.c:6998")
}

//for now this is just gonna create a big explosion on the area of the surface,
//because I am lazy.
/// Source: oracle/codemp/cgame/cg_players.c:7266
private func CG_CreateSurfaceDebris(_ cent: Centity, _ surfNum: Int32, _ fxID: Int32, _ throwPart: Bool) {
    // TODO: Port CG_CreateSurfaceDebris
    portMissing("CG_CreateSurfaceDebris", source: "oracle/codemp/cgame/cg_players.c:7266")
}

//for now this is just gonna create a big explosion on the area of the surface,
//because I am lazy.
/// Source: oracle/codemp/cgame/cg_players.c:7365
private func CG_CreateSurfaceSmoke(_ cent: Centity, _ shipSurf: Int32, _ fxID: Int32) {
    // TODO: Port CG_CreateSurfaceSmoke
    portMissing("CG_CreateSurfaceSmoke", source: "oracle/codemp/cgame/cg_players.c:7365")
}

/// Source: oracle/codemp/cgame/cg_players.c:7415
func CG_VehicleShouldDrawShields(_ vehCent: Centity) -> Bool {
    // TODO: Port CG_VehicleShouldDrawShields
    portMissing("CG_VehicleShouldDrawShields", source: "oracle/codemp/cgame/cg_players.c:7415")
}

/**
```
extern	vmCvar_t		cg_showVehBounds;
extern void BG_VehicleAdjustBBoxForOrientation( Vehicle_t *veh, vec3_t origin, vec3_t mins, vec3_t maxs,
										int clientNum, int tracemask,
										void (*localTrace)(trace_t *results, const vec3_t start, const vec3_t mins, const vec3_t maxs, const vec3_t end, int passEntityNum, int contentMask)); // bg_pmove.c
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:7433
func CG_VehicleAttachDroidUnit(_ droidCent: Centity, _ legs: JKAMP.RefEntity) -> Bool {
    // TODO: Port CG_VehicleAttachDroidUnit
    portMissing("CG_VehicleAttachDroidUnit", source: "oracle/codemp/cgame/cg_players.c:7433")
}

/// Source: oracle/codemp/cgame/cg_players.c:7463
func CG_G2Animated(_ cent: Centity) {
    // TODO: Port CG_G2Animated
    portMissing("CG_G2Animated", source: "oracle/codemp/cgame/cg_players.c:7463")
}

//for allocating and freeing npc clientinfo structures.
//Remember to free this before game shutdown no matter what
//and don't stomp over it, as it is dynamic memory from the
//exe.
/// Source: oracle/codemp/cgame/cg_players.c:7695
func CG_CreateNPCClient(_ ci: inout ClientInfo?) {
    // TODO: Port CG_CreateNPCClient
    portMissing("CG_CreateNPCClient", source: "oracle/codemp/cgame/cg_players.c:7695")
}

/// Source: oracle/codemp/cgame/cg_players.c:7701
func CG_DestroyNPCClient(_ ci: inout ClientInfo?) {
    // TODO: Port CG_DestroyNPCClient
    portMissing("CG_DestroyNPCClient", source: "oracle/codemp/cgame/cg_players.c:7701")
}

/// Source: oracle/codemp/cgame/cg_players.c:7707
private func CG_ForceElectrocution(_ cent: Centity, _ origin: JKAShared.vec3_t, _ tempAngles: JKAShared.vec3_t, _ shader: JKAShared.qhandle_t, _ alwaysDo: Bool) {
    // TODO: Port CG_ForceElectrocution
    portMissing("CG_ForceElectrocution", source: "oracle/codemp/cgame/cg_players.c:7707")
}

/// Source: oracle/codemp/cgame/cg_players.c:7891
func CG_InitJetpackGhoul2() {
    // TODO: Port CG_InitJetpackGhoul2
    portMissing("CG_InitJetpackGhoul2", source: "oracle/codemp/cgame/cg_players.c:7891")
}

/// Source: oracle/codemp/cgame/cg_players.c:7913
func CG_CleanJetpackGhoul2() {
    // TODO: Port CG_CleanJetpackGhoul2
    portMissing("CG_CleanJetpackGhoul2", source: "oracle/codemp/cgame/cg_players.c:7913")
}

/// Source: oracle/codemp/cgame/cg_players.c:7981
private func CG_VehicleEffects(_ cent: Centity) {
    // TODO: Port CG_VehicleEffects
    portMissing("CG_VehicleEffects", source: "oracle/codemp/cgame/cg_players.c:7981")
}

/// Source: oracle/codemp/cgame/cg_players.c:8316
func CG_RadiusForCent(_ cent: Centity) -> Float {
    // TODO: Port CG_RadiusForCent
    portMissing("CG_RadiusForCent", source: "oracle/codemp/cgame/cg_players.c:8316")
}

/// Source: oracle/codemp/cgame/cg_players.c:8341
func CG_CheckThirdPersonAlpha(_ cent: Centity, _ legs: JKAMP.RefEntity) {
    // TODO: Port CG_CheckThirdPersonAlpha
    portMissing("CG_CheckThirdPersonAlpha", source: "oracle/codemp/cgame/cg_players.c:8341")
}

/// Source: oracle/codemp/cgame/cg_players.c:8423
func CG_Player(_ cent: Centity) {
    // TODO: Port CG_Player
    portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
}

/**
```
===============
CG_ResetPlayerEntity

A player just came into view or teleported, so reset all animation info
===============
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:11119
func CG_ResetPlayerEntity(_ cent: Centity) {
    // TODO: Port CG_ResetPlayerEntity
    portMissing("CG_ResetPlayerEntity", source: "oracle/codemp/cgame/cg_players.c:11119")
}
