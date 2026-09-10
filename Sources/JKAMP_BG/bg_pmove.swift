import JKAMP
import JKAShared

//rww - Get a pointer to the bgEntity by the index
/// Source: oracle/codemp/game/bg_pmove.c:172
func PM_BGEntForNum(_ num: Int32) -> JKAMP.BgEntity? {
    // Port-note: `pmove_t` has no generated view under `Sources/*/Generated/Views/`, so the `pm` pointer static has no Swift form.
    // TODO: Port PM_BGEntForNum
    portMissing("PM_BGEntForNum", source: "oracle/codemp/game/bg_pmove.c:172")
}

/// Source: oracle/codemp/game/bg_pmove.c:201
func BG_SabersOff(_ ps: JKAMP.PlayerState) -> Bool {
    if ps.saberHolstered == 0 {
        return false
    }
    if ps.fd.saberAnimLevelBase == SS_DUAL
        || ps.fd.saberAnimLevelBase == SS_STAFF {
        if ps.saberHolstered < 2 {
            return false
        }
    }
    return true
}

/// Source: oracle/codemp/game/bg_pmove.c:218
func BG_KnockDownable(_ ps: JKAMP.PlayerState) -> Bool {
    // Port-note: Raven's `if (!ps)` safety check has no Swift form, because the signature takes a non-optional `PlayerState`.
    if ps.m_iVehicleNum != 0 {
        //riding a vehicle, don't knock me down
        return false
    }

    if ps.emplacedIndex != 0 {
        //using emplaced gun or eweb, can't be knocked down
        return false
    }

    //ok, I guess?
    return true
}

//hacky assumption check, assume any client non-humanoid is a rocket trooper
/// Source: oracle/codemp/game/bg_pmove.c:247
func PM_IsRocketTrooper() -> Bool {
    /*
    if (pm->ps->clientNum < MAX_CLIENTS &&
        pm->gametype == GT_SIEGE &&
        pm->nonHumanoid)
    {
        return qtrue;
    }
    */

    return false
}

/// Source: oracle/codemp/game/bg_pmove.c:261
func PM_GetSaberStance() -> Int32 {
    // Port-note: `pmove_t` has no generated view, so `pm->ps` has no Swift form.
    // TODO: Port PM_GetSaberStance
    portMissing("PM_GetSaberStance", source: "oracle/codemp/game/bg_pmove.c:261")
}

/// Source: oracle/codemp/game/bg_pmove.c:321
func PM_DoSlowFall() -> Bool {
    // Port-note: `pmove_t` has no generated view, so `pm->ps` has no Swift form.
    // TODO: Port PM_DoSlowFall
    portMissing("PM_DoSlowFall", source: "oracle/codemp/game/bg_pmove.c:321")
}

/// Source: oracle/codemp/game/bg_pmove.c:346
func PM_pitch_roll_for_slope(_ forwhom: JKAMP.BgEntity, _ pass_slope: JKAShared.vec3_t, _ storeAngles: JKAShared.vec3_t) {
    // Port-note: `pmove_t` has no generated view, so `pm->ps`, `pm->mins`, and the `pm->trace` callback have no Swift form. The `storeAngles` out-param is not `inout` in the generated signature.
    // TODO: Port PM_pitch_roll_for_slope
    portMissing("PM_pitch_roll_for_slope", source: "oracle/codemp/game/bg_pmove.c:346")
}

/// Source: oracle/codemp/game/bg_pmove.c:447
func PM_SetSpecialMoveValues() {
    // Port-note: `pmove_t` has no generated view, so `pm->ps` has no Swift form.
    // TODO: Port PM_SetSpecialMoveValues
    portMissing("PM_SetSpecialMoveValues", source: "oracle/codemp/game/bg_pmove.c:447")
}

/// Source: oracle/codemp/game/bg_pmove.c:482
private func PM_SetVehicleAngles(_ normal: JKAShared.vec3_t) {
    // Port-note: `pmove_t` and `pml_t` have no generated views, so `pm` and `pml` have no Swift form.
    // TODO: Port PM_SetVehicleAngles
    portMissing("PM_SetVehicleAngles", source: "oracle/codemp/game/bg_pmove.c:482")
}

/// Source: oracle/codemp/game/bg_pmove.c:641
func BG_ExternThisSoICanRecompileInDebug(_ pVeh: JKAMP.Vehicle, _ riderPS: JKAMP.PlayerState) {
    // Port-note: `pmove_t` has no generated view, so `pm` has no Swift form.
    // TODO: Port BG_ExternThisSoICanRecompileInDebug
    portMissing("BG_ExternThisSoICanRecompileInDebug", source: "oracle/codemp/game/bg_pmove.c:641")
}

/// Source: oracle/codemp/game/bg_pmove.c:676
// TODO: Port signature
// Raven wrote: void BG_VehicleTurnRateForSpeed( Vehicle_t *pVeh, float speed, float *mPitchOverride, float *mYawOverride )
// No table row for `float * mPitchOverride`.
func BG_VehicleTurnRateForSpeed() -> Never {
    // Port-note: The generated signature is unmapped, because `float *mPitchOverride` and `float *mYawOverride` are out-params with no table row.
    // TODO: Port BG_VehicleTurnRateForSpeed
    portMissing("BG_VehicleTurnRateForSpeed", source: "oracle/codemp/game/bg_pmove.c:676")
}

/// Source: oracle/codemp/game/bg_pmove.c:719
func PM_HoverTrace() {
    // Port-note: `pmove_t` and `pml_t` have no generated views, so `pm` and `pml` have no Swift form.
    // TODO: Port PM_HoverTrace
    portMissing("PM_HoverTrace", source: "oracle/codemp/game/bg_pmove.c:719")
}

/**
===============
PM_AddEvent

===============
*/
/// Source: oracle/codemp/game/bg_pmove.c:910
func PM_AddEvent(_ newEvent: Int32) {
    // Port-note: `pmove_t` has no generated view, so `pm->ps` has no Swift form.
    // TODO: Port PM_AddEvent
    portMissing("PM_AddEvent", source: "oracle/codemp/game/bg_pmove.c:910")
}

/// Source: oracle/codemp/game/bg_pmove.c:914
func PM_AddEventWithParm(_ newEvent: Int32, _ parm: Int32) {
    // Port-note: `pmove_t` has no generated view, so `pm->ps` has no Swift form.
    // TODO: Port PM_AddEventWithParm
    portMissing("PM_AddEventWithParm", source: "oracle/codemp/game/bg_pmove.c:914")
}

/**
===============
PM_AddTouchEnt
===============
*/
/// Source: oracle/codemp/game/bg_pmove.c:924
func PM_AddTouchEnt(_ entityNum: Int32) {
    // Port-note: `pmove_t` has no generated view, so `pm->numtouch` and `pm->touchents` have no Swift form.
    // TODO: Port PM_AddTouchEnt
    portMissing("PM_AddTouchEnt", source: "oracle/codemp/game/bg_pmove.c:924")
}

/**
==================
PM_ClipVelocity

Slide off of the impacting surface
==================
*/
/// Source: oracle/codemp/game/bg_pmove.c:954
func PM_ClipVelocity(_ `in`: JKAShared.vec3_t, _ normal: JKAShared.vec3_t, _ out: JKAShared.vec3_t, _ overbounce: Float) {
    // Port-note: `pmove_t` has no generated view, so `pm->ps` and `pm->stepSlideFix` have no Swift form. The `out` parameter is not `inout` in the generated signature.
    // TODO: Port PM_ClipVelocity
    portMissing("PM_ClipVelocity", source: "oracle/codemp/game/bg_pmove.c:954")
}

/**
==================
PM_Friction

Handles both ground friction and water friction
==================
*/
/// Source: oracle/codemp/game/bg_pmove.c:998
private func PM_Friction() {
    // Port-note: `pmove_t` and `pml_t` have no generated views, so `pm` and `pml` have no Swift form.
    // TODO: Port PM_Friction
    portMissing("PM_Friction", source: "oracle/codemp/game/bg_pmove.c:998")
}

/**
==============
PM_Accelerate

Handles user intended acceleration
==============
*/
/// Source: oracle/codemp/game/bg_pmove.c:1133
private func PM_Accelerate(_ wishdir: JKAShared.vec3_t, _ wishspeed: Float, _ accel: Float) {
    // Port-note: `pmove_t` and `pml_t` have no generated views, so `pm` and `pml` have no Swift form.
    // TODO: Port PM_Accelerate
    portMissing("PM_Accelerate", source: "oracle/codemp/game/bg_pmove.c:1133")
}

/**
============
PM_CmdScale

Returns the scale factor to apply to cmd movements
This allows the clients to use axial -127 to 127 values for all directions
without getting a sqrt(2) distortion in speed.
============
*/
/// Source: oracle/codemp/game/bg_pmove.c:1199
private func PM_CmdScale(_ cmd: JKAMP.Usercmd) -> Float {
    // Port-note: `pmove_t` has no generated view, so `pm->ps->speed` has no Swift form.
    // TODO: Port PM_CmdScale
    portMissing("PM_CmdScale", source: "oracle/codemp/game/bg_pmove.c:1199")
}

/**
================
PM_SetMovementDir

Determine the rotation of the legs reletive
to the facing dir
================
*/
/// Source: oracle/codemp/game/bg_pmove.c:1233
private func PM_SetMovementDir() {
    // Port-note: `pmove_t` has no generated view, so `pm->ps` and `pm->cmd` have no Swift form.
    // TODO: Port PM_SetMovementDir
    portMissing("PM_SetMovementDir", source: "oracle/codemp/game/bg_pmove.c:1233")
}

/// Source: oracle/codemp/game/bg_pmove.c:1266
func PM_ForceJumpingUp() -> Bool {
    // Port-note: `pmove_t` has no generated view, so `pm->ps` has no Swift form.
    // TODO: Port PM_ForceJumpingUp
    portMissing("PM_ForceJumpingUp", source: "oracle/codemp/game/bg_pmove.c:1266")
}

/// Source: oracle/codemp/game/bg_pmove.c:1308
private func PM_JumpForDir() {
    // Port-note: `pmove_t` has no generated view, so `pm->cmd` has no Swift form.
    // TODO: Port PM_JumpForDir
    portMissing("PM_JumpForDir", source: "oracle/codemp/game/bg_pmove.c:1308")
}

/// Source: oracle/codemp/game/bg_pmove.c:1342
func PM_SetPMViewAngle(_ ps: JKAMP.PlayerState, _ angle: JKAShared.vec3_t, _ ucmd: JKAMP.Usercmd) {
    // Port-note: `ANGLE2SHORT` is a function-like macro, and no Swift form of it exists in the view targets.
    // TODO: Port PM_SetPMViewAngle
    portMissing("PM_SetPMViewAngle", source: "oracle/codemp/game/bg_pmove.c:1342")
}

/// Source: oracle/codemp/game/bg_pmove.c:1356
func PM_AdjustAngleForWallRun(_ ps: JKAMP.PlayerState, _ ucmd: JKAMP.Usercmd, _ doMove: Bool) -> Bool {
    // Port-note: `pmove_t` has no generated view, so `pm` has no Swift form.
    // TODO: Port PM_AdjustAngleForWallRun
    portMissing("PM_AdjustAngleForWallRun", source: "oracle/codemp/game/bg_pmove.c:1356")
}

/// Source: oracle/codemp/game/bg_pmove.c:1464
func PM_AdjustAnglesForWallRunUpFlipAlt(_ ucmd: JKAMP.Usercmd) -> Bool {
    // Port-note: `pmove_t` has no generated view, so `pm->ps` has no Swift form.
    // TODO: Port PM_AdjustAnglesForWallRunUpFlipAlt
    portMissing("PM_AdjustAnglesForWallRunUpFlipAlt", source: "oracle/codemp/game/bg_pmove.c:1464")
}

/// Source: oracle/codemp/game/bg_pmove.c:1472
func PM_AdjustAngleForWallRunUp(_ ps: JKAMP.PlayerState, _ ucmd: JKAMP.Usercmd, _ doMove: Bool) -> Bool {
    // Port-note: `pmove_t` has no generated view, so `pm` has no Swift form.
    // TODO: Port PM_AdjustAngleForWallRunUp
    portMissing("PM_AdjustAngleForWallRunUp", source: "oracle/codemp/game/bg_pmove.c:1472")
}

//nice...
/// Source: oracle/codemp/game/bg_pmove.c:1602
private func BG_ForceWallJumpStrength() -> Float {
    return (bg.forceJumpStrength[FORCE_LEVEL_3] / 2.5)
}

/// Source: oracle/codemp/game/bg_pmove.c:1607
func PM_AdjustAngleForWallJump(_ ps: JKAMP.PlayerState, _ ucmd: JKAMP.Usercmd, _ doMove: Bool) -> Bool {
    // Port-note: `pmove_t` has no generated view, so `pm` has no Swift form.
    // TODO: Port PM_AdjustAngleForWallJump
    portMissing("PM_AdjustAngleForWallJump", source: "oracle/codemp/game/bg_pmove.c:1607")
}

//Set the height for when a force jump was started. If it's 0, nuge it up (slight hack to prevent holding jump over slopes)
/// Source: oracle/codemp/game/bg_pmove.c:1759
func PM_SetForceJumpZStart(_ value: Float) {
    // Port-note: `pmove_t` has no generated view, so `pm->ps->fd` has no Swift form.
    // TODO: Port PM_SetForceJumpZStart
    portMissing("PM_SetForceJumpZStart", source: "oracle/codemp/game/bg_pmove.c:1759")
}

/// Source: oracle/codemp/game/bg_pmove.c:1776
func PM_GrabWallForJump(_ anim: Int32) {
    // Port-note: `pmove_t` has no generated view, so `pm->ps->pm_flags` has no Swift form.
    // TODO: Port PM_GrabWallForJump
    portMissing("PM_GrabWallForJump", source: "oracle/codemp/game/bg_pmove.c:1776")
}

/**
=============
PM_CheckJump
=============
*/
/// Source: oracle/codemp/game/bg_pmove.c:1788
private func PM_CheckJump() -> Bool {
    // Port-note: `pmove_t` and `pml_t` have no generated views, so `pm` and `pml` have no Swift form.
    // TODO: Port PM_CheckJump
    portMissing("PM_CheckJump", source: "oracle/codemp/game/bg_pmove.c:1788")
}

/**
=============
PM_CheckWaterJump
=============
*/
/// Source: oracle/codemp/game/bg_pmove.c:2781
private func PM_CheckWaterJump() -> Bool {
    // Port-note: `pmove_t` and `pml_t` have no generated views, so `pm` and `pml` have no Swift form.
    // TODO: Port PM_CheckWaterJump
    portMissing("PM_CheckWaterJump", source: "oracle/codemp/game/bg_pmove.c:2781")
}

/**
===================
PM_WaterJumpMove

Flying out of the water
===================
*/
/// Source: oracle/codemp/game/bg_pmove.c:2833
private func PM_WaterJumpMove() {
    // Port-note: `pmove_t` and `pml_t` have no generated views, so `pm` and `pml` have no Swift form.
    // TODO: Port PM_WaterJumpMove
    portMissing("PM_WaterJumpMove", source: "oracle/codemp/game/bg_pmove.c:2833")
}

/**
===================
PM_WaterMove

===================
*/
/// Source: oracle/codemp/game/bg_pmove.c:2852
private func PM_WaterMove() {
    // Port-note: `pmove_t` and `pml_t` have no generated views, so `pm` and `pml` have no Swift form.
    // TODO: Port PM_WaterMove
    portMissing("PM_WaterMove", source: "oracle/codemp/game/bg_pmove.c:2852")
}

/**
===================
PM_FlyVehicleMove

===================
*/
/// Source: oracle/codemp/game/bg_pmove.c:2924
private func PM_FlyVehicleMove() {
    // Port-note: `pmove_t` and `pml_t` have no generated views, so `pm` and `pml` have no Swift form.
    // TODO: Port PM_FlyVehicleMove
    portMissing("PM_FlyVehicleMove", source: "oracle/codemp/game/bg_pmove.c:2924")
}

/**
===================
PM_FlyMove

Only with the flight powerup
===================
*/
/// Source: oracle/codemp/game/bg_pmove.c:3021
private func PM_FlyMove() {
    // Port-note: `pmove_t` and `pml_t` have no generated views, so `pm` and `pml` have no Swift form.
    // TODO: Port PM_FlyMove
    portMissing("PM_FlyMove", source: "oracle/codemp/game/bg_pmove.c:3021")
}

/**
===================
PM_AirMove

===================
*/
/// Source: oracle/codemp/game/bg_pmove.c:3068
private func PM_AirMove() {
    // Port-note: `pmove_t` and `pml_t` have no generated views, so `pm` and `pml` have no Swift form.
    // TODO: Port PM_AirMove
    portMissing("PM_AirMove", source: "oracle/codemp/game/bg_pmove.c:3068")
}

/**
===================
PM_WalkMove

===================
*/
/// Source: oracle/codemp/game/bg_pmove.c:3305
private func PM_WalkMove() {
    // Port-note: `pmove_t` and `pml_t` have no generated views, so `pm` and `pml` have no Swift form.
    // TODO: Port PM_WalkMove
    portMissing("PM_WalkMove", source: "oracle/codemp/game/bg_pmove.c:3305")
}

/**
==============
PM_DeadMove
==============
*/
/// Source: oracle/codemp/game/bg_pmove.c:3492
private func PM_DeadMove() {
    // Port-note: `pmove_t` and `pml_t` have no generated views, so `pm` and `pml` have no Swift form.
    // TODO: Port PM_DeadMove
    portMissing("PM_DeadMove", source: "oracle/codemp/game/bg_pmove.c:3492")
}

/**
===============
PM_NoclipMove
===============
*/
/// Source: oracle/codemp/game/bg_pmove.c:3517
private func PM_NoclipMove() {
    // Port-note: `pmove_t` and `pml_t` have no generated views, so `pm` and `pml` have no Swift form.
    // TODO: Port PM_NoclipMove
    portMissing("PM_NoclipMove", source: "oracle/codemp/game/bg_pmove.c:3517")
}

/**
================
PM_FootstepForSurface

Returns an event number apropriate for the groundsurface
================
*/
/// Source: oracle/codemp/game/bg_pmove.c:3587
private func PM_FootstepForSurface() -> Int32 {
    // Port-note: `pml_t` has no generated view, so `pml` has no Swift form.
    // TODO: Port PM_FootstepForSurface
    portMissing("PM_FootstepForSurface", source: "oracle/codemp/game/bg_pmove.c:3587")
}

/// Source: oracle/codemp/game/bg_pmove.c:3597
private func PM_TryRoll() -> Int32 {
    // Port-note: `pmove_t` has no generated view, so `pm` has no Swift form.
    // TODO: Port PM_TryRoll
    portMissing("PM_TryRoll", source: "oracle/codemp/game/bg_pmove.c:3597")
}

/// Source: oracle/codemp/game/bg_pmove.c:3684
private func PM_CrashLandEffect() {
    // Port-note: `pmove_t` and `pml_t` have no generated views, so `pm` and `pml` have no Swift form.
    // TODO: Port PM_CrashLandEffect
    portMissing("PM_CrashLandEffect", source: "oracle/codemp/game/bg_pmove.c:3684")
}

/**
=================
PM_CrashLand

Check for hard landings that generate sound events
=================
*/
/// Source: oracle/codemp/game/bg_pmove.c:3731
private func PM_CrashLand() {
    // Port-note: `pmove_t` and `pml_t` have no generated views, so `pm` and `pml` have no Swift form.
    // TODO: Port PM_CrashLand
    portMissing("PM_CrashLand", source: "oracle/codemp/game/bg_pmove.c:3731")
}

/**
=============
PM_CorrectAllSolid
=============
*/
/// Source: oracle/codemp/game/bg_pmove.c:4009
private func PM_CorrectAllSolid(_ trace: JKAMP.Trace) -> Int32 {
    // Port-note: `pmove_t` and `pml_t` have no generated views, so `pm` and `pml` have no Swift form.
    // TODO: Port PM_CorrectAllSolid
    portMissing("PM_CorrectAllSolid", source: "oracle/codemp/game/bg_pmove.c:4009")
}

/**
=============
PM_GroundTraceMissed

The ground trace didn't hit a surface, so we are in freefall
=============
*/
/// Source: oracle/codemp/game/bg_pmove.c:4053
private func PM_GroundTraceMissed() {
    // Port-note: `pmove_t` and `pml_t` have no generated views, so `pm` and `pml` have no Swift form.
    // TODO: Port PM_GroundTraceMissed
    portMissing("PM_GroundTraceMissed", source: "oracle/codemp/game/bg_pmove.c:4053")
}

/**
=============
PM_GroundTrace
=============
*/
/// Source: oracle/codemp/game/bg_pmove.c:4141
private func PM_GroundTrace() {
    // Port-note: `pmove_t` and `pml_t` have no generated views, so `pm` and `pml` have no Swift form.
    // TODO: Port PM_GroundTrace
    portMissing("PM_GroundTrace", source: "oracle/codemp/game/bg_pmove.c:4141")
}

/**
=============
PM_SetWaterLevel
=============
*/
/// Source: oracle/codemp/game/bg_pmove.c:4285
private func PM_SetWaterLevel() {
    // Port-note: `pmove_t` has no generated view, so `pm` has no Swift form.
    // TODO: Port PM_SetWaterLevel
    portMissing("PM_SetWaterLevel", source: "oracle/codemp/game/bg_pmove.c:4285")
}

/// Source: oracle/codemp/game/bg_pmove.c:4322
func PM_CheckDualForwardJumpDuck() -> Bool {
    // Port-note: `pmove_t` has no generated view, so `pm` has no Swift form.
    // TODO: Port PM_CheckDualForwardJumpDuck
    portMissing("PM_CheckDualForwardJumpDuck", source: "oracle/codemp/game/bg_pmove.c:4322")
}

/// Source: oracle/codemp/game/bg_pmove.c:4341
func PM_CheckFixMins() {
    // Port-note: `pmove_t` has no generated view, so `pm` has no Swift form.
    // TODO: Port PM_CheckFixMins
    portMissing("PM_CheckFixMins", source: "oracle/codemp/game/bg_pmove.c:4341")
}

/**
==============
PM_CheckDuck

Sets mins, maxs, and pm->ps->viewheight
==============
*/
/// Source: oracle/codemp/game/bg_pmove.c:4410
private func PM_CheckDuck() {
    // Port-note: `pmove_t` has no generated view, so `pm` has no Swift form.
    // TODO: Port PM_CheckDuck
    portMissing("PM_CheckDuck", source: "oracle/codemp/game/bg_pmove.c:4410")
}

/// Source: oracle/codemp/game/bg_pmove.c:4559
func PM_Use() {
    // Port-note: `pmove_t` has no generated view, so `pm` has no Swift form.
    // TODO: Port PM_Use
    portMissing("PM_Use", source: "oracle/codemp/game/bg_pmove.c:4559")
}

/// Source: oracle/codemp/game/bg_pmove.c:4579
func PM_WalkingAnim(_ anim: Int32) -> Bool {
    switch anim {
    case BOTH_WALK1, //# Normal walk
         BOTH_WALK2, //# Normal walk with saber
         BOTH_WALK_STAFF, //# Normal walk with staff
         BOTH_WALK_DUAL, //# Normal walk with staff
         BOTH_WALK5, //# Tavion taunting Kyle (cin 22)
         BOTH_WALK6, //# Slow walk for Luke (cin 12)
         BOTH_WALK7, //# Fast walk
         BOTH_WALKBACK1, //# Walk1 backwards
         BOTH_WALKBACK2, //# Walk2 backwards
         BOTH_WALKBACK_STAFF, //# Walk backwards with staff
         BOTH_WALKBACK_DUAL: //# Walk backwards with dual
        return true
    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_pmove.c:4600
func PM_RunningAnim(_ anim: Int32) -> Bool {
    switch (anim) {
    case BOTH_RUN1,
         BOTH_RUN2,
         BOTH_RUN_STAFF,
         BOTH_RUN_DUAL,
         BOTH_RUNBACK1,
         BOTH_RUNBACK2,
         BOTH_RUNBACK_STAFF,
         BOTH_RUNBACK_DUAL,
         BOTH_RUN1START, //# Start into full run1
         BOTH_RUN1STOP, //# Stop from full run1
         BOTH_RUNSTRAFE_LEFT1, //# Sidestep left: should loop
         BOTH_RUNSTRAFE_RIGHT1: //# Sidestep right: should loop
        return true
    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_pmove.c:4622
func PM_SwimmingAnim(_ anim: Int32) -> Bool {
    switch anim {
    case BOTH_SWIM_IDLE1, //# Swimming Idle 1
         BOTH_SWIMFORWARD, //# Swim forward loop
         BOTH_SWIMBACKWARD: //# Swim backward loop
        return true
    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_pmove.c:4635
func PM_RollingAnim(_ anim: Int32) -> Bool {
    switch anim {
    case BOTH_ROLL_F, //# Roll forward
         BOTH_ROLL_B, //# Roll backward
         BOTH_ROLL_L, //# Roll left
         BOTH_ROLL_R: //# Roll right
        return true
    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_pmove.c:4649
func PM_AnglesForSlope(_ yaw: Float, _ slope: JKAShared.vec3_t, _ angles: JKAShared.vec3_t) {
    // Port-note: The `angles` out-param is not `inout` in the generated signature, so the body cannot write it.
    // TODO: Port PM_AnglesForSlope
    portMissing("PM_AnglesForSlope", source: "oracle/codemp/game/bg_pmove.c:4649")
}

/// Source: oracle/codemp/game/bg_pmove.c:4677
// TODO: Port signature
// Raven wrote: void PM_FootSlopeTrace( float *pDiff, float *pInterval )
// No table row for `float * pDiff`.
func PM_FootSlopeTrace() -> Never {
    // Port-note: The generated signature is unmapped, because `float *pDiff` and `float *pInterval` are out-params with no table row.
    // TODO: Port PM_FootSlopeTrace
    portMissing("PM_FootSlopeTrace", source: "oracle/codemp/game/bg_pmove.c:4677")
}

/// Source: oracle/codemp/game/bg_pmove.c:4742
func BG_InSlopeAnim(_ anim: Int32) -> Bool {
    switch anim {
    case LEGS_LEFTUP1, //# On a slope with left foot 4 higher than right
         LEGS_LEFTUP2, //# On a slope with left foot 8 higher than right
         LEGS_LEFTUP3, //# On a slope with left foot 12 higher than right
         LEGS_LEFTUP4, //# On a slope with left foot 16 higher than right
         LEGS_LEFTUP5, //# On a slope with left foot 20 higher than right
         LEGS_RIGHTUP1, //# On a slope with RIGHT foot 4 higher than left
         LEGS_RIGHTUP2, //# On a slope with RIGHT foot 8 higher than left
         LEGS_RIGHTUP3, //# On a slope with RIGHT foot 12 higher than left
         LEGS_RIGHTUP4, //# On a slope with RIGHT foot 16 higher than left
         LEGS_RIGHTUP5, //# On a slope with RIGHT foot 20 higher than left
         LEGS_S1_LUP1,
         LEGS_S1_LUP2,
         LEGS_S1_LUP3,
         LEGS_S1_LUP4,
         LEGS_S1_LUP5,
         LEGS_S1_RUP1,
         LEGS_S1_RUP2,
         LEGS_S1_RUP3,
         LEGS_S1_RUP4,
         LEGS_S1_RUP5,
         LEGS_S3_LUP1,
         LEGS_S3_LUP2,
         LEGS_S3_LUP3,
         LEGS_S3_LUP4,
         LEGS_S3_LUP5,
         LEGS_S3_RUP1,
         LEGS_S3_RUP2,
         LEGS_S3_RUP3,
         LEGS_S3_RUP4,
         LEGS_S3_RUP5,
         LEGS_S4_LUP1,
         LEGS_S4_LUP2,
         LEGS_S4_LUP3,
         LEGS_S4_LUP4,
         LEGS_S4_LUP5,
         LEGS_S4_RUP1,
         LEGS_S4_RUP2,
         LEGS_S4_RUP3,
         LEGS_S4_RUP4,
         LEGS_S4_RUP5,
         LEGS_S5_LUP1,
         LEGS_S5_LUP2,
         LEGS_S5_LUP3,
         LEGS_S5_LUP4,
         LEGS_S5_LUP5,
         LEGS_S5_RUP1,
         LEGS_S5_RUP2,
         LEGS_S5_RUP3,
         LEGS_S5_RUP4,
         LEGS_S5_RUP5:
        return true
    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_pmove.c:4804
func PM_AdjustStandAnimForSlope() -> Bool {
    // Port-note: `pmove_t` has no generated view, so `pm` has no Swift form.
    // TODO: Port PM_AdjustStandAnimForSlope
    portMissing("PM_AdjustStandAnimForSlope", source: "oracle/codemp/game/bg_pmove.c:4804")
}

//rww - slowly back out of slope leg anims, to prevent skipping between slope anims and general jittering
/// Source: oracle/codemp/game/bg_pmove.c:5107
func PM_LegsSlopeBackTransition(_ desiredAnim: Int32) -> Int32 {
    // Port-note: `pmove_t` has no generated view, so `pm` has no Swift form.
    // TODO: Port PM_LegsSlopeBackTransition
    portMissing("PM_LegsSlopeBackTransition", source: "oracle/codemp/game/bg_pmove.c:5107")
}

/**
===============
PM_Footsteps
===============
*/
/// Source: oracle/codemp/game/bg_pmove.c:5175
private func PM_Footsteps() {
    // Port-note: `pmove_t` and `pml_t` have no generated views, so `pm` and `pml` have no Swift form.
    // TODO: Port PM_Footsteps
    portMissing("PM_Footsteps", source: "oracle/codemp/game/bg_pmove.c:5175")
}

/**
==============
PM_WaterEvents

Generate sound events for entering and leaving water
==============
*/
/// Source: oracle/codemp/game/bg_pmove.c:5670
private func PM_WaterEvents() {
    // Port-note: `pmove_t` and `pml_t` have no generated views, so `pm` and `pml` have no Swift form.
    // TODO: Port PM_WaterEvents
    portMissing("PM_WaterEvents", source: "oracle/codemp/game/bg_pmove.c:5670")
}

/// Source: oracle/codemp/game/bg_pmove.c:5750
func BG_ClearRocketLock(_ ps: JKAMP.PlayerState) {
    // Port-note: Raven's `if (ps)` guard has no Swift form, because the signature takes a non-optional `PlayerState`.
    ps.rocketLockIndex = ENTITYNUM_NONE
    ps.rocketLastValidTime = 0
    ps.rocketLockTime = -1
    ps.rocketTargetTime = 0
}

/**
===============
PM_BeginWeaponChange
===============
*/
/// Source: oracle/codemp/game/bg_pmove.c:5766
func PM_BeginWeaponChange(_ weapon: Int32) {
    // Port-note: `pmove_t` has no generated view, so `pm` has no Swift form.
    // TODO: Port PM_BeginWeaponChange
    portMissing("PM_BeginWeaponChange", source: "oracle/codemp/game/bg_pmove.c:5766")
}

/**
===============
PM_FinishWeaponChange
===============
*/
/// Source: oracle/codemp/game/bg_pmove.c:5801
func PM_FinishWeaponChange() {
    // Port-note: `pmove_t` has no generated view, so `pm` has no Swift form.
    // TODO: Port PM_FinishWeaponChange
    portMissing("PM_FinishWeaponChange", source: "oracle/codemp/game/bg_pmove.c:5801")
}

/// Source: oracle/codemp/game/bg_pmove.c:5833
func BG_VehTraceFromCamPos(_ camTrace: JKAMP.Trace, _ bgEnt: JKAMP.BgEntity, _ entOrg: JKAShared.vec3_t, _ shotStart: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ newEnd: JKAShared.vec3_t, _ shotDir: JKAShared.vec3_t, _ bestDist: Float) -> Int32 {
    // Port-note: `pmove_t` has no generated view, so `pm` has no Swift form.
    // TODO: Port BG_VehTraceFromCamPos
    portMissing("BG_VehTraceFromCamPos", source: "oracle/codemp/game/bg_pmove.c:5833")
}

/// Source: oracle/codemp/game/bg_pmove.c:5874
func PM_RocketLock(_ lockDist: Float, _ vehicleLock: Bool) {
    // Port-note: `pmove_t` has no generated view, so `pm` has no Swift form.
    // TODO: Port PM_RocketLock
    portMissing("PM_RocketLock", source: "oracle/codemp/game/bg_pmove.c:5874")
}

//---------------------------------------
/// Source: oracle/codemp/game/bg_pmove.c:5980
private func PM_DoChargedWeapons(_ vehicleRocketLock: Bool, _ veh: JKAMP.BgEntity) -> Bool {
    // Port-note: `pmove_t` has no generated view, so `pm` has no Swift form.
    // TODO: Port PM_DoChargedWeapons
    portMissing("PM_DoChargedWeapons", source: "oracle/codemp/game/bg_pmove.c:5980")
}

/// Source: oracle/codemp/game/bg_pmove.c:6239
func PM_ItemUsable(_ ps: JKAMP.PlayerState, _ forcedUse: Int32) -> Int32 {
    // Port-note: `pmove_t` has no generated view, so `pm` has no Swift form.
    // TODO: Port PM_ItemUsable
    portMissing("PM_ItemUsable", source: "oracle/codemp/game/bg_pmove.c:6239")
}

//cheesy vehicle weapon hackery
/// Source: oracle/codemp/game/bg_pmove.c:6369
func PM_CanSetWeaponAnims() -> Bool {
    // Port-note: `pmove_t` has no generated view, so `pm` has no Swift form.
    // TODO: Port PM_CanSetWeaponAnims
    portMissing("PM_CanSetWeaponAnims", source: "oracle/codemp/game/bg_pmove.c:6369")
}

/// Source: oracle/codemp/game/bg_pmove.c:6381
func PM_VehicleWeaponAnimate() {
    // Port-note: `pmove_t` has no generated view, so `pm` has no Swift form.
    // TODO: Port PM_VehicleWeaponAnimate
    portMissing("PM_VehicleWeaponAnimate", source: "oracle/codemp/game/bg_pmove.c:6381")
}

/// Source: oracle/codemp/game/bg_pmove.c:6641
private func PM_Weapon() {
    // Port-note: `pmove_t` and `pml_t` have no generated views, so `pm` and `pml` have no Swift form.
    // TODO: Port PM_Weapon
    portMissing("PM_Weapon", source: "oracle/codemp/game/bg_pmove.c:6641")
}

/// Source: oracle/codemp/game/bg_pmove.c:7680
private func PM_Animate() {
    // Port-note: `pmove_t` has no generated view, so `pm` has no Swift form.
    // TODO: Port PM_Animate
    portMissing("PM_Animate", source: "oracle/codemp/game/bg_pmove.c:7680")
}

/**
================
PM_DropTimers
================
*/
/// Source: oracle/codemp/game/bg_pmove.c:7748
private func PM_DropTimers() {
    // Port-note: `pmove_t` and `pml_t` have no generated views, so `pm` and `pml` have no Swift form.
    // TODO: Port PM_DropTimers
    portMissing("PM_DropTimers", source: "oracle/codemp/game/bg_pmove.c:7748")
}

/// Source: oracle/codemp/game/bg_pmove.c:7784
func BG_UnrestrainedPitchRoll(_ ps: JKAMP.PlayerState, _ pVeh: JKAMP.Vehicle) -> Bool {
    // Port-note: the cvar `bg_fighterAltControl` has no Swift form in the view targets.
    // TODO: Port BG_UnrestrainedPitchRoll
    portMissing("BG_UnrestrainedPitchRoll", source: "oracle/codemp/game/bg_pmove.c:7784")
}

/**
================
PM_UpdateViewAngles

This can be used as another entry point when only the viewangles
are being updated isntead of a full move
================
*/
/// Source: oracle/codemp/game/bg_pmove.c:7813
func PM_UpdateViewAngles(_ ps: JKAMP.PlayerState, _ cmd: JKAMP.Usercmd) {
    // Port-note: `SHORT2ANGLE` is a function-like macro with no Swift form, and `pm_entVeh->m_pVehicle` is optional where `BG_UnrestrainedPitchRoll` takes a non-optional `Vehicle`.
    // TODO: Port PM_UpdateViewAngles
    portMissing("PM_UpdateViewAngles", source: "oracle/codemp/game/bg_pmove.c:7813")
}

//-------------------------------------------
/// Source: oracle/codemp/game/bg_pmove.c:8031
// TODO: Port signature
// Raven wrote: void PM_AdjustAttackStates( pmove_t *pm ) //-------------------------------------------
// No table row for `pmove_t * pm`.
func PM_AdjustAttackStates() -> Never {
    // Port-note: The generated signature is unmapped, because `pmove_t *pm` has no table row and `pmove_t` has no generated view.
    // TODO: Port PM_AdjustAttackStates
    portMissing("PM_AdjustAttackStates", source: "oracle/codemp/game/bg_pmove.c:8031")
}

/// Source: oracle/codemp/game/bg_pmove.c:8201
func BG_CmdForRoll(_ ps: JKAMP.PlayerState, _ anim: Int32, _ pCmd: JKAMP.Usercmd) {
    // Port-note: Raven's `pCmd->forwardmove = pCmd->rightmove = 0` chain is written as two stores here.
    switch (anim) {
    case BOTH_ROLL_F:
        pCmd.forwardmove = 127
        pCmd.rightmove = 0

    case BOTH_ROLL_B:
        pCmd.forwardmove = -127
        pCmd.rightmove = 0

    case BOTH_ROLL_R:
        pCmd.forwardmove = 0
        pCmd.rightmove = 127

    case BOTH_ROLL_L:
        pCmd.forwardmove = 0
        pCmd.rightmove = -127

    case BOTH_GETUP_BROLL_R:
        pCmd.forwardmove = 0
        pCmd.rightmove = 48
        //NOTE: speed is 400

    case BOTH_GETUP_FROLL_R:
        if ps.legsTimer <= 250 {
            //end of anim
            pCmd.forwardmove = 0
            pCmd.rightmove = 0
        } else {
            pCmd.forwardmove = 0
            pCmd.rightmove = 48
            //NOTE: speed is 400
        }

    case BOTH_GETUP_BROLL_L:
        pCmd.forwardmove = 0
        pCmd.rightmove = -48
        //NOTE: speed is 400

    case BOTH_GETUP_FROLL_L:
        if ps.legsTimer <= 250 {
            //end of anim
            pCmd.forwardmove = 0
            pCmd.rightmove = 0
        } else {
            pCmd.forwardmove = 0
            pCmd.rightmove = -48
            //NOTE: speed is 400
        }

    case BOTH_GETUP_BROLL_B:
        if ps.torsoTimer <= 250 {
            //end of anim
            pCmd.forwardmove = 0
            pCmd.rightmove = 0
        } else if PM_AnimLength(0, ps.legsAnim) - ps.torsoTimer < 350 {
            //beginning of anim
            pCmd.forwardmove = 0
            pCmd.rightmove = 0
        } else {
            //FIXME: ramp down over length of anim
            pCmd.forwardmove = -64
            pCmd.rightmove = 0
            //NOTE: speed is 400
        }

    case BOTH_GETUP_FROLL_B:
        if ps.torsoTimer <= 100 {
            //end of anim
            pCmd.forwardmove = 0
            pCmd.rightmove = 0
        } else if PM_AnimLength(0, ps.legsAnim) - ps.torsoTimer < 200 {
            //beginning of anim
            pCmd.forwardmove = 0
            pCmd.rightmove = 0
        } else {
            //FIXME: ramp down over length of anim
            pCmd.forwardmove = -64
            pCmd.rightmove = 0
            //NOTE: speed is 400
        }

    case BOTH_GETUP_BROLL_F:
        if ps.torsoTimer <= 550 {
            //end of anim
            pCmd.forwardmove = 0
            pCmd.rightmove = 0
        } else if PM_AnimLength(0, ps.legsAnim) - ps.torsoTimer < 150 {
            //beginning of anim
            pCmd.forwardmove = 0
            pCmd.rightmove = 0
        } else {
            pCmd.forwardmove = 64
            pCmd.rightmove = 0
            //NOTE: speed is 400
        }

    case BOTH_GETUP_FROLL_F:
        if ps.torsoTimer <= 100 {
            //end of anim
            pCmd.forwardmove = 0
            pCmd.rightmove = 0
        } else {
            //FIXME: ramp down over length of anim
            pCmd.forwardmove = 64
            pCmd.rightmove = 0
            //NOTE: speed is 400
        }

    default:
        break
    }
    pCmd.upmove = 0
}

/// Source: oracle/codemp/game/bg_pmove.c:8331
func BG_AdjustClientSpeed(_ ps: JKAMP.PlayerState, _ cmd: JKAMP.Usercmd, _ svTime: Int32) {
    // Port-note: `pmove_t` has no generated view, so `pm` has no Swift form.
    // TODO: Port BG_AdjustClientSpeed
    portMissing("BG_AdjustClientSpeed", source: "oracle/codemp/game/bg_pmove.c:8331")
}

/// Source: oracle/codemp/game/bg_pmove.c:8512
func BG_InRollAnim(_ cent: JKAMP.EntityState) -> Bool {
    switch (cent.legsAnim) {
    case BOTH_ROLL_F,
         BOTH_ROLL_B,
         BOTH_ROLL_R,
         BOTH_ROLL_L:
        return true
    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_pmove.c:8525
func BG_InKnockDown(_ anim: Int32) -> Bool {
    switch (anim) {
    case BOTH_KNOCKDOWN1,
         BOTH_KNOCKDOWN2,
         BOTH_KNOCKDOWN3,
         BOTH_KNOCKDOWN4:
        return true
    case BOTH_GETUP1,
         BOTH_GETUP2,
         BOTH_GETUP3,
         BOTH_GETUP4,
         BOTH_GETUP5,
         BOTH_FORCE_GETUP_F1,
         BOTH_FORCE_GETUP_F2,
         BOTH_FORCE_GETUP_B1,
         BOTH_FORCE_GETUP_B2,
         BOTH_FORCE_GETUP_B3,
         BOTH_FORCE_GETUP_B4,
         BOTH_FORCE_GETUP_B5,
         BOTH_GETUP_BROLL_B,
         BOTH_GETUP_BROLL_F,
         BOTH_GETUP_BROLL_L,
         BOTH_GETUP_BROLL_R,
         BOTH_GETUP_FROLL_B,
         BOTH_GETUP_FROLL_F,
         BOTH_GETUP_FROLL_L:
        return true
    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_pmove.c:8562
func BG_InRollES(_ ps: JKAMP.EntityState, _ anim: Int32) -> Bool {
    switch (anim) {
    case BOTH_ROLL_F,
         BOTH_ROLL_B,
         BOTH_ROLL_R,
         BOTH_ROLL_L:
        return true
    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_pmove.c:8576
// TODO: Port signature
// Raven wrote: void BG_IK_MoveArm(void *ghoul2, int lHandBolt, int time, entityState_t *ent, int basePose, vec3_t desiredPos, qboolean *ikInProgress, vec3_t origin, vec3_t angles, vec3_t scale, int blendTime, qboolean forceHalt)
// No table row for `qboolean * ikInProgress`.
func BG_IK_MoveArm() -> Never {
    // Port-note: The generated signature is unmapped, because `qboolean *ikInProgress` is an out-param with no table row.
    // TODO: Port BG_IK_MoveArm
    portMissing("BG_IK_MoveArm", source: "oracle/codemp/game/bg_pmove.c:8576")
}

//Adjust the head/neck desired angles
/// Source: oracle/codemp/game/bg_pmove.c:8733
func BG_UpdateLookAngles(_ lookingDebounceTime: Int32, _ lastHeadAngles: JKAShared.vec3_t, _ time: Int32, _ lookAngles: JKAShared.vec3_t, _ lookSpeed: Float, _ minPitch: Float, _ maxPitch: Float, _ minYaw: Float, _ maxYaw: Float, _ minRoll: Float, _ maxRoll: Float) {
    // Port-note: The `lastHeadAngles` and `lookAngles` out-params are not `inout` in the generated signature, so the body cannot write them.
    // TODO: Port BG_UpdateLookAngles
    portMissing("BG_UpdateLookAngles", source: "oracle/codemp/game/bg_pmove.c:8733")
}

//for setting visual look (headturn) angles
/// Source: oracle/codemp/game/bg_pmove.c:8790
private func BG_G2ClientNeckAngles(_ ghoul2: OpaquePointer?, _ time: Int32, _ lookAngles: JKAShared.vec3_t, _ headAngles: JKAShared.vec3_t, _ neckAngles: JKAShared.vec3_t, _ thoracicAngles: JKAShared.vec3_t, _ headClampMinAngles: JKAShared.vec3_t, _ headClampMaxAngles: JKAShared.vec3_t) {
    // Port-note: The `headAngles`, `neckAngles`, and `thoracicAngles` out-params are not `inout` in the generated signature, and `strap_G2API_SetBoneAngles` with its `BONE_ANGLES_POSTMULT`, `POSITIVE_X`, `NEGATIVE_Y`, and `NEGATIVE_Z` constants has no Swift form.
    // TODO: Port BG_G2ClientNeckAngles
    portMissing("BG_G2ClientNeckAngles", source: "oracle/codemp/game/bg_pmove.c:8790")
}

//rww - Finally decided to convert all this stuff to BG form.
/// Source: oracle/codemp/game/bg_pmove.c:8869
// TODO: Port signature
// Raven wrote: static void BG_G2ClientSpineAngles( void *ghoul2, int motionBolt, vec3_t cent_lerpOrigin, vec3_t cent_lerpAngles, entityState_t *cent, int time, vec3_t viewAngles, int ciLegs, int ciTorso, const vec3_t angles, vec3_t thoracicAngles, vec3_t ulAngles, vec3_t llAngles, vec3_t modelScale, float *tPitchAngle, float *tYawAngle, int *corrTime )
// No table row for `float * tPitchAngle`.
private func BG_G2ClientSpineAngles() -> Never {
    // Port-note: The generated signature is unmapped, because `float *tPitchAngle`, `float *tYawAngle`, and `int *corrTime` are out-params with no table row.
    // TODO: Port BG_G2ClientSpineAngles
    portMissing("BG_G2ClientSpineAngles", source: "oracle/codemp/game/bg_pmove.c:8869")
}

/**
==================
CG_SwingAngles
==================
*/
/// Source: oracle/codemp/game/bg_pmove.c:8997
// TODO: Port signature
// Raven wrote: static float BG_SwingAngles( float destination, float swingTolerance, float clampTolerance, float speed, float *angle, qboolean *swinging, int frametime )
// No table row for `float * angle`.
private func BG_SwingAngles() -> Never {
    // Port-note: The generated signature is unmapped, because `float *angle` and `qboolean *swinging` are out-params with no table row.
    // TODO: Port BG_SwingAngles
    portMissing("BG_SwingAngles", source: "oracle/codemp/game/bg_pmove.c:8997")
}

//I apologize for this function
/// Source: oracle/codemp/game/bg_pmove.c:9058
func BG_InRoll2(_ es: JKAMP.EntityState) -> Bool {
    switch (es.legsAnim) {
    case BOTH_GETUP_BROLL_B,
         BOTH_GETUP_BROLL_F,
         BOTH_GETUP_BROLL_L,
         BOTH_GETUP_BROLL_R,
         BOTH_GETUP_FROLL_B,
         BOTH_GETUP_FROLL_F,
         BOTH_GETUP_FROLL_L,
         BOTH_GETUP_FROLL_R,
         BOTH_ROLL_F,
         BOTH_ROLL_B,
         BOTH_ROLL_R:
        return true
    default:
        break
    }
    return false
}

/// Source: oracle/codemp/game/bg_pmove.c:9082
// TODO: Port signature
// Raven wrote: void BG_G2PlayerAngles(void *ghoul2, int motionBolt, entityState_t *cent, int time, vec3_t cent_lerpOrigin, vec3_t cent_lerpAngles, vec3_t legs[3], vec3_t legsAngles, qboolean *tYawing, qboolean *tPitching, qboolean *lYawing, float *tYawAngle, float *tPitchAngle, float *lYawAngle, int frametime, vec3_t turAngles, vec3_t modelScale, int ciLegs, int ciTorso, int *corrTime, vec3_t lookAngles, vec3_t lastHeadAngles, int lookTime, entityState_t *emplaced, int *crazySmoothFactor)
// No table row for `vec3_t[3] legs`.
func BG_G2PlayerAngles() -> Never {
    // Port-note: The generated signature is unmapped, because `vec3_t legs[3]` and the out-params after it have no table row.
    // TODO: Port BG_G2PlayerAngles
    portMissing("BG_G2PlayerAngles", source: "oracle/codemp/game/bg_pmove.c:9082")
}

/// Source: oracle/codemp/game/bg_pmove.c:9459
func BG_G2ATSTAngles(_ ghoul2: OpaquePointer?, _ time: Int32, _ cent_lerpAngles: JKAShared.vec3_t) {
    // Port-note: `strap_G2API_SetBoneAngles` and the `BONE_ANGLES_POSTMULT`, `POSITIVE_X`, `NEGATIVE_Y`, and `NEGATIVE_Z` constants have no Swift form in the view targets.
    // TODO: Port BG_G2ATSTAngles
    portMissing("BG_G2ATSTAngles", source: "oracle/codemp/game/bg_pmove.c:9459")
}

/// Source: oracle/codemp/game/bg_pmove.c:9464
private func PM_AdjustAnglesForDualJumpAttack(_ ps: JKAMP.PlayerState, _ ucmd: JKAMP.Usercmd) -> Bool {
    //ucmd->angles[PITCH] = ANGLE2SHORT( ps->viewangles[PITCH] ) - ps->delta_angles[PITCH];
    //ucmd->angles[YAW] = ANGLE2SHORT( ps->viewangles[YAW] ) - ps->delta_angles[YAW];
    return true
}

/// Source: oracle/codemp/game/bg_pmove.c:9474
private func PM_CmdForSaberMoves(_ ucmd: JKAMP.Usercmd) {
    // Port-note: `pmove_t` has no generated view, so `pm` has no Swift form.
    // TODO: Port PM_CmdForSaberMoves
    portMissing("PM_CmdForSaberMoves", source: "oracle/codemp/game/bg_pmove.c:9474")
}

//constrain him based on the angles of his vehicle and the caps
/// Source: oracle/codemp/game/bg_pmove.c:9642
func PM_VehicleViewAngles(_ ps: JKAMP.PlayerState, _ veh: JKAMP.BgEntity, _ ucmd: JKAMP.Usercmd) {
    // Port-note: Raven leaves `clampMin` and `clampMax` uninitialized on the turret path, so this port zeroes them, rule 19.
    let pVeh = veh.m_pVehicle
    var setAngles = true
    var clampMin = vec3_t(0, 0, 0)
    var clampMax = vec3_t(0, 0, 0)

    if let pilot = veh.m_pVehicle?.m_pPilot,
        pilot.s.number == ps.clientNum {
        //set the pilot's viewangles to the vehicle's viewangles
        if !BG_UnrestrainedPitchRoll(ps, veh.m_pVehicle!) {
            //only if not if doing special free-roll/pitch control
            setAngles = true
            clampMin[PITCH] = -pVeh!.m_pVehicleInfo!.lookPitch
            clampMax[PITCH] = pVeh!.m_pVehicleInfo!.lookPitch
            clampMin[YAW] = 0
            clampMax[YAW] = 0
            clampMin[ROLL] = -1
            clampMax[ROLL] = -1
        }
    } else {
        //NOTE: passengers can look around freely, UNLESS they're controlling a turret!
        for i in 0..<Int(MAX_VEHICLE_TURRETS) {
            if veh.m_pVehicle!.m_pVehicleInfo!.turret[i].passengerNum == ps.generic1 {
                //this turret is my station
                //nevermind, don't clamp
                return
                /*
                setAngles = qtrue;
                clampMin[Int(PITCH)] = veh->m_pVehicle->m_pVehicleInfo->turret[i].pitchClampUp;
                clampMax[Int(PITCH)] = veh->m_pVehicle->m_pVehicleInfo->turret[i].pitchClampDown;
                clampMin[Int(YAW)] = veh->m_pVehicle->m_pVehicleInfo->turret[i].yawClampRight;
                clampMax[Int(YAW)] = veh->m_pVehicle->m_pVehicleInfo->turret[i].yawClampLeft;
                clampMin[Int(ROLL)] = clampMax[Int(ROLL)] = 0;
                break;
                */
            }
        }
    }
    if setAngles {
        for i in 0..<3 {
            //clamp viewangles
            if clampMin[i] == -1 || clampMax[i] == -1 {
                //no clamp
            } else if clampMin[i] == 0 && clampMax[i] == 0 {
                //no allowance
                //ps->viewangles[i] = veh->playerState->viewangles[i];
            } else {
                //allowance
                if ps.viewangles[i] > clampMax[i] {
                    ps.viewangles[i] = clampMax[i]
                } else if ps.viewangles[i] < clampMin[i] {
                    ps.viewangles[i] = clampMin[i]
                }
            }
        }

        PM_SetPMViewAngle(ps, ps.viewangles, ucmd)
    }
}

/**
//constrain him based on the angles of his vehicle and the caps
void PM_VehicleViewAngles(playerState_t *ps, bgEntity_t *veh, usercmd_t *ucmd)
{
	Vehicle_t *pVeh = veh->m_pVehicle;

	//now set the viewangles to the vehicle's directly
	ps->viewangles[YAW] = veh->playerState->viewangles[YAW];

	//constrain the viewangles pitch based on the vehicle properties
	if ( !pVeh->m_pVehicleInfo->lookPitch )
	{//not allowed to look up & down!  ....???
		ps->viewangles[PITCH] = veh->playerState->viewangles[PITCH];
	}
	else
	{//clamp
		if (ps->viewangles[PITCH] > pVeh->m_pVehicleInfo->lookPitch)
		{
			ps->viewangles[PITCH] = pVeh->m_pVehicleInfo->lookPitch;
		}
		else if (ps->viewangles[PITCH] < -pVeh->m_pVehicleInfo->lookPitch)
		{
			ps->viewangles[PITCH] = -pVeh->m_pVehicleInfo->lookPitch;
		}
	}

	PM_SetPMViewAngle(ps, ps->viewangles, ucmd);
}
*/
//see if a weapon is ok to use on a vehicle
/// Source: oracle/codemp/game/bg_pmove.c:9745
func PM_WeaponOkOnVehicle(_ weapon: Int32) -> Bool {
    //FIXME: check g_vehicleInfo for our vehicle?
    switch weapon {
    //case WP_NONE:
    case WP_MELEE,
         WP_SABER,
         WP_BLASTER:
    //case WP_THERMAL:
        return true
    default:
        break
    }
    return false
}

//do we have a weapon that's ok for using on the vehicle?
/// Source: oracle/codemp/game/bg_pmove.c:9762
func PM_GetOkWeaponForVehicle() -> Int32 {
    // Port-note: `pmove_t` has no generated view, so `pm->ps` has no Swift form.
    // TODO: Port PM_GetOkWeaponForVehicle
    portMissing("PM_GetOkWeaponForVehicle", source: "oracle/codemp/game/bg_pmove.c:9762")
}

//force the vehicle to turn and travel to its forced destination point
/// Source: oracle/codemp/game/bg_pmove.c:9783
func PM_VehForcedTurning(_ veh: JKAMP.BgEntity) {
    // Port-note: `pmove_t` and `pml_t` have no generated views, so `pm` and `pml` have no Swift form.
    // TODO: Port PM_VehForcedTurning
    portMissing("PM_VehForcedTurning", source: "oracle/codemp/game/bg_pmove.c:9783")
}

/// Source: oracle/codemp/game/bg_pmove.c:9916
func PM_VehFaceHyperspacePoint(_ veh: JKAMP.BgEntity) {
    // Port-note: `pmove_t` and `pml_t` have no generated views, so `pm` and `pml` have no Swift form.
    // TODO: Port PM_VehFaceHyperspacePoint
    portMissing("PM_VehFaceHyperspacePoint", source: "oracle/codemp/game/bg_pmove.c:9916")
}

/// Source: oracle/codemp/game/bg_pmove.c:9993
// TODO: Port signature
// Raven wrote: void BG_VehicleAdjustBBoxForOrientation( Vehicle_t *veh, vec3_t origin, vec3_t mins, vec3_t maxs, int clientNum, int tracemask, void (*localTrace)(trace_t *results, const vec3_t start, const vec3_t mins, const vec3_t maxs, const vec3_t end, int passEntityNum, int contentMask))
// No table row for `void (*)(trace_t *, const vec_t *, const vec_t *, const vec_t *, const vec_t *, int, int) localTrace`.
func BG_VehicleAdjustBBoxForOrientation() -> Never {
    // Port-note: The generated signature is unmapped, because the `localTrace` function-pointer parameter has no table row.
    // TODO: Port BG_VehicleAdjustBBoxForOrientation
    portMissing("BG_VehicleAdjustBBoxForOrientation", source: "oracle/codemp/game/bg_pmove.c:9993")
}

/// Source: oracle/codemp/game/bg_pmove.c:10092
func PM_MoveForKata(_ ucmd: JKAMP.Usercmd) {
    // Port-note: `pmove_t` has no generated view, so `pm` has no Swift form.
    // TODO: Port PM_MoveForKata
    portMissing("PM_MoveForKata", source: "oracle/codemp/game/bg_pmove.c:10092")
}

/// Source: oracle/codemp/game/bg_pmove.c:10174
// TODO: Port signature
// Raven wrote: void PmoveSingle (pmove_t *pmove)
// No table row for `pmove_t * pmove`.
func PmoveSingle() -> Never {
    // Port-note: The generated signature is unmapped, because `pmove_t *pmove` has no table row and `pmove_t` has no generated view.
    // TODO: Port PmoveSingle
    portMissing("PmoveSingle", source: "oracle/codemp/game/bg_pmove.c:10174")
}

/**
================
Pmove

Can be called by either the server or the client
================
*/
/// Source: oracle/codemp/game/bg_pmove.c:11167
// TODO: Port signature
// Raven wrote: void Pmove (pmove_t *pmove)
// No table row for `pmove_t * pmove`.
func Pmove() -> Never {
    // Port-note: The generated signature is unmapped, because `pmove_t *pmove` has no table row and `pmove_t` has no generated view.
    // TODO: Port Pmove
    portMissing("Pmove", source: "oracle/codemp/game/bg_pmove.c:11167")
}
