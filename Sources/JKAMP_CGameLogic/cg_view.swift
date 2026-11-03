import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/cg_view.c:13
let MASK_CAMERACLIP = (JKAShared.MASK_SOLID | JKAShared.CONTENTS_PLAYERCLIP)

/// Source: oracle/codemp/cgame/cg_view.c:14
let CAMERA_SIZE = 4 as Int32

/// Source: oracle/codemp/cgame/cg_view.c:219
let CAMERA_DAMP_INTERVAL = 50 as Int32

/// Source: oracle/codemp/cgame/cg_view.c:221
/// Raven's data table, a hand property of `CGameWorld`.
var cameramins: JKAShared.vec3_t {
    get { world.cameramins }
    set { world.cameramins = newValue }
}

/// Source: oracle/codemp/cgame/cg_view.c:222
/// Raven's data table, a hand property of `CGameWorld`.
var cameramaxs: JKAShared.vec3_t {
    get { world.cameramaxs }
    set { world.cameramaxs = newValue }
}

/// Source: oracle/codemp/cgame/cg_view.c:223
var camerafwd: JKAShared.vec3_t {
    get { world.variables.camerafwd }
    set { world.variables.camerafwd = newValue }
}

/// Source: oracle/codemp/cgame/cg_view.c:223
var cameraup: JKAShared.vec3_t {
    get { world.variables.cameraup }
    set { world.variables.cameraup = newValue }
}

/// Source: oracle/codemp/cgame/cg_view.c:225
var cameraFocusAngles: JKAShared.vec3_t {
    get { world.variables.cameraFocusAngles }
    set { world.variables.cameraFocusAngles = newValue }
}

/// Source: oracle/codemp/cgame/cg_view.c:225
var cameraFocusLoc: JKAShared.vec3_t {
    get { world.variables.cameraFocusLoc }
    set { world.variables.cameraFocusLoc = newValue }
}

/// Source: oracle/codemp/cgame/cg_view.c:226
var cameraIdealTarget: JKAShared.vec3_t {
    get { world.variables.cameraIdealTarget }
    set { world.variables.cameraIdealTarget = newValue }
}

/// Source: oracle/codemp/cgame/cg_view.c:226
var cameraIdealLoc: JKAShared.vec3_t {
    get { world.variables.cameraIdealLoc }
    set { world.variables.cameraIdealLoc = newValue }
}

/// Source: oracle/codemp/cgame/cg_view.c:227
/// Raven's data table, a hand property of `CGameWorld`.
var cameraCurTarget: JKAShared.vec3_t {
    get { world.cameraCurTarget }
    set { world.cameraCurTarget = newValue }
}

/// Source: oracle/codemp/cgame/cg_view.c:227
/// Raven's data table, a hand property of `CGameWorld`.
var cameraCurLoc: JKAShared.vec3_t {
    get { world.cameraCurLoc }
    set { world.cameraCurLoc = newValue }
}

/// Source: oracle/codemp/cgame/cg_view.c:228
// Raven wrote: vec3_t cameraOldLoc={0,0,0}, cameraNewLoc={0,0,0}
let cameraOldLoc: JKAShared.vec3_t = { () -> JKAShared.vec3_t in portMissing("cameraOldLoc", source: "oracle/codemp/cgame/cg_view.c:228") }()

/// Source: oracle/codemp/cgame/cg_view.c:228
// Raven wrote: vec3_t cameraOldLoc={0,0,0}, cameraNewLoc={0,0,0}
let cameraNewLoc: JKAShared.vec3_t = { () -> JKAShared.vec3_t in portMissing("cameraNewLoc", source: "oracle/codemp/cgame/cg_view.c:228") }()

/// Source: oracle/codemp/cgame/cg_view.c:229
var cameraLastFrame: Int32 {
    get { world.variables.cameraLastFrame }
    set { world.variables.cameraLastFrame = newValue }
}

/// Source: oracle/codemp/cgame/cg_view.c:231
var cameraLastYaw: Float {
    get { world.variables.cameraLastYaw }
    set { world.variables.cameraLastYaw = newValue }
}

/// Source: oracle/codemp/cgame/cg_view.c:232
var cameraStiffFactor: Float {
    get { world.variables.cameraStiffFactor }
    set { world.variables.cameraStiffFactor = newValue }
}

/// Source: oracle/codemp/cgame/cg_view.c:1187
let WAVE_AMPLITUDE = 1 as Int32

/// Source: oracle/codemp/cgame/cg_view.c:1188
let WAVE_FREQUENCY = 0.4 as Double

/// Source: oracle/codemp/cgame/cg_view.c:1189
var zoomFov: Float {
    get { world.variables.zoomFov }
    set { world.variables.zoomFov = newValue }
}

/// Source: oracle/codemp/cgame/cg_view.c:1396
var cg_actionCamLastTime: Int32 {
    get { world.variables.cg_actionCamLastTime }
    set { world.variables.cg_actionCamLastTime = newValue }
}

/// Source: oracle/codemp/cgame/cg_view.c:1397
var cg_actionCamLastPos: JKAShared.vec3_t {
    get { world.variables.cg_actionCamLastPos }
    set { world.variables.cg_actionCamLastPos = newValue }
}

/// Source: oracle/codemp/cgame/cg_view.c:1476
/// Raven's data table, a hand property of `CGameWorld`.
var cg_lastTurretViewAngles: JKAShared.vec3_t {
    get { world.cg_lastTurretViewAngles }
    set { world.cg_lastTurretViewAngles = newValue }
}

/// Source: oracle/codemp/cgame/cg_view.c:2006
let CAMERA_DEFAULT_FOV = 90.0 as Float

/// Source: oracle/codemp/cgame/cg_view.c:2007
let MAX_SHAKE_INTENSITY = 16.0 as Float

/// Source: oracle/codemp/cgame/cg_view.c:2009
var cgScreenEffects: Cgscreffects { world.storage.cgScreenEffects }

/// Source: oracle/codemp/cgame/cg_view.c:2277
var cg_autoMapZoom: Float {
    get { world.variables.cg_autoMapZoom }
    set { world.variables.cg_autoMapZoom = newValue }
}

/// Source: oracle/codemp/cgame/cg_view.c:2278
// Raven wrote: float cg_autoMapZoomMainOffset = 0.0f
let cg_autoMapZoomMainOffset: Float = { () -> Float in portMissing("cg_autoMapZoomMainOffset", source: "oracle/codemp/cgame/cg_view.c:2278") }()

/// Source: oracle/codemp/cgame/cg_view.c:2279
/// Raven's data table, a hand property of `CGameWorld`.
var cg_autoMapAngle: JKAShared.vec3_t {
    get { world.cg_autoMapAngle }
    set { world.cg_autoMapAngle = newValue }
}

/// Source: oracle/codemp/cgame/cg_view.c:2280
var cg_autoMapInput: AutoMapInput { world.storage.cg_autoMapInput }

/// Source: oracle/codemp/cgame/cg_view.c:2281
var cg_autoMapInputTime: Int32 {
    get { world.variables.cg_autoMapInputTime }
    set { world.variables.cg_autoMapInputTime = newValue }
}

/// Source: oracle/codemp/cgame/cg_view.c:2282
let SIDEFRAME_WIDTH = 16 as Int32

/// Source: oracle/codemp/cgame/cg_view.c:2283
let SIDEFRAME_HEIGHT = 32 as Int32

/// Source: oracle/codemp/cgame/cg_view.c:2434
var cg_rangedFogging: Bool {
    get { world.variables.cg_rangedFogging }
    set { world.variables.cg_rangedFogging = newValue }
}

/// Source: oracle/codemp/cgame/cg_view.c:2435
var cg_linearFogOverride: Float {
    get { world.variables.cg_linearFogOverride }
    set { world.variables.cg_linearFogOverride = newValue }
}

/// Source: oracle/codemp/cgame/cg_view.c:2445
var cg_siegeClassIndex: Int32 {
    get { world.variables.cg_siegeClassIndex }
    set { world.variables.cg_siegeClassIndex = newValue }
}

/**
```
=================
CG_TestModel_f

Creates an entity in front of the current position, which
can then be moved around
=================
```
*/
/// Source: oracle/codemp/cgame/cg_view.c:60
func CG_TestModel_f() {
    var angles = vec3_t()

    cg.testModelEntity.clear()
    if trap_Argc() < 2 {
        return
    }

    Q_strncpyz(&cg.testModelNameBuffer, CG_Argv(1), MAX_QPATH)
    cg.testModelEntity.hModel = trap_R_RegisterModel(cg.testModelName)

    if trap_Argc() == 3 {
        cg.testModelEntity.backlerp = Float(atof(CG_Argv(2)))
        cg.testModelEntity.frame = 1
        cg.testModelEntity.oldframe = 0
    }
    if cg.testModelEntity.hModel == 0 {
        CG_Printf("Can't register model\n")
        return
    }

    _VectorMA(cg.refdef.vieworg, 100, cg.refdef.viewaxis[0], &cg.testModelEntity.origin)

    angles[PITCH] = 0
    angles[YAW] = 180 + cg.refdef.viewangles[1]
    angles[ROLL] = 0

    // Port-note: The draft of this statement did not compile, and the compiler wrote "'&' used with non-inout argument of type 'Slots<vec3_t>' (aka 'Slots<SIMD3<Float>>')".
    // Raven wrote: AnglesToAxis( angles, cg.testModelEntity.axis )
    portMissing("CG_TestModel_f", source: "oracle/codemp/cgame/cg_view.c:60")
    cg.testGun = false
}

/**
```
=================
CG_TestGun_f

Replaces the current view weapon with the given model
=================
```
*/
/// Source: oracle/codemp/cgame/cg_view.c:98
func CG_TestGun_f() {
    CG_TestModel_f()
    cg.testGun = true
    //cg.testModelEntity.renderfx = RF_MINLIGHT | RF_DEPTHHACK | RF_FIRST_PERSON;

    // rww - 9-13-01 [1-26-01-sof2]
    cg.testModelEntity.renderfx = RF_DEPTHHACK | RF_FIRST_PERSON
}

/// Source: oracle/codemp/cgame/cg_view.c:108
func CG_TestModelNextFrame_f() {
    cg.testModelEntity.frame += 1
    CG_Printf("frame %i\n", cg.testModelEntity.frame)
}

/// Source: oracle/codemp/cgame/cg_view.c:113
func CG_TestModelPrevFrame_f() {
    cg.testModelEntity.frame -= 1
    if cg.testModelEntity.frame < 0 {
        cg.testModelEntity.frame = 0
    }
    CG_Printf("frame %i\n", cg.testModelEntity.frame)
}

/// Source: oracle/codemp/cgame/cg_view.c:121
func CG_TestModelNextSkin_f() {
    cg.testModelEntity.skinNum += 1
    CG_Printf("skin %i\n", cg.testModelEntity.skinNum)
}

/// Source: oracle/codemp/cgame/cg_view.c:126
func CG_TestModelPrevSkin_f() {
    cg.testModelEntity.skinNum -= 1
    if cg.testModelEntity.skinNum < 0 {
        cg.testModelEntity.skinNum = 0
    }
    CG_Printf("skin %i\n", cg.testModelEntity.skinNum)
}

/// Source: oracle/codemp/cgame/cg_view.c:134
private func CG_AddTestModel() {
    var i: Int32

    // re-register the model, because the level may have changed
    cg.testModelEntity.hModel = trap_R_RegisterModel(cg.testModelName)
    if cg.testModelEntity.hModel == 0 {
        CG_Printf("Can't register model\n")
        return
    }

    // if testing a gun, set the origin reletive to the view origin
    if cg.testGun {
        cg.testModelEntity.origin = cg.refdef.vieworg
        cg.testModelEntity.axis[0] = cg.refdef.viewaxis[0]
        cg.testModelEntity.axis[1] = cg.refdef.viewaxis[1]
        cg.testModelEntity.axis[2] = cg.refdef.viewaxis[2]

        // allow the position to be adjusted
        i = 0
        while i < 3 {
            cg.testModelEntity.origin[i] += cg.refdef.viewaxis[0][i] * cg_gun_x.value
            cg.testModelEntity.origin[i] += cg.refdef.viewaxis[1][i] * cg_gun_y.value
            cg.testModelEntity.origin[i] += cg.refdef.viewaxis[2][i] * cg_gun_z.value
            i += 1
        }
    }

    trap_R_AddRefEntityToScene(cg.testModelEntity)
}

/**
```
=================
CG_CalcVrect

Sets the coordinates of the rendered window
=================
```
*/
/// Source: oracle/codemp/cgame/cg_view.c:174
private func CG_CalcVrect() {
    var size: Int32

    // the intermission should allways be full screen
    if cg.snap!.ps.pm_type == PM_INTERMISSION {
        size = 100
    } else {
        // bound normal viewsize
        if cg_viewsize.integer < 30 {
            trap_Cvar_Set("cg_viewsize", "30")
            size = 30
        } else if cg_viewsize.integer > 100 {
            trap_Cvar_Set("cg_viewsize", "100")
            size = 100
        } else {
            size = cg_viewsize.integer
        }
    }
    cg.refdef.width = cgs.glconfig.vidWidth * size / 100
    cg.refdef.width &= ~1

    cg.refdef.height = cgs.glconfig.vidHeight * size / 100
    cg.refdef.height &= ~1

    cg.refdef.x = (cgs.glconfig.vidWidth - cg.refdef.width) / 2
    cg.refdef.y = (cgs.glconfig.vidHeight - cg.refdef.height) / 2
}

//==============================================================================
//==============================================================================
// this causes a compiler bug on mac MrC compiler
/// Source: oracle/codemp/cgame/cg_view.c:208
private func CG_StepOffset() {
    let timeDelta: Int32

    // smooth out stair climbing
    timeDelta = cg.time - cg.stepTime
    if timeDelta < STEP_TIME {
        cg.refdef.vieworg[2] -= cg.stepChange * (STEP_TIME - timeDelta) / STEP_TIME
    }
}

/**
```
===============
CG_CalcTargetThirdPersonViewLocation

===============
```
*/
/// Source: oracle/codemp/cgame/cg_view.c:257
private func CG_CalcIdealThirdPersonViewTarget() {
    // Initialize IdealTarget
    if gCGHasFallVector {
        cameraFocusLoc = gCGFallVector
    } else {
        cameraFocusLoc = cg.refdef.vieworg
    }

    // Add in the new viewheight
    cameraFocusLoc[2] += cg.snap!.ps.viewheight

    // Add in a vertical offset from the viewpoint, which puts the actual target above the head, regardless of angle.
    //	VectorMA(cameraFocusLoc, thirdPersonVertOffset, cameraup, cameraIdealTarget);

    // Add in a vertical offset from the viewpoint, which puts the actual target above the head, regardless of angle.
    cameraIdealTarget = cameraFocusLoc

    do {
        var vertOffset: Float = cg_thirdPersonVertOffset.value

        if cg.snap != nil && cg.snap!.ps.m_iVehicleNum != 0 {
            let veh: Centity? = cg_entities[cg.snap!.ps.m_iVehicleNum]
            if veh!.m_pVehicle != nil && veh!.m_pVehicle!.m_pVehicleInfo!.cameraOverride {
                //override the range with what the vehicle wants it to be
                if veh!.m_pVehicle!.m_pVehicleInfo!.cameraPitchDependantVertOffset {
                    if cg.snap!.ps.viewangles[PITCH] > 0 {
                        vertOffset = 130 + cg.predictedPlayerState.viewangles[PITCH] * -10
                        if vertOffset < -170 {
                            vertOffset = -170
                        }
                    } else if cg.snap!.ps.viewangles[PITCH] < 0 {
                        vertOffset = 130 + cg.predictedPlayerState.viewangles[PITCH] * -5
                        if vertOffset > 130 {
                            vertOffset = 130
                        }
                    } else {
                        vertOffset = 30
                    }
                } else {
                    vertOffset = veh!.m_pVehicle!.m_pVehicleInfo!.cameraVertOffset
                }
            } else if veh!.m_pVehicle != nil && veh!.m_pVehicle!.m_pVehicleInfo != nil && veh!.m_pVehicle!.m_pVehicleInfo!.type == VH_ANIMAL {
                vertOffset = 0
            }
        }
        cameraIdealTarget[2] += vertOffset
    }
    //VectorMA(cameraFocusLoc, cg_thirdPersonVertOffset.value, cameraup, cameraIdealTarget);
}

/**
```
===============
CG_CalcTargetThirdPersonViewLocation

===============
```
*/
/// Source: oracle/codemp/cgame/cg_view.c:335
private func CG_CalcIdealThirdPersonViewLocation() {
    var thirdPersonRange: Float = cg_thirdPersonRange.value

    if cg.snap != nil && cg.snap!.ps.m_iVehicleNum != 0 {
        let veh: Centity? = cg_entities[cg.snap!.ps.m_iVehicleNum]
        if veh!.m_pVehicle != nil && veh!.m_pVehicle!.m_pVehicleInfo!.cameraOverride {
            //override the range with what the vehicle wants it to be
            thirdPersonRange = veh!.m_pVehicle!.m_pVehicleInfo!.cameraRange
            if veh!.playerState!.hackingTime != 0 {
                thirdPersonRange += abs((Float(veh!.playerState!.hackingTime)) / MAX_STRAFE_TIME) * 100.0
            }
        }
    }

    if cg.snap != nil && (cg.snap!.ps.eFlags2 & EF2_HELD_BY_MONSTER) != 0 && cg.snap!.ps.hasLookTarget && cg_entities[cg.snap!.ps.lookTarget].currentState.NPC_class == CLASS_RANCOR {
        //stay back
        //thirdPersonRange = 180.0f;
        thirdPersonRange = 120.0
    }

    _VectorMA(cameraIdealTarget, -(thirdPersonRange), camerafwd, &cameraIdealLoc)
}

/// Source: oracle/codemp/cgame/cg_view.c:367
private func CG_ResetThirdPersonViewDamp() {
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { trace in

        // Cap the pitch within reasonable limits
        if Double(cameraFocusAngles[PITCH]) > 89.0 {
            cameraFocusAngles[PITCH] = 89.0
        } else if Double(cameraFocusAngles[PITCH]) < -89.0 {
            cameraFocusAngles[PITCH] = -89.0
        }

        // Raven passes NULL for the `right` output.
        var scratchRight = vec3_t()
        AngleVectors(cameraFocusAngles, &camerafwd, &scratchRight, &cameraup)

        // Set the cameraIdealTarget
        CG_CalcIdealThirdPersonViewTarget()

        // Set the cameraIdealLoc
        CG_CalcIdealThirdPersonViewLocation()

        // Now, we just set everything to the new positions.
        cameraCurLoc = cameraIdealLoc
        cameraCurTarget = cameraIdealTarget

        // First thing we do is trace from the first person viewpoint out to the new target location.
        CG_Trace(trace, cameraFocusLoc, cameramins, cameramaxs, cameraCurTarget, cg.snap!.ps.clientNum, MASK_CAMERACLIP)
        if Double(trace.fraction) <= 1.0 {
            cameraCurTarget = trace.endpos
        }

        // Now we trace from the new target location to the new view location, to make sure there is nothing in the way.
        CG_Trace(trace, cameraCurTarget, cameramins, cameramaxs, cameraCurLoc, cg.snap!.ps.clientNum, MASK_CAMERACLIP)
        if Double(trace.fraction) <= 1.0 {
            cameraCurLoc = trace.endpos
        }

        cameraLastFrame = cg.time
        cameraLastYaw = cameraFocusAngles[YAW]
        cameraStiffFactor = 0.0
    }
}

// This is called every frame.
/// Source: oracle/codemp/cgame/cg_view.c:413
private func CG_UpdateThirdPersonTargetDamp() {
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { trace in
        var targetdiff = vec3_t()
        var dampfactor: Float = 0
        var dtime: Float = 0
        var ratio: Float = 0

        // Set the cameraIdealTarget
        // Automatically get the ideal target, to avoid jittering.
        CG_CalcIdealThirdPersonViewTarget()

        if cg.predictedVehicleState.hyperSpaceTime != 0 && (cg.time - cg.predictedVehicleState.hyperSpaceTime) < HYPERSPACE_TIME {
            //hyperspacing, no damp
            cameraCurTarget = cameraIdealTarget
        } else if Double(cg_thirdPersonTargetDamp.value) >= 1.0 || cg.thisFrameTeleport || cg.predictedPlayerState.m_iVehicleNum != 0 {
            // No damping.
            cameraCurTarget = cameraIdealTarget
        } else if Double(cg_thirdPersonTargetDamp.value) >= 0.0 {
            // Calculate the difference from the current position to the new one.
            targetdiff = cameraIdealTarget - cameraCurTarget

            // Now we calculate how much of the difference we cover in the time allotted.
            // The equation is (Damp)^(time)
            dampfactor = Float(1.0 - Double(cg_thirdPersonTargetDamp.value)) // We must exponent the amount LEFT rather than the amount bled off
            dtime = Float(Double(Float((cg.time - cameraLastFrame))) * (1.0 / Double(Float(CAMERA_DAMP_INTERVAL)))) // Our dampfactor is geared towards a time interval equal to "1".

            // Note that since there are a finite number of "practical" delta millisecond values possible,
            // the ratio should be initialized into a chart ultimately.
            ratio = powf(dampfactor, Int32(dtime))

            // This value is how much distance is "left" from the ideal.
            _VectorMA(cameraIdealTarget, -ratio, targetdiff, &cameraCurTarget)
            /////////////////////////////////////////////////////////////////////////////////////////////////////////
        }

        // Now we trace to see if the new location is cool or not.

        // First thing we do is trace from the first person viewpoint out to the new target location.
        CG_Trace(trace, cameraFocusLoc, cameramins, cameramaxs, cameraCurTarget, cg.snap!.ps.clientNum, MASK_CAMERACLIP)
        if Double(trace.fraction) < 1.0 {
            cameraCurTarget = trace.endpos
        }

        // Note that previously there was an upper limit to the number of physics traces that are done through the world
        // for the sake of camera collision, since it wasn't calced per frame.  Now it is calculated every frame.
        // This has the benefit that the camera is a lot smoother now (before it lerped between tested points),
        // however two full volume traces each frame is a bit scary to think about.
    }
}

/// Source: oracle/codemp/cgame/cg_view.c:468
private func CG_UpdateThirdPersonCameraDamp() {
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { trace in
        var locdiff = vec3_t()
        var dampfactor: Float = 0
        var dtime: Float = 0
        var ratio: Float = 0

        // Set the cameraIdealLoc
        CG_CalcIdealThirdPersonViewLocation()


        // First thing we do is calculate the appropriate damping factor for the camera.
        dampfactor = 0.0
        if cg.predictedVehicleState.hyperSpaceTime != 0 && (cg.time - cg.predictedVehicleState.hyperSpaceTime) < HYPERSPACE_TIME {
            //hyperspacing - don't damp camera
            dampfactor = 1.0
        } else if Double(cg_thirdPersonCameraDamp.value) != 0.0 {
            var pitch: Float = 0
            var dFactor: Float = 0

            if cg.predictedPlayerState.m_iVehicleNum == 0 {
                dFactor = cg_thirdPersonCameraDamp.value
            } else {
                dFactor = 1.0
            }

            // Note that the camera pitch has already been capped off to 89.
            pitch = Q_fabs(cameraFocusAngles[PITCH])

            // The higher the pitch, the larger the factor, so as you look up, it damps a lot less.
            pitch = Float(Double(pitch) / 115.0)
            dampfactor = Float((1.0 - Double(dFactor)) * Double(pitch * pitch))

            dampfactor += dFactor

            // Now we also multiply in the stiff factor, so that faster yaw changes are stiffer.
            if cameraStiffFactor > 0.0 {
                // The cameraStiffFactor is how much of the remaining damp below 1 should be shaved off, i.e. approach 1 as stiffening increases.
                dampfactor = Float(Double(dampfactor) + ((1.0 - Double(dampfactor)) * Double(cameraStiffFactor)))
            }
        }

        if Double(dampfactor) >= 1.0 || cg.thisFrameTeleport {
            // No damping.
            cameraCurLoc = cameraIdealLoc
        } else if Double(dampfactor) >= 0.0 {
            // Calculate the difference from the current position to the new one.
            locdiff = cameraIdealLoc - cameraCurLoc

            // Now we calculate how much of the difference we cover in the time allotted.
            // The equation is (Damp)^(time)
            dampfactor = Float(1.0 - Double(dampfactor)) // We must exponent the amount LEFT rather than the amount bled off
            dtime = Float(Double(Float((cg.time - cameraLastFrame))) * (1.0 / Double(Float(CAMERA_DAMP_INTERVAL)))) // Our dampfactor is geared towards a time interval equal to "1".

            // Note that since there are a finite number of "practical" delta millisecond values possible,
            // the ratio should be initialized into a chart ultimately.
            ratio = powf(dampfactor, Int32(dtime))

            // This value is how much distance is "left" from the ideal.
            _VectorMA(cameraIdealLoc, -ratio, locdiff, &cameraCurLoc)
            /////////////////////////////////////////////////////////////////////////////////////////////////////////
        }

        // Now we trace from the new target location to the new view location, to make sure there is nothing in the way.
        CG_Trace(trace, cameraCurTarget, cameramins, cameramaxs, cameraCurLoc, cg.snap!.ps.clientNum, MASK_CAMERACLIP)

        if Double(trace.fraction) < 1.0 {
            if trace.entityNum < ENTITYNUM_WORLD && cg_entities[trace.entityNum].currentState.solid == SOLID_BMODEL && cg_entities[trace.entityNum].currentState.eType == ET_MOVER {
                //get a different position for movers -rww
                let mover: Centity? = cg_entities[trace.entityNum]

                //this is absolutely hackiful, since we calc view values before we add packet ents and lerp,
                //if we hit a mover we want to update its lerp pos and force it when we do the trace against
                //it.
                if mover!.currentState.pos.trType != TR_STATIONARY && mover!.currentState.pos.trType != TR_LINEAR {
                    let curTr: Int32 = mover!.currentState.pos.trType
                    var curTrB = vec3_t()

                    curTrB = mover!.currentState.pos.trBase

                    //calc lerporigin for this client frame
                    CG_CalcEntityLerpPositions(mover!)

                    //force the calc'd lerp to be the base and say we are stationary so we don't try to extrapolate
                    //out further.
                    mover!.currentState.pos.trType = TR_STATIONARY
                    mover!.currentState.pos.trBase = mover!.lerpOrigin

                    //retrace
                    CG_Trace(trace, cameraCurTarget, cameramins, cameramaxs, cameraCurLoc, cg.snap!.ps.clientNum, MASK_CAMERACLIP)

                    //copy old data back in
                    mover!.currentState.pos.trType = trType_t(curTr)
                    mover!.currentState.pos.trBase = curTrB
                }
                if trace.fraction < 1.0 {
                    //still hit it, so take the proper trace endpos and use that.
                    cameraCurLoc = trace.endpos
                }
            } else {
                cameraCurLoc = trace.endpos
            }
        }

        // Note that previously there was an upper limit to the number of physics traces that are done through the world
        // for the sake of camera collision, since it wasn't calced per frame.  Now it is calculated every frame.
        // This has the benefit that the camera is a lot smoother now (before it lerped between tested points),
        // however two full volume traces each frame is a bit scary to think about.
    }
}

/// Source: oracle/codemp/cgame/cg_view.c:603
private func CG_OffsetThirdPersonView() {
    var diff = vec3_t()
    var thirdPersonHorzOffset: Float = cg_thirdPersonHorzOffset.value
    var deltayaw: Float

    if cg.snap != nil && cg.snap!.ps.m_iVehicleNum != 0 {
        let veh: Centity? = cg_entities[cg.snap!.ps.m_iVehicleNum]
        if veh!.m_pVehicle != nil && veh!.m_pVehicle!.m_pVehicleInfo!.cameraOverride {
            //override the range with what the vehicle wants it to be
            thirdPersonHorzOffset = veh!.m_pVehicle!.m_pVehicleInfo!.cameraHorzOffset
            if veh!.playerState!.hackingTime != 0 {
                thirdPersonHorzOffset += ((Float(veh!.playerState!.hackingTime)) / MAX_STRAFE_TIME) * -80.0
            }
        }
    }

    cameraStiffFactor = 0.0

    // Set camera viewing direction.
    cameraFocusAngles = cg.refdef.viewangles

    // if dead, look at killer
    if cg.snap != nil && (cg.snap!.ps.eFlags2 & EF2_HELD_BY_MONSTER) != 0 && cg.snap!.ps.hasLookTarget && cg_entities[cg.snap!.ps.lookTarget].currentState.NPC_class == CLASS_RANCOR {
        //being held
        //vec3_t monsterPos, dir2Me;
        let monster: Centity? = cg_entities[cg.snap!.ps.lookTarget]
        cameraFocusAngles = vec3_t(0, AngleNormalize180(monster!.lerpAngles[YAW] + 180), 0)
        //make the look angle the vector from his mouth to me
        /*
        VectorCopy( monster->lerpOrigin, monsterPos );
        monsterPos[2] = cg.snap->ps.origin[2];
        VectorSubtract( monsterPos, cg.snap->ps.origin, dir2Me );
        vectoangles( dir2Me, cameraFocusAngles );
        */
    } else if cg.snap!.ps.stats[STAT_HEALTH] <= 0 {
        cameraFocusAngles[YAW] = Float(cg.snap!.ps.stats[STAT_DEAD_YAW])
    } else {
        // Add in the third Person Angle.
        cameraFocusAngles[YAW] += cg_thirdPersonAngle.value
        do {
            var pitchOffset: Float = cg_thirdPersonPitchOffset.value
            if cg.snap != nil && cg.snap!.ps.m_iVehicleNum != 0 {
                let veh: Centity? = cg_entities[cg.snap!.ps.m_iVehicleNum]
                if veh!.m_pVehicle != nil && veh!.m_pVehicle!.m_pVehicleInfo!.cameraOverride {
                    //override the range with what the vehicle wants it to be
                    if veh!.m_pVehicle!.m_pVehicleInfo!.cameraPitchDependantVertOffset {
                        if cg.snap!.ps.viewangles[PITCH] > 0 {
                            pitchOffset = Float(Double(cg.predictedPlayerState.viewangles[PITCH]) * -0.75)
                        } else if cg.snap!.ps.viewangles[PITCH] < 0 {
                            pitchOffset = Float(Double(cg.predictedPlayerState.viewangles[PITCH]) * -0.75)
                        } else {
                            pitchOffset = 0
                        }
                    } else {
                        pitchOffset = veh!.m_pVehicle!.m_pVehicleInfo!.cameraPitchOffset
                    }
                }
            }
            if 0 != 0 && cg.predictedPlayerState.m_iVehicleNum != 0 && BG_UnrestrainedPitchRoll(cg.predictedPlayerState, cg_entities[cg.predictedPlayerState.m_iVehicleNum].m_pVehicle) {
                let pitchPerc: Float = ((90.0 - abs(cameraFocusAngles[ROLL])) / 90.0)
                cameraFocusAngles[PITCH] += pitchOffset * pitchPerc
                if cameraFocusAngles[ROLL] > 0 {
                    cameraFocusAngles[YAW] -= pitchOffset - (pitchOffset * pitchPerc)
                } else {
                    cameraFocusAngles[YAW] += pitchOffset - (pitchOffset * pitchPerc)
                }
            } else {
                cameraFocusAngles[PITCH] += pitchOffset
            }
        }
    }

    // The next thing to do is to see if we need to calculate a new camera target location.

    // If we went back in time for some reason, or if we just started, reset the sample.
    if cameraLastFrame == 0 || cameraLastFrame > cg.time {
        CG_ResetThirdPersonViewDamp()
    } else {
        // Cap the pitch within reasonable limits
        if cg.predictedPlayerState.m_iVehicleNum != 0 && BG_UnrestrainedPitchRoll(cg.predictedPlayerState, cg_entities[cg.predictedPlayerState.m_iVehicleNum].m_pVehicle) {
            //no clamp on pitch
            //FIXME: when pitch >= 90 or <= -90, camera rotates oddly... need to CrossProduct not just vectoangles
        } else {
            if Double(cameraFocusAngles[PITCH]) > 80.0 {
                cameraFocusAngles[PITCH] = 80.0
            } else if Double(cameraFocusAngles[PITCH]) < -80.0 {
                cameraFocusAngles[PITCH] = -80.0
            }
        }

        // Raven passes NULL for the `right` output.
        var scratchRight = vec3_t()
        AngleVectors(cameraFocusAngles, &camerafwd, &scratchRight, &cameraup)

        deltayaw = abs(cameraFocusAngles[YAW] - cameraLastYaw)
        if deltayaw > 180.0 {
            // Normalize this angle so that it is between 0 and 180.
            deltayaw = abs(deltayaw - 360.0)
        }
        cameraStiffFactor = deltayaw / Float((cg.time - cameraLastFrame))
        if Double(cameraStiffFactor) < 1.0 {
            cameraStiffFactor = 0.0
        } else if Double(cameraStiffFactor) > 2.5 {
            cameraStiffFactor = 0.75
        } else {
            // 1 to 2 scales from 0.0 to 0.5
            cameraStiffFactor = (cameraStiffFactor - 1.0) * 0.5
        }
        cameraLastYaw = cameraFocusAngles[YAW]

        // Move the target to the new location.
        CG_UpdateThirdPersonTargetDamp()
        CG_UpdateThirdPersonCameraDamp()
    }

    // Now interestingly, the Quake method is to calculate a target focus point above the player, and point the camera at it.
    // We won't do that for now.

    // We must now take the angle taken from the camera target and location.
    /*VectorSubtract(cameraCurTarget, cameraCurLoc, diff);
    VectorNormalize(diff);
    vectoangles(diff, cg.refdef.viewangles);*/
    diff = cameraCurTarget - cameraCurLoc
    do {
        let dist: Float = VectorNormalize(&diff)
        //under normal circumstances, should never be 0.00000 and so on.
        if dist == 0 || (diff[0] == 0 || diff[1] == 0) {
            //must be hitting something, need some value to calc angles, so use cam forward
            diff = camerafwd
        }
    }
    if 0 != 0 && cg.predictedPlayerState.m_iVehicleNum != 0 && BG_UnrestrainedPitchRoll(cg.predictedPlayerState, cg_entities[cg.predictedPlayerState.m_iVehicleNum].m_pVehicle) {
        //FIXME: this causes camera jerkiness, need to blend the roll?
        let sav_Roll: Float = cg.refdef.viewangles[ROLL]
        vectoangles(diff, &cg.refdef.viewangles)
        cg.refdef.viewangles[ROLL] = sav_Roll
    } else {
        vectoangles(diff, &cg.refdef.viewangles)
    }

    // Temp: just move the camera to the side a bit
    if thirdPersonHorzOffset != 0.0 {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "'&' used with non-inout argument of type 'Slots<vec3_t>' (aka 'Slots<SIMD3<Float>>')".
        // Raven wrote: AnglesToAxis( cg.refdef.viewangles, cg.refdef.viewaxis )
        portMissing("CG_OffsetThirdPersonView", source: "oracle/codemp/cgame/cg_view.c:603")
        _VectorMA(cameraCurLoc, thirdPersonHorzOffset, cg.refdef.viewaxis[1], &cameraCurLoc)
    }

    // ...and of course we should copy the new view location to the proper spot too.
    cg.refdef.vieworg = cameraCurLoc

    cameraLastFrame = cg.time
}

/// Source: oracle/codemp/cgame/cg_view.c:797
func CG_GetVehicleCamPos(_ camPos: inout JKAShared.vec3_t) {
    camPos = cg.refdef.vieworg
}

/**
```
===============
CG_OffsetFirstPersonView

===============
```
*/
/// Source: oracle/codemp/cgame/cg_view.c:899
private func CG_OffsetFirstPersonView() {
    var bob: Float
    var ratio: Float
    var delta: Float
    let speed: Float
    let f: Float
    var predictedVelocity = vec3_t()
    let timeDelta: Int32
    var kickTime: Int32

    if cg.snap!.ps.pm_type == PM_INTERMISSION {
        return
    }


    // if dead, fix the angle and don't add any kick
    if cg.snap!.ps.stats[STAT_HEALTH] <= 0 {
        cg.refdef.viewangles[ROLL] = 40
        cg.refdef.viewangles[PITCH] = -15
        cg.refdef.viewangles[YAW] = Float(cg.snap!.ps.stats[STAT_DEAD_YAW])
        cg.refdef.vieworg[2] += cg.predictedPlayerState.viewheight
        return
    }

    // add angles based on weapon kick
    kickTime = (cg.time - cg.kick_time)
    if kickTime < 800 {
        //kicks are always 1 second long.  Deal with it.
        var kickPerc: Float = 0.0
        if kickTime <= 200 {
            //winding up
            kickPerc = kickTime / 200.0
        } else {
            //returning to normal
            kickTime = 800 - kickTime
            kickPerc = kickTime / 600.0
        }
        _VectorMA(cg.refdef.viewangles, kickPerc, cg.kick_angles, &cg.refdef.viewangles)
    }
    // add angles based on damage kick
    if cg.damageTime != 0 {
        ratio = cg.time - cg.damageTime
        if ratio < DAMAGE_DEFLECT_TIME {
            ratio /= DAMAGE_DEFLECT_TIME
            cg.refdef.viewangles[PITCH] += ratio * cg.v_dmg_pitch
            cg.refdef.viewangles[ROLL] += ratio * cg.v_dmg_roll
        } else {
            ratio = Float(1.0 - Double((ratio - DAMAGE_DEFLECT_TIME) / DAMAGE_RETURN_TIME))
            if ratio > 0 {
                cg.refdef.viewangles[PITCH] += ratio * cg.v_dmg_pitch
                cg.refdef.viewangles[ROLL] += ratio * cg.v_dmg_roll
            }
        }
    }

    // add pitch based on fall kick

    // add angles based on velocity
    predictedVelocity = cg.predictedPlayerState.velocity

    delta = _DotProduct(predictedVelocity, cg.refdef.viewaxis[0])
    cg.refdef.viewangles[PITCH] += delta * cg_runpitch.value

    delta = _DotProduct(predictedVelocity, cg.refdef.viewaxis[1])
    cg.refdef.viewangles[ROLL] -= delta * cg_runroll.value

    // add angles based on bob

    // make sure the bob is visible even at low speeds
    speed = cg.xyspeed > 200 ? cg.xyspeed : 200

    delta = cg.bobfracsin * cg_bobpitch.value * speed
    if (cg.predictedPlayerState.pm_flags & PMF_DUCKED) != 0 {
        delta *= 3 // crouching
    }
    cg.refdef.viewangles[PITCH] += delta
    delta = cg.bobfracsin * cg_bobroll.value * speed
    if (cg.predictedPlayerState.pm_flags & PMF_DUCKED) != 0 {
        delta *= 3 // crouching accentuates roll
    }
    if (cg.bobcycle & 1) != 0 {
        delta = -delta
    }
    cg.refdef.viewangles[ROLL] += delta

    //===================================

    // add view height
    cg.refdef.vieworg[2] += cg.predictedPlayerState.viewheight

    // smooth out duck height changes
    timeDelta = cg.time - cg.duckTime
    if timeDelta < DUCK_TIME {
        cg.refdef.vieworg[2] -= cg.duckChange * (DUCK_TIME - timeDelta) / DUCK_TIME
    }

    // add bob height
    bob = cg.bobfracsin * cg.xyspeed * cg_bobup.value
    if bob > 6 {
        bob = 6
    }

    cg.refdef.vieworg[2] += bob


    // add fall height
    delta = Float(cg.time - cg.landTime)
    if delta < LAND_DEFLECT_TIME {
        f = delta / LAND_DEFLECT_TIME
        cg.refdef.vieworg[2] += cg.landChange * f
    } else if delta < LAND_DEFLECT_TIME + LAND_RETURN_TIME {
        delta -= LAND_DEFLECT_TIME
        f = Float(1.0 - Double(delta / LAND_RETURN_TIME))
        cg.refdef.vieworg[2] += cg.landChange * f
    }

    // add step offset
    CG_StepOffset()

    // add kick offset

    cg.refdef.vieworg = cg.refdef.vieworg + cg.kick_origin

    // pivot the eye based on a neck length
}

/// Source: oracle/codemp/cgame/cg_view.c:1045
private func CG_OffsetFighterView() {
    var vehFwd = vec3_t()
    var vehRight = vec3_t()
    var vehUp = vec3_t()
    var backDir = vec3_t()
    var camOrg = vec3_t()
    var camBackOrg = vec3_t()
    var horzOffset: Float = cg_thirdPersonHorzOffset.value
    var vertOffset: Float = cg_thirdPersonVertOffset.value
    var pitchOffset: Float = cg_thirdPersonPitchOffset.value
    let yawOffset: Float = cg_thirdPersonAngle.value
    var range: Float = cg_thirdPersonRange.value
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { trace in
        let veh: Centity? = cg_entities[cg.predictedPlayerState.m_iVehicleNum]

        AngleVectors(cg.refdef.viewangles, &vehFwd, &vehRight, &vehUp)

        if veh!.m_pVehicle != nil && veh!.m_pVehicle!.m_pVehicleInfo!.cameraOverride {
            //override the horizontal offset with what the vehicle wants it to be
            horzOffset = veh!.m_pVehicle!.m_pVehicleInfo!.cameraHorzOffset
            vertOffset = veh!.m_pVehicle!.m_pVehicleInfo!.cameraVertOffset
            //NOTE: no yaw offset?
            pitchOffset = veh!.m_pVehicle!.m_pVehicleInfo!.cameraPitchOffset
            range = veh!.m_pVehicle!.m_pVehicleInfo!.cameraRange
            if veh!.playerState!.hackingTime != 0 {
                horzOffset += ((Float(veh!.playerState!.hackingTime)) / MAX_STRAFE_TIME) * -80.0
                range += abs((Float(veh!.playerState!.hackingTime)) / MAX_STRAFE_TIME) * 100.0
            }
        }

        //Set camera viewing position
        _VectorMA(cg.refdef.vieworg, horzOffset, vehRight, &camOrg)
        _VectorMA(camOrg, vertOffset, vehUp, &camOrg)

        //trace to that pos
        CG_Trace(trace, cg.refdef.vieworg, cameramins, cameramaxs, camOrg, cg.snap!.ps.clientNum, MASK_CAMERACLIP)
        if Double(trace.fraction) < 1.0 {
            camOrg = trace.endpos
        }

        // Set camera viewing direction.
        cg.refdef.viewangles[YAW] += yawOffset
        cg.refdef.viewangles[PITCH] += pitchOffset

        //Now bring the cam back from that pos and angles at range
        // Raven passes NULL for the `right` and `up` outputs.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(cg.refdef.viewangles, &backDir, &scratchRight, &scratchUp)
        backDir = backDir * -1

        _VectorMA(camOrg, range, backDir, &camBackOrg)

        //trace to that pos
        CG_Trace(trace, camOrg, cameramins, cameramaxs, camBackOrg, cg.snap!.ps.clientNum, MASK_CAMERACLIP)
        camOrg = trace.endpos

        //FIXME: do we need to smooth the org?
        // ...and of course we should copy the new view location to the proper spot too.
        cg.refdef.vieworg = camOrg
    }
}

/// Source: oracle/codemp/cgame/cg_view.c:1105
func CG_ZoomDown_f() {
    if cg.zoomed {
        return
    }
    cg.zoomed = true
    cg.zoomTime = cg.time
}

/// Source: oracle/codemp/cgame/cg_view.c:1113
func CG_ZoomUp_f() {
    if !cg.zoomed {
        return
    }
    cg.zoomed = false
    cg.zoomTime = cg.time
}

/**
```
====================
CG_CalcFovFromX

Calcs Y FOV from given X FOV
====================
```
*/
/// Source: oracle/codemp/cgame/cg_view.c:1130
func CG_CalcFOVFromX(_ fov_x: Float) -> Bool {
    let x: Float
    //	float	phase;
    //	float	v;
    //	int		contents;
    var fov_y: Float
    let inwater: Bool

    x = Float(Double(cg.refdef.width) / tan(Double(fov_x / 360) * M_PI))
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Int32' to expected argument type 'Float'".
    // Raven wrote: fov_y = atan2( cg.refdef.height, x )
    portMissing("CG_CalcFOVFromX", source: "oracle/codemp/cgame/cg_view.c:1130")
    fov_y = Float(Double(fov_y * 360) / M_PI)

    // there's a problem with this, it only takes the leafbrushes into account, not the entity brushes,
    //	so if you give slime/water etc properties to a func_door area brush in order to move the whole water
    //	level up/down this doesn't take into account the door position, so warps the view the whole time
    //	whether the water is up or not. Fortunately there's only one slime area in Trek that you can be under,
    //	so lose it...
    /*
    // warp if underwater
    contents = CG_PointContents( cg.refdef.vieworg, -1 );
    if ( contents & ( CONTENTS_WATER | CONTENTS_SLIME | CONTENTS_LAVA ) ){
    phase = cg.time / 1000.0 * WAVE_FREQUENCY * M_PI * 2;
    v = WAVE_AMPLITUDE * sin( phase );
    fov_x += v;
    fov_y -= v;
    inwater = qtrue;
    }
    else {
    inwater = qfalse;
    }
    */
    inwater = false


    // set it
    cg.refdef.fov_x = fov_x
    cg.refdef.fov_y = fov_y


    return (inwater)
}

/// Source: oracle/codemp/cgame/cg_view.c:1191
private func CG_CalcFov() -> Int32 {
    let x: Float
    let phase: Float
    let v: Float
    var fov_x: Float
    var fov_y: Float
    let f: Float
    let inwater: Int32
    var cgFov: Float = cg_fov.value

    if cgFov < 1 {
        cgFov = 1
    }
    if cgFov > 97 {
        cgFov = 97
    }

    if cg.predictedPlayerState.pm_type == PM_INTERMISSION {
        // if in intermission, use a fixed value
        fov_x = 80 //90;
    } else {
        // user selectable
        if (cgs.dmflags & DF_FIXED_FOV) != 0 {
            // dmflag to prevent wide fov for all clients
            fov_x = 80 //90;
        } else {
            fov_x = cgFov
            if fov_x < 1 {
                fov_x = 1
            } else if fov_x > 160 {
                fov_x = 160
            }
        }

        if cg.predictedPlayerState.zoomMode == 2 {
            //binoculars
            if zoomFov > 40.0 {
                zoomFov -= cg.frametime * 0.075

                if zoomFov < 40.0 {
                    zoomFov = 40.0
                } else if zoomFov > cgFov {
                    zoomFov = cgFov
                }
            }

            fov_x = zoomFov
        } else if cg.predictedPlayerState.zoomMode != 0 {
            if !cg.predictedPlayerState.zoomLocked {
                if zoomFov > 50 {
                    //Now starting out at nearly half zoomed in
                    zoomFov = 50
                }
                zoomFov -= cg.frametime * 0.035 //0.075f;

                if zoomFov < MAX_ZOOM_FOV {
                    zoomFov = MAX_ZOOM_FOV
                } else if zoomFov > cgFov {
                    zoomFov = cgFov
                } else {
                    // Still zooming
                    // Port-note: A static local `zoomSoundTime` a statement reads before it writes, storage that outlives the call.
                    // Raven wrote: static int zoomSoundTime = 0;
                    portMissing("CG_CalcFov", source: "oracle/codemp/cgame/cg_view.c:1191")

                    // Port-note: A read of `zoomSoundTime`, a local the draft left as a hole.
                    // Raven wrote: if (zoomSoundTime < cg.time || zoomSoundTime > cg.time + 10000) { trap_S_StartSound(cg.refdef.vieworg, ENTITYNUM_WORLD, CHAN_LOCAL, cgs.media.disruptorZoomLoop); zoomSoundTime = cg.time + 300; }
                    portMissing("CG_CalcFov", source: "oracle/codemp/cgame/cg_view.c:1191")
                }
            }

            if zoomFov < MAX_ZOOM_FOV {
                zoomFov = 50 // hack to fix zoom during vid restart
            }
            fov_x = zoomFov
        } else {
            zoomFov = 80

            f = (cg.time - cg.predictedPlayerState.zoomTime) / ZOOM_OUT_TIME
            if Double(f) > 1.0 {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "assigning a variable to itself".
                // Raven wrote: fov_x = fov_x
                portMissing("CG_CalcFov", source: "oracle/codemp/cgame/cg_view.c:1191")
            } else {
                fov_x = cg.predictedPlayerState.zoomFov + f * (fov_x - cg.predictedPlayerState.zoomFov)
            }
        }
    }

    x = Float(Double(cg.refdef.width) / tan(Double(fov_x / 360) * M_PI))
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Int32' to expected argument type 'Float'".
    // Raven wrote: fov_y = atan2( cg.refdef.height, x )
    portMissing("CG_CalcFov", source: "oracle/codemp/cgame/cg_view.c:1191")
    fov_y = Float(Double(fov_y * 360) / M_PI)

    // warp if underwater
    cg.refdef.viewContents = CG_PointContents(cg.refdef.vieworg, -1)
    if (cg.refdef.viewContents & (CONTENTS_WATER | CONTENTS_SLIME | CONTENTS_LAVA)) != 0 {
        phase = Float(Double(cg.time) / 1000.0 * WAVE_FREQUENCY * M_PI * 2)
        v = WAVE_AMPLITUDE * sin(phase)
        fov_x += v
        fov_y -= v
        inwater = 1
    } else {
        inwater = 0
    }



    // set it
    cg.refdef.fov_x = fov_x
    cg.refdef.fov_y = fov_y

    if cg.predictedPlayerState.zoomMode != 0 {
        cg.zoomSensitivity = zoomFov / cgFov
    } else if !cg.zoomed {
        cg.zoomSensitivity = 1
    } else {
        cg.zoomSensitivity = Float(Double(cg.refdef.fov_y) / 75.0)
    }

    return inwater
}

/**
```
===============
CG_DamageBlendBlob

===============
```
*/
/// Source: oracle/codemp/cgame/cg_view.c:1343
private func CG_DamageBlendBlob() {
    var t: Int32 = 0
    var maxTime: Int32 = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = RefEntity.scratch { ent -> Bool in

        if cg.damageValue == 0 {
            return true
        }

        maxTime = DAMAGE_TIME
        t = Int32(cg.time - cg.damageTime)
        if t <= 0 || t >= maxTime {
            return true
        }

        // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.
        ent.reType = RT_SPRITE
        ent.renderfx = RF_FIRST_PERSON

        _VectorMA(cg.refdef.vieworg, 8, cg.refdef.viewaxis[0], &ent.origin)
        _VectorMA(ent.origin, cg.damageX * -8, cg.refdef.viewaxis[1], &ent.origin)
        _VectorMA(ent.origin, cg.damageY * 8, cg.refdef.viewaxis[2], &ent.origin)

        ent.radius = Float(Double(cg.damageValue * 3) * (1.0 - Double(Float(t) / maxTime)))

        if cg.snap!.ps.damageType == 0 {
            //pure health
            ent.customShader = cgs.media.viewPainShader
            ent.shaderRGBA[0] = UInt8(truncatingIfNeeded: Int32(180 * (1.0 - Double(Float(t) / maxTime))))
            ent.shaderRGBA[1] = UInt8(truncatingIfNeeded: Int32(50 * (1.0 - Double(Float(t) / maxTime))))
            ent.shaderRGBA[2] = UInt8(truncatingIfNeeded: Int32(50 * (1.0 - Double(Float(t) / maxTime))))
            ent.shaderRGBA[3] = 255
        } else if cg.snap!.ps.damageType == 1 {
            //pure shields
            ent.customShader = cgs.media.viewPainShader_Shields
            ent.shaderRGBA[0] = UInt8(truncatingIfNeeded: Int32(50 * (1.0 - Double(Float(t) / maxTime))))
            ent.shaderRGBA[1] = UInt8(truncatingIfNeeded: Int32(180 * (1.0 - Double(Float(t) / maxTime))))
            ent.shaderRGBA[2] = UInt8(truncatingIfNeeded: Int32(50 * (1.0 - Double(Float(t) / maxTime))))
            ent.shaderRGBA[3] = 255
        } else {
            //shields and health
            ent.customShader = cgs.media.viewPainShader_ShieldsAndHealth
            ent.shaderRGBA[0] = UInt8(truncatingIfNeeded: Int32(180 * (1.0 - Double(Float(t) / maxTime))))
            ent.shaderRGBA[1] = UInt8(truncatingIfNeeded: Int32(180 * (1.0 - Double(Float(t) / maxTime))))
            ent.shaderRGBA[2] = UInt8(truncatingIfNeeded: Int32(50 * (1.0 - Double(Float(t) / maxTime))))
            ent.shaderRGBA[3] = 255
        }
        trap_R_AddRefEntityToScene(ent)
        return false
    }
    if earlyOut {
        return
    }
}

//action cam routine -rww
/// Source: oracle/codemp/cgame/cg_view.c:1400
private func CG_ThirdPersonActionCam() -> Bool {
    let cent: Centity? = cg_entities[cg.snap!.ps.clientNum]
    let ci: ClientInfo? = cgs.clientinfo[cg.snap!.ps.clientNum]
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Bool in
        var positionDir = vec3_t()
        var desiredAngles = vec3_t()
        var desiredPos = vec3_t()
        var v = vec3_t()
        let smoothFactor: Float = 0.1 * cg_timescale.value
        var i: Int32 = 0

        if cent!.ghoul2 == nil {
            //if we don't have a g2 instance this frame for whatever reason then do nothing
            return false
        }

        if cent!.currentState.weapon != WP_SABER {
            //just being safe, should not ever happen
            return false
        }

        if (cg.time - ci!.saber[0].blade[0].trail.lastTime) > 300 {
            //too long since we last got the blade position
            return false
        }

        //get direction from base to ent origin
        positionDir = ci!.saber[0].blade[0].trail.base - cent!.lerpOrigin
        VectorNormalize(&positionDir)

        //position the cam based on the direction and saber position
        _VectorMA(cent!.lerpOrigin, cg_thirdPersonRange.value * 2, positionDir, &desiredPos)

        //trace to the desired pos to see how far that way we can actually go before we hit something
        //the endpos will be valid for our desiredpos no matter what
        CG_Trace(tr, cent!.lerpOrigin, nil, nil, desiredPos, cent!.currentState.number, MASK_SOLID)
        desiredPos = tr.endpos

        if (cg.time - cg_actionCamLastTime) > 300 {
            //do a third person offset first and grab the initial point from that
            CG_OffsetThirdPersonView()
            cg_actionCamLastPos = cg.refdef.vieworg
        }

        cg_actionCamLastTime = cg.time

        //lerp the vieworg to the desired pos from the last valid
        v = desiredPos - cg_actionCamLastPos

        if VectorLength(v) > 64.0 {
            //don't bother moving yet if not far from the last pos
            i = 0
            while i < 3 {
                cg_actionCamLastPos[i] = (cg_actionCamLastPos[i] + (v[i] * smoothFactor))
                cg.refdef.vieworg[i] = cg_actionCamLastPos[i]
                i += 1
            }
        } else {
            cg.refdef.vieworg = cg_actionCamLastPos
        }

        //Make sure the point is alright
        CG_Trace(tr, cent!.lerpOrigin, nil, nil, cg.refdef.vieworg, cent!.currentState.number, MASK_SOLID)
        cg.refdef.vieworg = tr.endpos

        positionDir = cent!.lerpOrigin - cg.refdef.vieworg
        vectoangles(positionDir, &desiredAngles)

        //just set the angles for now
        cg.refdef.viewangles = desiredAngles
        return true
    }
}

/// Source: oracle/codemp/cgame/cg_view.c:1477
func CG_CheckPassengerTurretView() -> Bool {
    if cg.predictedPlayerState.m_iVehicleNum != 0 && cg.predictedPlayerState.generic1 != 0 {
        //passenger in a vehicle
        let vehCent: Centity? = cg_entities[cg.predictedPlayerState.m_iVehicleNum]
        if vehCent!.m_pVehicle != nil && vehCent!.m_pVehicle!.m_pVehicleInfo != nil && vehCent!.m_pVehicle!.m_pVehicleInfo!.maxPassengers != 0 {
            //a vehicle capable of carrying passengers
            var turretNum: Int32
            turretNum = 0
            while turretNum < MAX_VEHICLE_TURRETS {
                if vehCent!.m_pVehicle!.m_pVehicleInfo!.turret[turretNum].iAmmoMax != 0 {
                    // valid turret
                    if vehCent!.m_pVehicle!.m_pVehicleInfo!.turret[turretNum].passengerNum == cg.predictedPlayerState.generic1 {
                        //I control this turret
                        //Ah, crap, just look around freely... below method is way too wiggy
                        cg.refdef.vieworg = cg.predictedPlayerState.origin
                        cg.refdef.viewangles = cg.predictedPlayerState.viewangles
                        return true
                        /*
                        int boltIndex = -1;
                        qboolean hackPosAndAngle = qfalse;
                        if ( vehCent->m_pVehicle->m_iGunnerViewTag[turretNum] != -1 )
                        {
                        boltIndex = vehCent->m_pVehicle->m_iGunnerViewTag[turretNum];
                        }
                        else
                        {//crap... guess?
                        hackPosAndAngle = qtrue;
                        if ( vehCent->m_pVehicle->m_pVehicleInfo->turret[turretNum].yawBone )
                        {
                        boltIndex = trap_G2API_AddBolt( vehCent->ghoul2, 0, vehCent->m_pVehicle->m_pVehicleInfo->turret[turretNum].yawBone );
                        }
                        else if ( vehCent->m_pVehicle->m_pVehicleInfo->turret[turretNum].pitchBone )
                        {
                        boltIndex = trap_G2API_AddBolt( vehCent->ghoul2, 0, vehCent->m_pVehicle->m_pVehicleInfo->turret[turretNum].pitchBone );
                        }
                        else
                        {//well, no way of knowing, so screw it
                        return qfalse;
                        }
                        }
                        if ( boltIndex != -1 )
                        {
                        mdxaBone_t boltMatrix;
                        vec3_t fwd, up;
                        trap_G2API_GetBoltMatrix_NoRecNoRot(vehCent->ghoul2, 0, boltIndex, &boltMatrix, vehCent->lerpAngles,
                        vehCent->lerpOrigin, cg.time, NULL, vehCent->modelScale);
                        BG_GiveMeVectorFromMatrix(&boltMatrix, ORIGIN, cg.refdef.vieworg);
                        if ( hackPosAndAngle )
                        {
                        //FIXME: these are assumptions, externalize?  BETTER YET: give me a controller view bolt/tag for each turret
                        BG_GiveMeVectorFromMatrix(&boltMatrix, NEGATIVE_X, fwd);
                        BG_GiveMeVectorFromMatrix(&boltMatrix, NEGATIVE_Y, up);
                        VectorMA( cg.refdef.vieworg, 8.0f, fwd, cg.refdef.vieworg );
                        VectorMA( cg.refdef.vieworg, 4.0f, up, cg.refdef.vieworg );
                        }
                        else
                        {
                        BG_GiveMeVectorFromMatrix(&boltMatrix, NEGATIVE_Y, fwd);
                        }
                        {
                        vec3_t	newAngles, deltaAngles;
                        vectoangles( fwd, newAngles );
                        AnglesSubtract( newAngles, cg_lastTurretViewAngles, deltaAngles );
                        VectorMA( cg_lastTurretViewAngles, 0.5f*(float)cg.frametime/100.0f, deltaAngles, cg.refdef.viewangles );
                        }
                        return qtrue;
                        }
                        */
                    }
                }
                turretNum += 1
            }
        }
    }
    return false
}

/// Source: oracle/codemp/cgame/cg_view.c:1564
private func CG_CalcViewValues() -> Int32 {
    var manningTurret: Bool = false
    var ps: PlayerState?

    cg.refdef.clear()

    // strings for in game rendering
    // Q_strncpyz( cg.refdef.text[0], "Park Ranger", sizeof(cg.refdef.text[0]) );
    // Q_strncpyz( cg.refdef.text[1], "19", sizeof(cg.refdef.text[1]) );

    // calculate size of 3D view
    CG_CalcVrect()

    ps = cg.predictedPlayerState
    /*
    if (cg.cameraMode) {
    vec3_t origin, angles;
    if (trap_getCameraInfo(cg.time, &origin, &angles)) {
    VectorCopy(origin, cg.refdef.vieworg);
    angles[ROLL] = 0;
    VectorCopy(angles, cg.refdef.viewangles);
    AnglesToAxis( cg.refdef.viewangles, cg.refdef.viewaxis );
    return CG_CalcFov();
    } else {
    cg.cameraMode = qfalse;
    }
    }
    */
    // intermission view
    if ps!.pm_type == PM_INTERMISSION {
        cg.refdef.vieworg = ps!.origin
        cg.refdef.viewangles = ps!.viewangles
        // Port-note: The draft of this statement did not compile, and the compiler wrote "'&' used with non-inout argument of type 'Slots<vec3_t>' (aka 'Slots<SIMD3<Float>>')".
        // Raven wrote: AnglesToAxis( cg.refdef.viewangles, cg.refdef.viewaxis )
        portMissing("CG_CalcViewValues", source: "oracle/codemp/cgame/cg_view.c:1564")
        return CG_CalcFov()
    }

    cg.bobcycle = (ps!.bobCycle & 128) >> 7
    cg.bobfracsin = Float(abs(sin(Double(ps!.bobCycle & 127) / 127.0 * M_PI)))
    cg.xyspeed = sqrt(ps!.velocity[0] * ps!.velocity[0] + ps!.velocity[1] * ps!.velocity[1])

    if cg.xyspeed > 270 {
        cg.xyspeed = 270
    }

    manningTurret = CG_CheckPassengerTurretView()
    if !manningTurret {
        //not manning a turret on a vehicle
        cg.refdef.vieworg = ps!.origin
        if cg.predictedPlayerState.m_iVehicleNum != 0 && BG_UnrestrainedPitchRoll(cg.predictedPlayerState, cg_entities[cg.predictedPlayerState.m_iVehicleNum].m_pVehicle) {
            //use the vehicle's viewangles to render view!
            cg.refdef.viewangles = cg.predictedVehicleState.viewangles
        } else {
            cg.refdef.viewangles = ps!.viewangles
        }
    }
    cg_lastTurretViewAngles = cg.refdef.viewangles

    if cg_cameraOrbit.integer != 0 {
        if cg.time > cg.nextOrbitTime {
            cg.nextOrbitTime = cg.time + cg_cameraOrbitDelay.integer
            cg_thirdPersonAngle.value += cg_cameraOrbit.value
        }
    }
    // add error decay
    if cg_errorDecay.value > 0 {
        let t: Int32
        let f: Float

        t = cg.time - cg.predictedErrorTime
        f = (cg_errorDecay.value - t) / cg_errorDecay.value
        if f > 0 && f < 1 {
            _VectorMA(cg.refdef.vieworg, f, cg.predictedError, &cg.refdef.vieworg)
        } else {
            cg.predictedErrorTime = 0
        }
    }

    if cg.snap!.ps.weapon == WP_EMPLACED_GUN && cg.snap!.ps.emplacedIndex != 0 {
        //constrain the view properly for emplaced guns
        CG_EmplacedView(&cg_entities[cg.snap!.ps.emplacedIndex].currentState.angles)
    }

    //FIX: okay, if manning a turret, let view turn freely,
    //	   and use the vehicle chase camera info to place vieworg
    //if ( !manningTurret )
    do {
        if cg.predictedPlayerState.m_iVehicleNum != 0 && BG_UnrestrainedPitchRoll(cg.predictedPlayerState, cg_entities[cg.predictedPlayerState.m_iVehicleNum].m_pVehicle) {
            //use the vehicle's viewangles to render view!
            CG_OffsetFighterView()
        } else if cg.renderingThirdPerson {
            // back away from character
            if cg_thirdPersonSpecialCam.integer != 0 && BG_SaberInSpecial(cg.snap!.ps.saberMove) {
                //the action cam
                if !CG_ThirdPersonActionCam() {
                    //couldn't do it for whatever reason, resort back to third person then
                    CG_OffsetThirdPersonView()
                }
            } else {
                CG_OffsetThirdPersonView()
            }
        } else {
            // offset for local bobbing and kicks
            CG_OffsetFirstPersonView()
        }
    }

    // position eye relative to origin
    // Port-note: The draft of this statement did not compile, and the compiler wrote "'&' used with non-inout argument of type 'Slots<vec3_t>' (aka 'Slots<SIMD3<Float>>')".
    // Raven wrote: AnglesToAxis( cg.refdef.viewangles, cg.refdef.viewaxis )
    portMissing("CG_CalcViewValues", source: "oracle/codemp/cgame/cg_view.c:1564")

    if cg.hyperspace {
        cg.refdef.rdflags |= RDF_NOWORLDMODEL | RDF_HYPERSPACE
    }

    // field of view
    return CG_CalcFov()
}

/**
```
=====================
CG_PowerupTimerSounds
=====================
```
*/
/// Source: oracle/codemp/cgame/cg_view.c:1720
private func CG_PowerupTimerSounds() {
    var i: Int32
    var t: Int32

    // powerup timers going away
    i = 0
    while i < MAX_POWERUPS {
        t = cg.snap!.ps.powerups[i]
        if t <= cg.time {
            i += 1
            continue
        }
        if t - cg.time >= POWERUP_BLINKS * POWERUP_BLINK_TIME {
            i += 1
            continue
        }
        if (t - cg.time) / POWERUP_BLINK_TIME != (t - cg.oldTime) / POWERUP_BLINK_TIME {
            //trap_S_StartSound( NULL, cg.snap->ps.clientNum, CHAN_ITEM, cgs.media.wearOffSound );
        }
        i += 1
    }
}

/// Source: oracle/codemp/cgame/cg_view.c:1748
func CG_DrawSkyBoxPortal(_ cstr: String) {
    var lastfov: Float = 0
    // Raven steps his own `cstr` parameter through its bytes, so the body walks a TextCursor over a copy of them.
    var cstr = TextCursor(CharBuf(cstr))
    // Raven's record lives to the end of his block, so the block is the closure.
    Refdef.scratch { backuprefdef in
        var fov_x: Float = 0
        var fov_y: Float = 0
        var x: Float = 0
        var token: String
        var f: Float = 0

        lastfov = zoomFov // for transitions back from zoomed in modes

        backuprefdef.copy(from: cg.refdef)

        token = COM_ParseExt(&cstr, false)
        if token.isEmpty {
            CG_Error("CG_DrawSkyBoxPortal: error parsing skybox configstring\n")
        }
        cg.refdef.vieworg[0] = Float(atof(token))

        token = COM_ParseExt(&cstr, false)
        if token.isEmpty {
            CG_Error("CG_DrawSkyBoxPortal: error parsing skybox configstring\n")
        }
        cg.refdef.vieworg[1] = Float(atof(token))

        token = COM_ParseExt(&cstr, false)
        if token.isEmpty {
            CG_Error("CG_DrawSkyBoxPortal: error parsing skybox configstring\n")
        }
        cg.refdef.vieworg[2] = Float(atof(token))

        token = COM_ParseExt(&cstr, false)
        if token.isEmpty {
            CG_Error("CG_DrawSkyBoxPortal: error parsing skybox configstring\n")
        }
        fov_x = Float(atoi(token))

        if fov_x == 0 {
            fov_x = cg_fov.value
        }

        // setup fog the first time, ignore this part of the configstring after that
        token = COM_ParseExt(&cstr, false)
        if token.isEmpty {
            CG_Error("CG_DrawSkyBoxPortal: error parsing skybox configstring.  No fog state\n")
        } else {
            var fogColor = vec4_t()
            var fogStart: Int32 = 0
            var fogEnd: Int32 = 0

            if atoi(token) != 0 {
                // this camera has fog
                token = COM_ParseExt(&cstr, false)

                if token.isEmpty {
                    CG_Error("CG_DrawSkyBoxPortal: error parsing skybox configstring.  No fog[0]\n")
                }
                fogColor[0] = Float(atof(token))

                token = COM_ParseExt(&cstr, false)
                if token.isEmpty {
                    CG_Error("CG_DrawSkyBoxPortal: error parsing skybox configstring.  No fog[1]\n")
                }
                fogColor[1] = Float(atof(token))

                token = COM_ParseExt(&cstr, false)
                if token.isEmpty {
                    CG_Error("CG_DrawSkyBoxPortal: error parsing skybox configstring.  No fog[2]\n")
                }
                fogColor[2] = Float(atof(token))

                token = COM_ParseExt(&cstr, false)
                if token.isEmpty {
                    fogStart = 0
                } else {
                    fogStart = atoi(token)
                }

                token = COM_ParseExt(&cstr, false)
                if token.isEmpty {
                    fogEnd = 0
                } else {
                    fogEnd = atoi(token)
                }
            }
        }

        if cg.predictedPlayerState.pm_type == PM_INTERMISSION {
            // if in intermission, use a fixed value
            fov_x = cg_fov.value
        } else {
            fov_x = cg_fov.value
            if fov_x < 1 {
                fov_x = 1
            } else if fov_x > 160 {
                fov_x = 160
            }

            if cg.predictedPlayerState.zoomMode != 0 {
                fov_x = zoomFov
            }

            // do smooth transitions for zooming
            if cg.predictedPlayerState.zoomMode != 0 {
                //zoomed/zooming in
                f = (cg.time - cg.zoomTime) / Float(ZOOM_OUT_TIME)
                if Double(f) > 1.0 {
                    fov_x = zoomFov
                } else {
                    fov_x = fov_x + f * (zoomFov - fov_x)
                }
                lastfov = fov_x
            } else {
                //zooming out
                f = (cg.time - cg.zoomTime) / Float(ZOOM_OUT_TIME)
                if Double(f) > 1.0 {
                    fov_x = fov_x
                } else {
                    fov_x = zoomFov + f * (fov_x - zoomFov)
                }
            }
        }

        x = Float(Double(cg.refdef.width) / tan(Double(fov_x / 360) * M_PI))
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Int32' to expected argument type 'Float'".
        // Raven wrote: fov_y = atan2( cg.refdef.height, x )
        portMissing("CG_DrawSkyBoxPortal", source: "oracle/codemp/cgame/cg_view.c:1748")
        fov_y = Float(Double(fov_y * 360) / M_PI)

        cg.refdef.fov_x = fov_x
        cg.refdef.fov_y = fov_y

        cg.refdef.rdflags |= RDF_SKYBOXPORTAL
        cg.refdef.rdflags |= RDF_DRAWSKYBOX

        cg.refdef.time = cg.time

        if !cg.hyperspace {
            //rww - also had to add this to add effects being rendered in portal sky areas properly.
            trap_FX_AddScheduledEffects(true)
        }

        CG_AddPacketEntities(true) //rww - There was no proper way to put real entities inside the portal view before.
        //This will put specially flagged entities in the render.

        if cg_skyOri {
            //ok, we want to orient the sky refdef vieworg based on the normal vieworg's relation to the ori pos
            var dif = vec3_t()

            dif = backuprefdef.vieworg - cg_skyOriPos
            dif = dif * cg_skyOriScale
            cg.refdef.vieworg = cg.refdef.vieworg + dif
        }

        if cg_noFogOutsidePortal {
            //make sure no fog flag is stripped first, and make sure it is set on the normal refdef
            cg.refdef.rdflags &= ~RDF_NOFOG
            backuprefdef.rdflags |= RDF_NOFOG
        }

        // draw the skybox
        trap_R_RenderScene(cg.refdef)

        cg.refdef.copy(from: backuprefdef)
    }
}

/**
```
=====================
CG_AddBufferedSound
=====================
```
*/
/// Source: oracle/codemp/cgame/cg_view.c:1942
func CG_AddBufferedSound(_ sfx: JKAShared.sfxHandle_t) {
    if sfx == 0 {
        return
    }
    cg.soundBuffer[cg.soundBufferIn] = sfx
    cg.soundBufferIn = (cg.soundBufferIn + 1) % MAX_SOUNDBUFFER
    if cg.soundBufferIn == cg.soundBufferOut {
        cg.soundBufferOut += 1
    }
}

/**
```
=====================
CG_PlayBufferedSounds
=====================
```
*/
/// Source: oracle/codemp/cgame/cg_view.c:1957
private func CG_PlayBufferedSounds() {
    if cg.soundTime < cg.time {
        if cg.soundBufferOut != cg.soundBufferIn && cg.soundBuffer[cg.soundBufferOut] != 0 {
            trap_S_StartLocalSound(cg.soundBuffer[cg.soundBufferOut], CHAN_ANNOUNCER)
            cg.soundBuffer[cg.soundBufferOut] = 0
            cg.soundBufferOut = (cg.soundBufferOut + 1) % MAX_SOUNDBUFFER
            cg.soundTime = cg.time + 750
        }
    }
}

/// Source: oracle/codemp/cgame/cg_view.c:1968
func CG_UpdateSoundTrackers() {
    var num: Int32
    var cent: Centity?

    num = 0
    while num < ENTITYNUM_NONE {
        cent = cg_entities[num]

        if cent != nil && (cent!.currentState.eFlags & EF_SOUNDTRACKER) != 0 && cent!.currentState.number == num {
            //keep sound for this entity updated in accordance with its attached entity at all times
            if cg.snap != nil && cent!.currentState.trickedentindex == cg.snap!.ps.clientNum {
                //this is actually the player, so center the sound origin right on top of us
                cent!.lerpOrigin = cg.refdef.vieworg
                trap_S_UpdateEntityPosition(cent!.currentState.number, cent!.lerpOrigin)
            } else {
                trap_S_UpdateEntityPosition(cent!.currentState.number, cg_entities[cent!.currentState.trickedentindex].lerpOrigin)
            }
        }

        if cent!.currentState.number == num {
            //update all looping sounds..
            CG_S_UpdateLoopingSounds(num)
        }
        num += 1
    }
}

/// Source: oracle/codemp/cgame/cg_view.c:2011
func CG_SE_UpdateShake(_ origin: inout JKAShared.vec3_t, _ angles: inout JKAShared.vec3_t) {
    var moveDir = vec3_t()
    let intensity_scale: Float
    let intensity: Float
    var i: Int32

    if cgScreenEffects.shake_duration <= 0 {
        return
    }

    if cg.time > (cgScreenEffects.shake_start + cgScreenEffects.shake_duration) {
        cgScreenEffects.shake_intensity = 0
        cgScreenEffects.shake_duration = 0
        cgScreenEffects.shake_start = 0
        return
    }

    cgScreenEffects.FOV = CAMERA_DEFAULT_FOV
    cgScreenEffects.FOV2 = CAMERA_DEFAULT_FOV

    //intensity_scale now also takes into account FOV with 90.0 as normal
    intensity_scale = 1.0 - (Float((cg.time - cgScreenEffects.shake_start)) / Float(cgScreenEffects.shake_duration)) * (((cgScreenEffects.FOV + cgScreenEffects.FOV2) / 2.0) / 90.0)

    intensity = cgScreenEffects.shake_intensity * intensity_scale

    i = 0
    while i < 3 {
        moveDir[i] = Float((crandom() * Double(intensity)))
        i += 1
    }

    //Move the camera
    origin = origin + moveDir

    i = 0
    while i < 2 {
        moveDir[i] = Float((crandom() * Double(intensity)))
        i += 1
    }

    //Move the angles
    angles = angles + moveDir
}

/// Source: oracle/codemp/cgame/cg_view.c:2051
func CG_SE_UpdateMusic() {
    if Double(cgScreenEffects.music_volume_multiplier) < 0.1 {
        cgScreenEffects.music_volume_multiplier = 1.0
        return
    }

    if cgScreenEffects.music_volume_time < cg.time {
        if Double(cgScreenEffects.music_volume_multiplier) != 1.0 || cgScreenEffects.music_volume_set {
            var musMultStr = CharBuf(512)

            cgScreenEffects.music_volume_multiplier = Float(Double(cgScreenEffects.music_volume_multiplier) + 0.1)
            if Double(cgScreenEffects.music_volume_multiplier) > 1.0 {
                cgScreenEffects.music_volume_multiplier = 1.0
            }

            Com_sprintf(&musMultStr, Int32((musMultStr).count), "%f", cgScreenEffects.music_volume_multiplier)
            trap_Cvar_Set("s_musicMult", String(musMultStr))

            if Double(cgScreenEffects.music_volume_multiplier) == 1.0 {
                cgScreenEffects.music_volume_set = false
            } else {
                cgScreenEffects.music_volume_time = cg.time + 200
            }
        }

        return
    }

    if !cgScreenEffects.music_volume_set {
        //if the volume_time is >= cg.time, we should have a volume multiplier set
        var musMultStr = CharBuf(512)

        Com_sprintf(&musMultStr, Int32((musMultStr).count), "%f", cgScreenEffects.music_volume_multiplier)
        trap_Cvar_Set("s_musicMult", String(musMultStr))
        cgScreenEffects.music_volume_set = true
    }
}

/**
```
=================
CG_CalcScreenEffects

Currently just for screen shaking (and music volume management)
=================
```
*/
/// Source: oracle/codemp/cgame/cg_view.c:2104
func CG_CalcScreenEffects() {
    CG_SE_UpdateShake(&cg.refdef.vieworg, &cg.refdef.viewangles)
    CG_SE_UpdateMusic()
}

/// Source: oracle/codemp/cgame/cg_view.c:2110
func CGCam_Shake(_ intensity: Float, _ duration: Int32) {
    // Raven assigns his own `intensity` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var intensity = intensity
    if intensity > MAX_SHAKE_INTENSITY {
        intensity = MAX_SHAKE_INTENSITY
    }

    cgScreenEffects.shake_intensity = intensity
    cgScreenEffects.shake_duration = duration


    cgScreenEffects.shake_start = cg.time
    //JLFRUMBLE
}

/// Source: oracle/codemp/cgame/cg_view.c:2129
func CG_DoCameraShake(_ origin: JKAShared.vec3_t, _ intensity: Float, _ radius: Int32, _ time: Int32) {
    //FIXME: When exactly is the vieworg calculated in relation to the rest of the frame?s

    var dir = vec3_t()
    let dist: Float
    let intensityScale: Float
    let realIntensity: Float

    dir = cg.refdef.vieworg - origin
    dist = VectorNormalize(&dir)

    //Use the dir to add kick to the explosion

    if dist > radius {
        return
    }

    intensityScale = 1 - (dist / Float(radius))
    realIntensity = intensity * intensityScale

    CGCam_Shake(realIntensity, time)
}

/// Source: oracle/codemp/cgame/cg_view.c:2151
func CGCam_SetMusicMult(_ multiplier: Float, _ duration: Int32) {
    // Raven assigns his own `multiplier` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var multiplier = multiplier
    if multiplier < 0.1 {
        multiplier = 0.1
    }

    if multiplier > 1.0 {
        multiplier = 1.0
    }

    cgScreenEffects.music_volume_multiplier = multiplier
    cgScreenEffects.music_volume_time = cg.time + duration
    cgScreenEffects.music_volume_set = false
}

/// Source: oracle/codemp/cgame/cg_view.c:2185
func CG_EmplacedView(_ angles: inout JKAShared.vec3_t) {
    var yaw: Float = 0
    var override: Int32

    override = BG_EmplacedView(&cg.refdef.viewangles, &angles, &yaw, cg_entities[cg.snap!.ps.emplacedIndex].currentState.origin2[0])

    if override != 0 {
        cg.refdef.viewangles[YAW] = yaw
        // Port-note: The draft of this statement did not compile, and the compiler wrote "'&' used with non-inout argument of type 'Slots<vec3_t>' (aka 'Slots<SIMD3<Float>>')".
        // Raven wrote: AnglesToAxis(cg.refdef.viewangles, cg.refdef.viewaxis)
        portMissing("CG_EmplacedView", source: "oracle/codemp/cgame/cg_view.c:2185")

        if override == 2 {
            trap_SetClientForceAngle(cg.time + 5000, &cg.refdef.viewangles)
        }
    }

    //we want to constrain the predicted player state viewangles as well
    override = BG_EmplacedView(&cg.predictedPlayerState.viewangles, &angles, &yaw, cg_entities[cg.snap!.ps.emplacedIndex].currentState.origin2[0])
    if override != 0 {
        cg.predictedPlayerState.viewangles[YAW] = yaw
    }
}

//specially add cent's for automap
/// Source: oracle/codemp/cgame/cg_view.c:2214
private func CG_AddRefentForAutoMap(_ cent: Centity) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = RefEntity.scratch { ent -> Bool in
        var flat = vec3_t()

        if (cent.currentState.eFlags & EF_NODRAW) != 0 {
            return true
        }

        // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.
        ent.reType = RT_MODEL

        flat = cent.lerpAngles
        flat[ROLL] = 0.0
        flat[PITCH] = flat[ROLL]

        ent.origin = cent.lerpOrigin
        ent.angles = flat
        // Port-note: The draft of this statement did not compile, and the compiler wrote "'&' used with non-inout argument of type 'Slots<vec3_t>' (aka 'Slots<SIMD3<Float>>')".
        // Raven wrote: AnglesToAxis(flat, ent.axis)
        portMissing("CG_AddRefentForAutoMap", source: "oracle/codemp/cgame/cg_view.c:2214")

        if cent.ghoul2 != nil && (cent.currentState.eType == ET_PLAYER || cent.currentState.eType == ET_NPC || cent.currentState.modelGhoul2 != 0) {
            //using a ghoul2 model
            ent.ghoul2 = cent.ghoul2
            ent.radius = Float(cent.currentState.g2radius)

            if ent.radius == 0 {
                ent.radius = 64.0
            }
        } else {
            //then assume a standard indexed model
            ent.hModel = cgs.gameModels[cent.currentState.modelindex]
        }

        trap_R_AddRefEntityToScene(ent)
        return false
    }
    if earlyOut {
        return
    }
}

//add all entities that would be on the radar
/// Source: oracle/codemp/cgame/cg_view.c:2256
func CG_AddRadarAutomapEnts() {
    var i: Int32 = 0

    //first add yourself
    CG_AddRefentForAutoMap(cg_entities[cg.predictedPlayerState.clientNum])

    while i < cg.radarEntityCount {
        CG_AddRefentForAutoMap(cg_entities[cg.radarEntities[i]])
        i += 1
    }
}

/// Source: oracle/codemp/cgame/cg_view.c:2284
func CG_DrawAutoMap() {
    var local: ClientInfo?
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Refdef.scratch { refdef -> Bool in
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives true where Raven returns from the function.
        let earlyOut2 = Trace.scratch { tr -> Bool in
            var fwd = vec3_t()
            var playerMins = vec3_t()
            var playerMaxs = vec3_t()
            var vWidth: Int32 = 0
            var vHeight: Int32 = 0
            var hScale: Float = 0
            var vScale: Float = 0
            var x: Float = 0
            var y: Float = 0
            var w: Float = 0
            var h: Float = 0

            if cg_autoMap.integer == 0 {
                //don't do anything then
                return true
            }

            if cg.snap!.ps.stats[STAT_HEALTH] <= 0 {
                //don't show when dead
                return true
            }

            if (cg.predictedPlayerState.pm_flags & PMF_FOLLOW) != 0 || cg.predictedPlayerState.persistant[PERS_TEAM] == TEAM_SPECTATOR {
                //don't show when spec
                return true
            }

            local = cgs.clientinfo[cg.predictedPlayerState.clientNum]
            if !local!.infoValid {
                //don't show if bad ci
                return true
            }

            if cgs.gametype < GT_TEAM {
                //don't show in non-team gametypes
                return true
            }

            if cg_autoMapInputTime >= cg.time {
                if cg_autoMapInput.up != 0 {
                    cg_autoMapZoom -= cg_autoMapInput.up
                    if cg_autoMapZoom < cg_autoMapZoomMainOffset + 64.0 {
                        cg_autoMapZoom = cg_autoMapZoomMainOffset + 64.0
                    }
                }

                if cg_autoMapInput.down != 0 {
                    cg_autoMapZoom += cg_autoMapInput.down
                    if cg_autoMapZoom > cg_autoMapZoomMainOffset + 4096.0 {
                        cg_autoMapZoom = cg_autoMapZoomMainOffset + 4096.0
                    }
                }

                if cg_autoMapInput.yaw != 0 {
                    cg_autoMapAngle[YAW] += cg_autoMapInput.yaw
                }

                if cg_autoMapInput.pitch != 0 {
                    cg_autoMapAngle[PITCH] += cg_autoMapInput.pitch
                }

                if cg_autoMapInput.goToDefaults {
                    cg_autoMapZoom = 512.0
                    cg_autoMapAngle = vec3_t(90.0, 0.0, 0.0)
                }
            }

            // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.

            refdef.rdflags = (RDF_NOWORLDMODEL | RDF_AUTOMAP)

            refdef.vieworg = cg.predictedPlayerState.origin
            refdef.viewangles = cg_autoMapAngle

            //scale out in the direction of the view angles base on the zoom factor
            // Raven passes NULL for the `right` and `up` outputs.
            var scratchRight = vec3_t()
            var scratchUp = vec3_t()
            AngleVectors(refdef.viewangles, &fwd, &scratchRight, &scratchUp)
            _VectorMA(refdef.vieworg, -cg_autoMapZoom, fwd, &refdef.vieworg)

            // Port-note: The draft of this statement did not compile, and the compiler wrote "'&' used with non-inout argument of type 'Slots<vec3_t>' (aka 'Slots<SIMD3<Float>>')".
            // Raven wrote: AnglesToAxis(refdef.viewangles, refdef.viewaxis)
            portMissing("CG_DrawAutoMap", source: "oracle/codemp/cgame/cg_view.c:2284")

            refdef.fov_x = 50
            refdef.fov_y = 50

            //guess this doesn't need to be done every frame, but eh
            trap_R_GetRealRes(&vWidth, &vHeight)

            //set scaling values so that the 640x480 will result at 1.0/1.0
            hScale = vWidth / 640.0
            vScale = vHeight / 480.0

            x = cg_autoMapX.value
            y = cg_autoMapY.value
            w = cg_autoMapW.value
            h = cg_autoMapH.value

            refdef.x = Int32(x * hScale)
            refdef.y = Int32(y * vScale)
            refdef.width = Int32(w * hScale)
            refdef.height = Int32(h * vScale)

            CG_DrawPic(x - SIDEFRAME_WIDTH, y, Float(SIDEFRAME_WIDTH), h, cgs.media.wireframeAutomapFrame_left)
            CG_DrawPic(x + w, y, Float(SIDEFRAME_WIDTH), h, cgs.media.wireframeAutomapFrame_right)
            CG_DrawPic(x - SIDEFRAME_WIDTH, y - SIDEFRAME_HEIGHT, w + (SIDEFRAME_WIDTH * 2), Float(SIDEFRAME_HEIGHT), cgs.media.wireframeAutomapFrame_top)
            CG_DrawPic(x - SIDEFRAME_WIDTH, y + h, w + (SIDEFRAME_WIDTH * 2), Float(SIDEFRAME_HEIGHT), cgs.media.wireframeAutomapFrame_bottom)

            refdef.time = cg.time

            trap_R_ClearScene()
            CG_AddRadarAutomapEnts()

            if cg.predictedPlayerState.m_iVehicleNum != 0 && cg_entities[cg.predictedPlayerState.m_iVehicleNum].currentState.eType == ET_NPC && cg_entities[cg.predictedPlayerState.m_iVehicleNum].currentState.NPC_class == CLASS_VEHICLE && cg_entities[cg.predictedPlayerState.m_iVehicleNum].m_pVehicle != nil && cg_entities[cg.predictedPlayerState.m_iVehicleNum].m_pVehicle!.m_pVehicleInfo!.type == VH_FIGHTER {
                //constantly adjust to current height
                trap_R_AutomapElevAdj(cg.predictedPlayerState.origin[2])
            } else {
                //Trace down and set the ground elevation as the main automap elevation point
                playerMins = vec3_t(-15, -15, Float(DEFAULT_MINS_2))
                playerMaxs = vec3_t(15, 15, Float(DEFAULT_MAXS_2))

                fwd = cg.predictedPlayerState.origin
                fwd[2] -= 4096.0
                CG_Trace(tr, cg.predictedPlayerState.origin, playerMins, playerMaxs, fwd, cg.predictedPlayerState.clientNum, MASK_SOLID)

                if tr.startsolid == 0 && tr.allsolid == 0 {
                    trap_R_AutomapElevAdj(tr.endpos[2])
                }
            }
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

/// Source: oracle/codemp/cgame/cg_view.c:2447
func CG_DrawActiveFrame(_ serverTime: Int32, _ stereoView: JKAMP.stereoFrame_t, _ demoPlayback: Bool) {
    let inwater: Int32
    var cstr: String
    var mSensitivity: Float = cg.zoomSensitivity
    let mPitchOverride: Float = 0.0
    let mYawOverride: Float = 0.0
    var veh: Centity? = nil

    if cgQueueLoad {
        //do this before you start messing around with adding ghoul2 refents and crap
        CG_ActualLoadDeferredPlayers()
        cgQueueLoad = false
    }

    cg.time = serverTime
    cg.demoPlayback = demoPlayback

    if cg.snap != nil && ui_myteam.integer != cg.snap!.ps.persistant[PERS_TEAM] {
        trap_Cvar_Set("ui_myteam", va("%i", cg.snap!.ps.persistant[PERS_TEAM]))
    }
    if cgs.gametype == GT_SIEGE && cg.snap != nil && cg_siegeClassIndex != cgs.clientinfo[cg.snap!.ps.clientNum].siegeIndex {
        cg_siegeClassIndex = cgs.clientinfo[cg.snap!.ps.clientNum].siegeIndex
        if cg_siegeClassIndex == -1 {
            trap_Cvar_Set("ui_mySiegeClass", "<none>")
        } else {
            trap_Cvar_Set("ui_mySiegeClass", bgSiegeClasses[cg_siegeClassIndex].name)
        }
    }

    // update cvars
    CG_UpdateCvars()

    // if we are only updating the screen as a loading
    // pacifier, don't even try to read snapshots
    if !cg.infoScreenText.isEmpty {
        CG_DrawInformation()
        return
    }

    trap_FX_AdjustTime(cg.time)

    CG_RunLightStyles()

    // any looped sounds will be respecified as entities
    // are added to the render list
    trap_S_ClearLoopingSounds()

    // clear all the render lists
    trap_R_ClearScene()

    // set up cg.snap and possibly cg.nextSnap
    CG_ProcessSnapshots()

    trap_ROFF_UpdateEntities()

    // if we haven't received any snapshots yet, all
    // we can draw is the information screen
    if cg.snap == nil || (cg.snap!.snapFlags & SNAPFLAG_NOT_ACTIVE) != 0 {
        // Transition from zero to negative one on the snapshot timeout.
        // The reason we do this is because the first client frame is responsible for
        // some farily slow processing (such as weather) and we dont want to include
        // that processing time into our calculations
        // Transition the snapshot timeout time from -1 to the current time in
        // milliseconds which will start the timeout.

        // If we have been waiting too long then just error out
        CG_DrawInformation()
        return
    }

    // let the client system know what our weapon and zoom settings are
    if cg.snap != nil && cg.snap!.ps.saberLockTime > cg.time {
        mSensitivity = 0.01
    } else if cg.predictedPlayerState.weapon == WP_EMPLACED_GUN {
        //lower sens for emplaced guns and vehicles
        mSensitivity = 0.2
    }
    //mSensitivityOverride = 5.0f;//old default value

    do {
        if cg.predictedPlayerState.m_iVehicleNum != 0 {
            veh = cg_entities[cg.predictedPlayerState.m_iVehicleNum]
        }
        if veh != nil && veh!.currentState.eType == ET_NPC && veh!.currentState.NPC_class == CLASS_VEHICLE && veh!.m_pVehicle != nil && veh!.m_pVehicle!.m_pVehicleInfo!.type == VH_FIGHTER && bg_fighterAltControl.integer != 0 {
            trap_SetUserCmdValue(cg.weaponSelect, mSensitivity, mPitchOverride, mYawOverride, 0.0, cg.forceSelect, cg.itemSelect, true)
            veh = nil //this is done because I don't want an extra assign each frame because I am so perfect and super efficient.
        } else {
            trap_SetUserCmdValue(cg.weaponSelect, mSensitivity, mPitchOverride, mYawOverride, 0.0, cg.forceSelect, cg.itemSelect, false)
        }
    }

    // this counter will be bumped for every valid scene we generate
    cg.clientFrame += 1

    // update cg.predictedPlayerState
    CG_PredictPlayerState()

    // decide on third person view
    cg.renderingThirdPerson = cg_thirdPerson.integer != 0 || (cg.snap!.ps.stats[STAT_HEALTH] <= 0)

    if cg.snap!.ps.stats[STAT_HEALTH] > 0 {
        if cg.predictedPlayerState.weapon == WP_EMPLACED_GUN && cg.predictedPlayerState.emplacedIndex != 0 {
            //force third person for e-web and emplaced use
            cg.renderingThirdPerson = 1 != 0
        } else if cg.predictedPlayerState.weapon == WP_SABER || cg.predictedPlayerState.weapon == WP_MELEE || BG_InGrappleMove(cg.predictedPlayerState.torsoAnim) != 0 || BG_InGrappleMove(cg.predictedPlayerState.legsAnim) != 0 || cg.predictedPlayerState.forceHandExtend == HANDEXTEND_KNOCKDOWN || cg.predictedPlayerState.fallingToDeath != 0 || cg.predictedPlayerState.m_iVehicleNum != 0 || PM_InKnockDown(cg.predictedPlayerState) {
            if cg_fpls.integer != 0 && cg.predictedPlayerState.weapon == WP_SABER {
                //force to first person for fpls
                cg.renderingThirdPerson = 0 != 0
            } else {
                cg.renderingThirdPerson = 1 != 0
            }
        } else if cg.snap!.ps.zoomMode != 0 {
            //always force first person when zoomed
            cg.renderingThirdPerson = 0 != 0
        }
    }

    if cg.predictedPlayerState.pm_type == PM_SPECTATOR {
        //always first person for spec
        cg.renderingThirdPerson = 0 != 0
    }


    if cg.snap!.ps.persistant[PERS_TEAM] == TEAM_SPECTATOR {
        cg.renderingThirdPerson = 0 != 0
    }

    // build cg.refdef
    inwater = CG_CalcViewValues()

    if cg_linearFogOverride != 0 {
        trap_R_SetRangeFog(-cg_linearFogOverride)
    } else if cg.predictedPlayerState.zoomMode != 0 {
        //zooming with binoculars or sniper, set the fog range based on the zoom level -rww
        cg_rangedFogging = true
        //smaller the fov the less fog we have between the view and cull dist
        trap_R_SetRangeFog(cg.refdef.fov_x * 64.0)
    } else if cg_rangedFogging {
        //disable it
        cg_rangedFogging = false
        trap_R_SetRangeFog(0.0)
    }

    cstr = CG_ConfigString(CS_SKYBOXORG)

    if !cstr.isEmpty {
        //we have a skyportal
        CG_DrawSkyBoxPortal(cstr)
    }

    CG_CalcScreenEffects()

    // first person blend blobs, done after AnglesToAxis
    if !cg.renderingThirdPerson && cg.predictedPlayerState.pm_type != PM_SPECTATOR {
        CG_DamageBlendBlob()
    }

    // build the render lists
    if !cg.hyperspace {
        CG_AddPacketEntities(false) // adter calcViewValues, so predicted player state is correct
        CG_AddMarks()
        CG_AddParticles()
        CG_AddLocalEntities()
        CG_DrawMiscEnts()
    }
    CG_AddViewWeapon(cg.predictedPlayerState)

    if !cg.hyperspace {
        trap_FX_AddScheduledEffects(false)
    }

    // add buffered sounds
    CG_PlayBufferedSounds()

    // finish up the rest of the refdef
    if cg.testModelEntity.hModel != 0 {
        CG_AddTestModel()
    }
    cg.refdef.time = cg.time
    // Port-note: Raven's `memcpy( cg.refdef.areamask, cg.snap->areamask, sizeof( cg.refdef.areamask ) )` runs over bytes that are not one record with a view.
    // Raven wrote: memcpy( cg.refdef.areamask, cg.snap->areamask, sizeof( cg.refdef.areamask ) )
    portMissing("CG_DrawActiveFrame", source: "oracle/codemp/cgame/cg_view.c:2447")

    // warning sounds when powerup is wearing off
    CG_PowerupTimerSounds()

    // if there are any entities flagged as sound trackers and attached to other entities, update their sound pos
    CG_UpdateSoundTrackers()

    if gCGHasFallVector {
        var lookAng = vec3_t()

        lookAng = cg.snap!.ps.origin - cg.refdef.vieworg
        VectorNormalize(&lookAng)
        vectoangles(lookAng, &lookAng)

        cg.refdef.vieworg = gCGFallVector
        // Port-note: The draft of this statement did not compile, and the compiler wrote "'&' used with non-inout argument of type 'Slots<vec3_t>' (aka 'Slots<SIMD3<Float>>')".
        // Raven wrote: AnglesToAxis(lookAng, cg.refdef.viewaxis)
        portMissing("CG_DrawActiveFrame", source: "oracle/codemp/cgame/cg_view.c:2447")
    }

    //This is done from the vieworg to get origin for non-attenuated sounds
    cstr = CG_ConfigString(CS_GLOBAL_AMBIENT_SET)

    if !cstr.isEmpty {
        trap_S_UpdateAmbientSet(cstr, &cg.refdef.vieworg)
    }

    // update audio positions
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Slots<vec3_t>' (aka 'Slots<SIMD3<Float>>') to expected argument type '[vec3_t]' (aka 'Array<SIMD3<Float>>')".
    // Raven wrote: trap_S_Respatialize( cg.snap->ps.clientNum, cg.refdef.vieworg, cg.refdef.viewaxis, inwater )
    portMissing("CG_DrawActiveFrame", source: "oracle/codemp/cgame/cg_view.c:2447")

    // make sure the lagometerSample and frame timing isn't done twice when in stereo
    if stereoView != STEREO_RIGHT {
        cg.frametime = cg.time - cg.oldTime
        if cg.frametime < 0 {
            cg.frametime = 0
        }
        cg.oldTime = cg.time
        CG_AddLagometerFrameInfo()
    }
    if cg_timescale.value != cg_timescaleFadeEnd.value {
        if cg_timescale.value < cg_timescaleFadeEnd.value {
            cg_timescale.value += cg_timescaleFadeSpeed.value * (Float(cg.frametime)) / 1000
            if cg_timescale.value > cg_timescaleFadeEnd.value {
                cg_timescale.value = cg_timescaleFadeEnd.value
            }
        } else {
            cg_timescale.value -= cg_timescaleFadeSpeed.value * (Float(cg.frametime)) / 1000
            if cg_timescale.value < cg_timescaleFadeEnd.value {
                cg_timescale.value = cg_timescaleFadeEnd.value
            }
        }
        if cg_timescaleFadeSpeed.value != 0 {
            trap_Cvar_Set("timescale", va("%f", cg_timescale.value))
        }
    }

    // actually issue the rendering calls
    CG_DrawActive(stereoView)

    CG_DrawAutoMap()

    if cg_stats.integer != 0 {
        CG_Printf("cg.clientFrame:%i\n", cg.clientFrame)
    }
}
