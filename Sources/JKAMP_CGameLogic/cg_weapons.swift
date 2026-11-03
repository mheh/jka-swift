import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/cg_weapons.c:130
var cgWeapFrame: Int32 {
    get { world.variables.cgWeapFrame }
    set { world.variables.cgWeapFrame = newValue }
}

/// Source: oracle/codemp/cgame/cg_weapons.c:131
var cgWeapFrameTime: Int32 {
    get { world.variables.cgWeapFrameTime }
    set { world.variables.cgWeapFrameTime = newValue }
}

/// Source: oracle/codemp/cgame/cg_weapons.c:890
let ICON_WEAPONS = 0 as Int32

/// Source: oracle/codemp/cgame/cg_weapons.c:891
let ICON_FORCE = 1 as Int32

/// Source: oracle/codemp/cgame/cg_weapons.c:892
let ICON_INVENTORY = 2 as Int32

/// Source: oracle/codemp/cgame/cg_weapons.c:2322
// TODO: Port global g2WeaponInstances
// Raven wrote: static void *g2WeaponInstances[MAX_WEAPONS]
// No table row for `void *[19]`.

/**
```
Ghoul2 Insert Start
```
*/
// set up the appropriate ghoul2 info to a refent
/// Source: oracle/codemp/cgame/cg_weapons.c:15
func CG_SetGhoul2InfoRef(_ ent: JKAMP.RefEntity, _ s1: JKAMP.RefEntity) {
    ent.ghoul2 = s1.ghoul2
    ent.modelScale = s1.modelScale
    ent.radius = s1.radius
    ent.angles = s1.angles
}

/**
```
=================
CG_RegisterItemVisuals

The server says this item is used on this level
=================
```
*/
/// Source: oracle/codemp/cgame/cg_weapons.c:34
func CG_RegisterItemVisuals(_ itemNum: Int32) {
    var itemInfo: ItemInfo?
    var item: Gitem?
    let handle: Int32

    if itemNum < 0 || itemNum >= bg_numItems {
        CG_Error("CG_RegisterItemVisuals: itemNum %d out of range [0-%d]", itemNum, bg_numItems - 1)
    }

    itemInfo = cg_items[itemNum]
    if itemInfo!.registered {
        return
    }

    item = bg_itemlist[itemNum]

    // Port-note: Raven's `memset( itemInfo, 0, sizeof( &itemInfo ) )` runs over a size that is not the record's own, and a view's clear() takes the whole record.
    // Raven wrote: memset( itemInfo, 0, sizeof( &itemInfo ) )
    portMissing("CG_RegisterItemVisuals", source: "oracle/codemp/cgame/cg_weapons.c:34")
    itemInfo!.registered = true

    if item!.giType == IT_TEAM && (item!.giTag == PW_REDFLAG || item!.giTag == PW_BLUEFLAG) && cgs.gametype == GT_CTY {
        //in CTY the flag model is different
        // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'String?' must be unwrapped to a value of type 'String'".
        // Raven wrote: itemInfo->models[0] = trap_R_RegisterModel( item->world_model[1] )
        portMissing("CG_RegisterItemVisuals", source: "oracle/codemp/cgame/cg_weapons.c:34")
    } else if item!.giType == IT_WEAPON && (item!.giTag == WP_THERMAL || item!.giTag == WP_TRIP_MINE || item!.giTag == WP_DET_PACK) {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'String?' must be unwrapped to a value of type 'String'".
        // Raven wrote: itemInfo->models[0] = trap_R_RegisterModel( item->world_model[1] )
        portMissing("CG_RegisterItemVisuals", source: "oracle/codemp/cgame/cg_weapons.c:34")
    } else {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'String?' must be unwrapped to a value of type 'String'".
        // Raven wrote: itemInfo->models[0] = trap_R_RegisterModel( item->world_model[0] )
        portMissing("CG_RegisterItemVisuals", source: "oracle/codemp/cgame/cg_weapons.c:34")
    }
    /*
    Ghoul2 Insert Start
    */
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Int' to expected argument type 'Range<Int>'".
    // Raven wrote: if (!Q_stricmp(&item->world_model[0][strlen(item->world_model[0]) - 4], ".glm")) { handle = trap_G2API_InitGhoul2Model(&itemInfo->g2Models[0], item->world_model[0], 0 , 0, 0, 0, 0); if (handle<0) { itemInfo->g2Models[0] = NULL; } else { itemInfo->radius[0] = 60; } }
    portMissing("CG_RegisterItemVisuals", source: "oracle/codemp/cgame/cg_weapons.c:34")
    /*
    Ghoul2 Insert End
    */
    if item!.icon != nil {
        if item!.giType == IT_HEALTH {
            //medpack gets nomip'd by the ui or something I guess.
            itemInfo!.icon = trap_R_RegisterShaderNoMip(item!.icon!)
        } else {
            itemInfo!.icon = trap_R_RegisterShader(item!.icon!)
        }
    } else {
        itemInfo!.icon = 0
    }

    if item!.giType == IT_WEAPON {
        CG_RegisterWeapon(item!.giTag)
    }

    //
    // powerups have an accompanying ring or sphere
    //
    if item!.giType == IT_POWERUP || item!.giType == IT_HEALTH || item!.giType == IT_ARMOR || item!.giType == IT_HOLDABLE {
        if item!.world_model[1] != nil {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'String?' must be unwrapped to a value of type 'String'".
            // Raven wrote: itemInfo->models[1] = trap_R_RegisterModel( item->world_model[1] )
            portMissing("CG_RegisterItemVisuals", source: "oracle/codemp/cgame/cg_weapons.c:34")
        }
    }
}

/**
```
=================
CG_MapTorsoToWeaponFrame

=================
```
*/
/// Source: oracle/codemp/cgame/cg_weapons.c:140
private func CG_MapTorsoToWeaponFrame(_ ci: ClientInfo, _ frame: Int32, _ animNum: Int32) -> Int32 {
    let animations: Slots<Animation> = bgHumanoidAnimations
    if cg.snap!.ps.forceHandExtend != HANDEXTEND_NONE || cgWeapFrameTime > cg.time {
        //the reason for the after delay is so that it doesn't snap the weapon frame to the "idle" (0) frame
        //for a very quick moment
        if cgWeapFrame < 6 {
            cgWeapFrame = 6
            cgWeapFrameTime = cg.time + 10
        }

        if cgWeapFrameTime < cg.time && cgWeapFrame < 10 {
            cgWeapFrame += 1
            cgWeapFrameTime = cg.time + 10
        }

        if cg.snap!.ps.forceHandExtend != HANDEXTEND_NONE && cgWeapFrame == 10 {
            cgWeapFrameTime = cg.time + 100
        }

        return cgWeapFrame
    } else {
        cgWeapFrame = 0
        cgWeapFrameTime = 0
    }

    switch animNum {
    case TORSO_DROPWEAP1:
        if frame >= animations[animNum].firstFrame && frame < animations[animNum].firstFrame + 5 {
            return frame - animations[animNum].firstFrame + 6
        }

    case TORSO_RAISEWEAP1:
        if frame >= animations[animNum].firstFrame && frame < animations[animNum].firstFrame + 4 {
            return frame - animations[animNum].firstFrame + 6 + 4
        }

    case BOTH_ATTACK1, BOTH_ATTACK2, BOTH_ATTACK3, BOTH_ATTACK4, BOTH_ATTACK10, BOTH_THERMAL_THROW:
        if frame >= animations[animNum].firstFrame && frame < animations[animNum].firstFrame + 6 {
            return 1 + (frame - animations[animNum].firstFrame)
        }

    default:
        break
    }
    return -1
}

/**
```
==============
CG_CalculateWeaponPosition
==============
```
*/
/// Source: oracle/codemp/cgame/cg_weapons.c:210
private func CG_CalculateWeaponPosition(_ origin: inout JKAShared.vec3_t, _ angles: inout JKAShared.vec3_t) {
    var scale: Float
    let delta: Int32
    let fracsin: Float

    origin = cg.refdef.vieworg
    angles = cg.refdef.viewangles

    // on odd legs, invert some angles
    if (cg.bobcycle & 1) != 0 {
        scale = -cg.xyspeed
    } else {
        scale = cg.xyspeed
    }

    // gun angles from bobbing
    angles[ROLL] = Float(Double(angles[ROLL]) + (Double(scale * cg.bobfracsin) * 0.005))
    angles[YAW] = Float(Double(angles[YAW]) + (Double(scale * cg.bobfracsin) * 0.01))
    angles[PITCH] = Float(Double(angles[PITCH]) + (Double(cg.xyspeed * cg.bobfracsin) * 0.005))

    // drop the weapon when landing
    delta = cg.time - cg.landTime
    if delta < LAND_DEFLECT_TIME {
        origin[2] = Float(Double(origin[2]) + (Double(cg.landChange) * 0.25 * Double(delta) / Double(LAND_DEFLECT_TIME)))
    } else if delta < LAND_DEFLECT_TIME + LAND_RETURN_TIME {
        origin[2] = Float(Double(origin[2]) + (Double(cg.landChange) * 0.25 * Double(LAND_DEFLECT_TIME + LAND_RETURN_TIME - delta) / Double(LAND_RETURN_TIME)))
    }

    // drop the weapon when stair climbing

    // idle drift
    scale = cg.xyspeed + 40
    fracsin = Float(sin(Double(cg.time) * 0.001))
    angles[ROLL] = Float(Double(angles[ROLL]) + (Double(scale * fracsin) * 0.01))
    angles[YAW] = Float(Double(angles[YAW]) + (Double(scale * fracsin) * 0.01))
    angles[PITCH] = Float(Double(angles[PITCH]) + (Double(scale * fracsin) * 0.01))
}

/**
```
===============
CG_LightningBolt

Origin will be the exact tag point, which is slightly
different than the muzzle point used for determining hits.
The cent should be the non-predicted cent if it is from the player,
so the endpoint will reflect the simulated strike (lagging the predicted
angle)
===============
```
*/
/// Source: oracle/codemp/cgame/cg_weapons.c:269
private func CG_LightningBolt(_ cent: Centity, _ origin: JKAShared.vec3_t) {
    //	trace_t  trace;
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = RefEntity.scratch { beam -> Bool in
        //	vec3_t   forward;
        //	vec3_t   muzzlePoint, endPoint;

        //Must be a durational weapon that continuously generates an effect.
        if cent.currentState.weapon == WP_DEMP2 && (cent.currentState.eFlags & EF_ALT_FIRING) != 0 {
        } else {
            return true
        }

        // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.

        // NOTENOTE No lightning gun-ish stuff yet.
        /*
        // CPMA  "true" lightning
        if ((cent->currentState.number == cg.predictedPlayerState.clientNum) && (cg_trueLightning.value != 0)) {
        vec3_t angle;
        int i;

        for (i = 0; i < 3; i++) {
        float a = cent->lerpAngles[i] - cg.refdef.viewangles[i];
        if (a > 180) {
        a -= 360;
        }
        if (a < -180) {
        a += 360;
        }

        angle[i] = cg.refdef.viewangles[i] + a * (1.0 - cg_trueLightning.value);
        if (angle[i] < 0) {
        angle[i] += 360;
        }
        if (angle[i] > 360) {
        angle[i] -= 360;
        }
        }

        AngleVectors(angle, forward, NULL, NULL );
        VectorCopy(cent->lerpOrigin, muzzlePoint );
        //		VectorCopy(cg.refdef.vieworg, muzzlePoint );
        } else {
        // !CPMA
        AngleVectors( cent->lerpAngles, forward, NULL, NULL );
        VectorCopy(cent->lerpOrigin, muzzlePoint );
        }

        // FIXME: crouch
        muzzlePoint[2] += DEFAULT_VIEWHEIGHT;

        VectorMA( muzzlePoint, 14, forward, muzzlePoint );

        // project forward by the lightning range
        VectorMA( muzzlePoint, LIGHTNING_RANGE, forward, endPoint );

        // see if it hit a wall
        CG_Trace( &trace, muzzlePoint, vec3_origin, vec3_origin, endPoint,
        cent->currentState.number, MASK_SHOT );

        // this is the endpoint
        VectorCopy( trace.endpos, beam.oldorigin );

        // use the provided origin, even though it may be slightly
        // different than the muzzle origin
        VectorCopy( origin, beam.origin );

        beam.reType = RT_LIGHTNING;
        beam.customShader = cgs.media.lightningShader;
        trap_R_AddRefEntityToScene( &beam );
        */

        // NOTENOTE No lightning gun-ish stuff yet.
        /*
        // add the impact flare if it hit something
        if ( trace.fraction < 1.0 ) {
        vec3_t	angles;
        vec3_t	dir;

        VectorSubtract( beam.oldorigin, beam.origin, dir );
        VectorNormalize( dir );

        memset( &beam, 0, sizeof( beam ) );
        beam.hModel = cgs.media.lightningExplosionModel;

        VectorMA( trace.endpos, -16, dir, beam.origin );

        // make a random orientation
        angles[0] = rand() % 360;
        angles[1] = rand() % 360;
        angles[2] = rand() % 360;
        AnglesToAxis( angles, beam.axis );
        trap_R_AddRefEntityToScene( &beam );
        }
        */
        return false
    }
    if earlyOut {
        return
    }
}

/**
```
========================
CG_AddWeaponWithPowerups
========================
```
*/
/// Source: oracle/codemp/cgame/cg_weapons.c:374
private func CG_AddWeaponWithPowerups(_ gun: JKAMP.RefEntity, _ powerups: Int32) {
    // add powerup effects
    trap_R_AddRefEntityToScene(gun)

    if cg.predictedPlayerState.electrifyTime > cg.time {
        //add electrocution shell
        let preShader: Int32 = gun.customShader
        // The SDK also declares `rand`, so the call names the bg module.
        if (JKAMP_BG.rand() & 1) != 0 {
            gun.customShader = cgs.media.electricBodyShader
        } else {
            gun.customShader = cgs.media.electricBody2Shader
        }
        trap_R_AddRefEntityToScene(gun)
        gun.customShader = preShader //set back just to be safe
    }
}

/**
```
=============
CG_AddPlayerWeapon

Used for both the view weapon (ps is valid) and the world modelother character models (ps is NULL)
The main player will have this called for BOTH cases, so effects like light and
sound should only be done on the world model case.
=============
```
*/
/// Source: oracle/codemp/cgame/cg_weapons.c:404
func CG_AddPlayerWeapon(_ parent: JKAMP.RefEntity, _ ps: JKAMP.PlayerState?, _ cent: Centity, _ team: Int32, _ newAngles: JKAShared.vec3_t, _ thirdPerson: Bool) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = RefEntity.scratch { gun -> Bool in
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives true where Raven returns from the function.
        let earlyOut2 = RefEntity.scratch { barrel -> Bool in
            var angles = vec3_t()
            var weaponNum: weapon_t = 0
            var weapon: WeaponInfo?
            var nonPredictedCent: Centity?
            // Raven's record lives to the end of his block, so the block is the closure.
            // The closure gives true where Raven returns from the function.
            let earlyOut3 = RefEntity.scratch { flash -> Bool in

                weaponNum = cent.currentState.weapon

                if cent.currentState.weapon == WP_EMPLACED_GUN {
                    return true
                }

                if cg.predictedPlayerState.pm_type == PM_SPECTATOR && cent.currentState.number == cg.predictedPlayerState.clientNum {
                    //spectator mode, don't draw it...
                    return true
                }

                CG_RegisterWeapon(weaponNum)
                weapon = cg_weapons[weaponNum]
                /*
                Ghoul2 Insert Start
                */

                // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.

                // only do this if we are in first person, since world weapons are now handled on the server by Ghoul2
                if !thirdPerson {
                    // add the weapon
                    gun.lightingOrigin = parent.lightingOrigin
                    gun.shadowPlane = parent.shadowPlane
                    gun.renderfx = parent.renderfx

                    if ps != nil {
                        // this player, in first person view
                        gun.hModel = weapon!.viewModel
                    } else {
                        gun.hModel = weapon!.weaponModel
                    }
                    if gun.hModel == 0 {
                        return true
                    }

                    if ps == nil {
                        // add weapon ready sound
                        cent.pe.lightningFiring = 0
                        if (cent.currentState.eFlags & EF_FIRING) != 0 && weapon!.firingSound != 0 {
                            // lightning gun and guantlet make a different sound when fire is held down
                            trap_S_AddLoopingSound(cent.currentState.number, cent.lerpOrigin, vec3_origin, weapon!.firingSound)
                            cent.pe.lightningFiring = 1
                        } else if weapon!.readySound != 0 {
                            trap_S_AddLoopingSound(cent.currentState.number, cent.lerpOrigin, vec3_origin, weapon!.readySound)
                        }
                    }

                    CG_PositionEntityOnTag(gun, parent, parent.hModel, "tag_weapon")

                    if CG_IsMindTricked(cent.currentState.trickedentindex, cent.currentState.trickedentindex2, cent.currentState.trickedentindex3, cent.currentState.trickedentindex4, cg.snap!.ps.clientNum) == 0 {
                        CG_AddWeaponWithPowerups(gun, cent.currentState.powerups) //don't draw the weapon if the player is invisible
                        /*
                        if ( weaponNum == WP_STUN_BATON )
                        {
                        gun.shaderRGBA[0] = gun.shaderRGBA[1] = gun.shaderRGBA[2] = 25;

                        gun.customShader = trap_R_RegisterShader( "gfx/effects/stunPass" );
                        gun.renderfx = RF_RGB_TINT | RF_FIRST_PERSON | RF_DEPTHHACK;
                        trap_R_AddRefEntityToScene( &gun );
                        }
                        */
                    }

                    if weaponNum == WP_STUN_BATON {
                        var i: Int32 = 0

                        while i < 3 {
                            barrel.clear()
                            barrel.lightingOrigin = parent.lightingOrigin
                            barrel.shadowPlane = parent.shadowPlane
                            barrel.renderfx = parent.renderfx

                            if i == 0 {
                                barrel.hModel = trap_R_RegisterModel("models/weapons2/stun_baton/baton_barrel.md3")
                            } else if i == 1 {
                                barrel.hModel = trap_R_RegisterModel("models/weapons2/stun_baton/baton_barrel2.md3")
                            } else {
                                barrel.hModel = trap_R_RegisterModel("models/weapons2/stun_baton/baton_barrel3.md3")
                            }
                            angles[YAW] = 0
                            angles[PITCH] = 0
                            angles[ROLL] = 0

                            // Port-note: The draft of this statement did not compile, and the compiler wrote "'&' used with non-inout argument of type 'Slots<vec3_t>' (aka 'Slots<SIMD3<Float>>')".
                            // Raven wrote: AnglesToAxis( angles, barrel.axis )
                            portMissing("CG_AddPlayerWeapon", source: "oracle/codemp/cgame/cg_weapons.c:404")

                            if i == 0 {
                                CG_PositionRotatedEntityOnTag(barrel, parent, weapon!.handsModel, "tag_barrel")
                            } else if i == 1 {
                                CG_PositionRotatedEntityOnTag(barrel, parent, weapon!.handsModel, "tag_barrel2")
                            } else {
                                CG_PositionRotatedEntityOnTag(barrel, parent, weapon!.handsModel, "tag_barrel3")
                            }
                            CG_AddWeaponWithPowerups(barrel, cent.currentState.powerups)

                            i += 1
                        }
                    } else {
                        // add the spinning barrel
                        if weapon!.barrelModel != 0 {
                            // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.
                            barrel.lightingOrigin = parent.lightingOrigin
                            barrel.shadowPlane = parent.shadowPlane
                            barrel.renderfx = parent.renderfx

                            barrel.hModel = weapon!.barrelModel
                            angles[YAW] = 0
                            angles[PITCH] = 0
                            angles[ROLL] = 0

                            // Port-note: The draft of this statement did not compile, and the compiler wrote "'&' used with non-inout argument of type 'Slots<vec3_t>' (aka 'Slots<SIMD3<Float>>')".
                            // Raven wrote: AnglesToAxis( angles, barrel.axis )
                            portMissing("CG_AddPlayerWeapon", source: "oracle/codemp/cgame/cg_weapons.c:404")

                            CG_PositionRotatedEntityOnTag(barrel, parent, weapon!.handsModel, "tag_barrel")

                            CG_AddWeaponWithPowerups(barrel, cent.currentState.powerups)
                        }
                    }
                }
                /*
                Ghoul2 Insert End
                */

                // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.
                CG_PositionEntityOnTag(flash, gun, gun.hModel, "tag_flash")

                cg.lastFPFlashPoint = flash.origin

                // Do special charge bits
                //-----------------------
                if (ps != nil || cg.renderingThirdPerson || cg.predictedPlayerState.clientNum != cent.currentState.number) && ((cent.currentState.modelindex2 == WEAPON_CHARGING_ALT && cent.currentState.weapon == WP_BRYAR_PISTOL) || (cent.currentState.modelindex2 == WEAPON_CHARGING_ALT && cent.currentState.weapon == WP_BRYAR_OLD) || (cent.currentState.weapon == WP_BOWCASTER && cent.currentState.modelindex2 == WEAPON_CHARGING) || (cent.currentState.weapon == WP_DEMP2 && cent.currentState.modelindex2 == WEAPON_CHARGING_ALT)) {
                    var shader: Int32 = 0
                    var val: Float = 0.0
                    var scale: Float = 1.0
                    // Raven's record lives to the end of his block, so the block is the closure.
                    // The closure gives true where Raven returns from the function.
                    let earlyOut4 = AddspriteArgStruct.scratch { fxSArgs -> Bool in
                        var flashorigin = vec3_t()
                        var flashdir = vec3_t()

                        if !thirdPerson {
                            flashorigin = flash.origin
                            flashdir = flash.axis[0]
                        } else {
                            // Raven's record lives to the end of his block, so the block is the closure.
                            // The closure gives true where Raven returns from the function.
                            let earlyOut5 = MdxaBone.scratch { boltMatrix -> Bool in

                                if !trap_G2API_HasGhoul2ModelOnIndex((cent.ghoul2), 1) {
                                    //it's quite possible that we may have have no weapon model and be in a valid state, so return here if this is the case
                                    return true
                                }

                                // go away and get me the bolt position for this frame please
                                if !(trap_G2API_GetBoltMatrix(cent.ghoul2, 1, 0, boltMatrix, newAngles, cent.lerpOrigin, cg.time, cgs.gameModels, &cent.modelScale)) {
                                    // Couldn't find bolt point.
                                    return true
                                }

                                BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &flashorigin)
                                BG_GiveMeVectorFromMatrix(boltMatrix, POSITIVE_X, &flashdir)
                                return false
                            }
                            if earlyOut5 {
                                return true
                            }
                        }

                        if cent.currentState.weapon == WP_BRYAR_PISTOL || cent.currentState.weapon == WP_BRYAR_OLD {
                            // Hardcoded max charge time of 1 second
                            val = (cg.time - cent.currentState.constantLight) * 0.001
                            shader = cgs.media.bryarFrontFlash
                        } else if cent.currentState.weapon == WP_BOWCASTER {
                            // Hardcoded max charge time of 1 second
                            val = (cg.time - cent.currentState.constantLight) * 0.001
                            shader = cgs.media.greenFrontFlash
                        } else if cent.currentState.weapon == WP_DEMP2 {
                            val = (cg.time - cent.currentState.constantLight) * 0.001
                            shader = cgs.media.lightningFlash
                            scale = 1.75
                        }

                        if val < 0.0 {
                            val = 0.0
                        } else if val > 1.0 {
                            val = 1.0
                            if ps != nil && cent.currentState.number == ps!.clientNum {
                                CGCam_Shake(0.2, 100)
                            }
                        } else {
                            if ps != nil && cent.currentState.number == ps!.clientNum {
                                CGCam_Shake(val * val * 0.6, 100)
                            }
                        }

                        // The SDK also declares `random`, so the call names the bg module.
                        val += JKAMP_BG.random() * 0.5

                        fxSArgs.origin = flashorigin
                        fxSArgs.vel = vec3_t()
                        fxSArgs.accel = vec3_t()
                        fxSArgs.scale = 3.0 * val * scale
                        fxSArgs.dscale = 0.0
                        fxSArgs.sAlpha = 0.7
                        fxSArgs.eAlpha = 0.7
                        // The SDK also declares `random`, so the call names the bg module.
                        fxSArgs.rotation = JKAMP_BG.random() * 360
                        fxSArgs.bounce = 0.0
                        fxSArgs.life = 1
                        fxSArgs.shader = shader
                        fxSArgs.flags = 0x08000000

                        //FX_AddSprite( flash.origin, NULL, NULL, 3.0f * val, 0.0f, 0.7f, 0.7f, WHITE, WHITE, random() * 360, 0.0f, 1.0f, shader, FX_USE_ALPHA );
                        trap_FX_AddSprite(fxSArgs)
                        return false
                    }
                    if earlyOut4 {
                        return true
                    }
                }

                // make sure we aren't looking at cg.predictedPlayerEntity for LG
                nonPredictedCent = cg_entities[cent.currentState.clientNum]

                // if the index of the nonPredictedCent is not the same as the clientNum
                // then this is a fake player (like on teh single player podiums), so
                // go ahead and use the cent
                if (cg_entities.index(of: nonPredictedCent!)) != cent.currentState.clientNum {
                    nonPredictedCent = cent
                }

                // add the flash
                if (weaponNum == WP_DEMP2) && (nonPredictedCent!.currentState.eFlags & EF_FIRING) != 0 {
                    // continuous flash
                } else {
                    // impulse flash
                    if cg.time - cent.muzzleFlashTime > MUZZLE_FLASH_TIME {
                        return true
                    }
                }

                if ps != nil || cg.renderingThirdPerson || cent.currentState.number != cg.predictedPlayerState.clientNum {
                    // Make sure we don't do the thirdperson model effects for the local player if we're in first person
                    var flashorigin = vec3_t()
                    var flashdir = vec3_t()
                    // Raven's record lives to the end of his block, so the block is the closure.
                    // The closure gives true where Raven returns from the function.
                    let earlyOut4 = RefEntity.scratch { flash -> Bool in

                        // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.

                        if !thirdPerson {
                            CG_PositionEntityOnTag(flash, gun, gun.hModel, "tag_flash")
                            flashorigin = flash.origin
                            flashdir = flash.axis[0]
                        } else {
                            // Raven's record lives to the end of his block, so the block is the closure.
                            // The closure gives true where Raven returns from the function.
                            let earlyOut5 = MdxaBone.scratch { boltMatrix -> Bool in

                                if !trap_G2API_HasGhoul2ModelOnIndex((cent.ghoul2), 1) {
                                    //it's quite possible that we may have have no weapon model and be in a valid state, so return here if this is the case
                                    return true
                                }

                                // go away and get me the bolt position for this frame please
                                if !(trap_G2API_GetBoltMatrix(cent.ghoul2, 1, 0, boltMatrix, newAngles, cent.lerpOrigin, cg.time, cgs.gameModels, &cent.modelScale)) {
                                    // Couldn't find bolt point.
                                    return true
                                }

                                BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &flashorigin)
                                BG_GiveMeVectorFromMatrix(boltMatrix, POSITIVE_X, &flashdir)
                                return false
                            }
                            if earlyOut5 {
                                return true
                            }
                        }

                        if cg.time - cent.muzzleFlashTime <= MUZZLE_FLASH_TIME + 10 {
                            // Handle muzzle flashes
                            if (cent.currentState.eFlags & EF_ALT_FIRING) != 0 {
                                // Check the alt firing first.
                                if weapon!.altMuzzleEffect != 0 {
                                    if !thirdPerson {
                                        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Slots<vec3_t>' (aka 'Slots<SIMD3<Float>>') to expected argument type '[vec3_t]' (aka 'Array<SIMD3<Float>>')".
                                        // Raven wrote: trap_FX_PlayEntityEffectID(weapon->altMuzzleEffect, flashorigin, flash.axis, -1, -1, -1, -1 )
                                        portMissing("CG_AddPlayerWeapon", source: "oracle/codemp/cgame/cg_weapons.c:404")
                                    } else {
                                        trap_FX_PlayEffectID(weapon!.altMuzzleEffect, flashorigin, flashdir, -1, -1)
                                    }
                                }
                            } else {
                                // Regular firing
                                if weapon!.muzzleEffect != 0 {
                                    if !thirdPerson {
                                        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Slots<vec3_t>' (aka 'Slots<SIMD3<Float>>') to expected argument type '[vec3_t]' (aka 'Array<SIMD3<Float>>')".
                                        // Raven wrote: trap_FX_PlayEntityEffectID(weapon->muzzleEffect, flashorigin, flash.axis, -1, -1, -1, -1 )
                                        portMissing("CG_AddPlayerWeapon", source: "oracle/codemp/cgame/cg_weapons.c:404")
                                    } else {
                                        trap_FX_PlayEffectID(weapon!.muzzleEffect, flashorigin, flashdir, -1, -1)
                                    }
                                }
                            }
                        }

                        // add lightning bolt
                        CG_LightningBolt(nonPredictedCent!, flashorigin)

                        if weapon!.flashDlightColor[0] != 0 || weapon!.flashDlightColor[1] != 0 || weapon!.flashDlightColor[2] != 0 {
                            // The SDK also declares `rand`, so the call names the bg module.
                            trap_R_AddLightToScene(flashorigin, Float(300 + (JKAMP_BG.rand() & 31)), weapon!.flashDlightColor[0], weapon!.flashDlightColor[1], weapon!.flashDlightColor[2])
                        }
                        return false
                    }
                    if earlyOut4 {
                        return true
                    }
                }
                return false
            }
            if earlyOut3 {
                return true
            }
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
==============
CG_AddViewWeapon

Add the weapon, and flash for the player's view
==============
```
*/
/// Source: oracle/codemp/cgame/cg_weapons.c:766
func CG_AddViewWeapon(_ ps: JKAMP.PlayerState) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = RefEntity.scratch { hand -> Bool in
        var cent: Centity?
        var ci: ClientInfo?
        var fovOffset: Float = 0
        var angles = vec3_t()
        var weapon: WeaponInfo?
        var cgFov: Float = cg_fov.value

        if cgFov < 1 {
            cgFov = 1
        }
        if cgFov > 97 {
            cgFov = 97
        }

        if ps.persistant[PERS_TEAM] == TEAM_SPECTATOR {
            return true
        }

        if ps.pm_type == PM_INTERMISSION {
            return true
        }

        // no gun if in third person view or a camera is active
        //if ( cg.renderingThirdPerson || cg.cameraMode) {
        if cg.renderingThirdPerson {
            return true
        }

        // allow the gun to be completely removed
        if cg_drawGun.integer == 0 || cg.predictedPlayerState.zoomMode != 0 {
            var origin = vec3_t()

            if (cg.predictedPlayerState.eFlags & EF_FIRING) != 0 {
                // special hack for lightning gun...
                origin = cg.refdef.vieworg
                _VectorMA(origin, -8, cg.refdef.viewaxis[2], &origin)
                CG_LightningBolt(cg_entities[ps.clientNum], origin)
            }
            return true
        }

        // don't draw if testing a gun model
        if cg.testGun {
            return true
        }

        // drop gun lower at higher fov
        if cgFov > 90 {
            fovOffset = Float(-0.2 * Double(cgFov - 90))
        } else {
            fovOffset = 0
        }

        cent = cg_entities[cg.predictedPlayerState.clientNum]
        CG_RegisterWeapon(ps.weapon)
        weapon = cg_weapons[ps.weapon]

        // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.

        // set up gun position
        CG_CalculateWeaponPosition(&hand.origin, &angles)

        _VectorMA(hand.origin, cg_gun_x.value, cg.refdef.viewaxis[0], &hand.origin)
        _VectorMA(hand.origin, cg_gun_y.value, cg.refdef.viewaxis[1], &hand.origin)
        _VectorMA(hand.origin, (cg_gun_z.value + fovOffset), cg.refdef.viewaxis[2], &hand.origin)

        // Port-note: The draft of this statement did not compile, and the compiler wrote "'&' used with non-inout argument of type 'Slots<vec3_t>' (aka 'Slots<SIMD3<Float>>')".
        // Raven wrote: AnglesToAxis( angles, hand.axis )
        portMissing("CG_AddViewWeapon", source: "oracle/codemp/cgame/cg_weapons.c:766")

        // map torso animations to weapon animations
        if cg_gun_frame.integer != 0 {
            // development tool
            hand.oldframe = cg_gun_frame.integer
            hand.frame = hand.oldframe
            hand.backlerp = 0
        } else {
            // get clientinfo for animation map
            if cent!.currentState.eType == ET_NPC {
                if cent!.npcClient == nil {
                    return true
                }

                ci = cent!.npcClient
            } else {
                ci = cgs.clientinfo[cent!.currentState.clientNum]
            }
            hand.frame = CG_MapTorsoToWeaponFrame(ci!, cent!.pe.torso.frame, cent!.currentState.torsoAnim)
            hand.oldframe = CG_MapTorsoToWeaponFrame(ci!, cent!.pe.torso.oldFrame, cent!.currentState.torsoAnim)
            hand.backlerp = cent!.pe.torso.backlerp

            // Handle the fringe situation where oldframe is invalid
            if hand.frame == -1 {
                hand.frame = 0
                hand.oldframe = 0
                hand.backlerp = 0
            } else if hand.oldframe == -1 {
                hand.oldframe = hand.frame
                hand.backlerp = 0
            }
        }

        hand.hModel = weapon!.handsModel
        hand.renderfx = RF_DEPTHHACK | RF_FIRST_PERSON // | RF_MINLIGHT;

        // add everything onto the hand
        CG_AddPlayerWeapon(hand, ps, cg_entities[cg.predictedPlayerState.clientNum], ps.persistant[PERS_TEAM], angles, false)
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/cgame/cg_weapons.c:895
func CG_DrawIconBackground() {
    let height: Int32
    let xAdd: Int32
    let x2: Int32
    let y2: Int32
    var t: Int32
    //	int				prongLeftX,prongRightX;
    let inTime: Float = cg.invenSelectTime + WEAPON_SELECT_TIME
    let wpTime: Float = Float(cg.weaponSelectTime + WEAPON_SELECT_TIME)
    let fpTime: Float = cg.forceSelectTime + WEAPON_SELECT_TIME
    //	int				drawType = cgs.media.weaponIconBackground;
    //	int				yOffset = 0;

    //yOffset = -50;

    // don't display if dead
    if cg.snap!.ps.stats[STAT_HEALTH] <= 0 {
        return
    }

    if cg_hudFiles.integer != 0 {
        //simple hud
        return
    }

    x2 = 30
    y2 = SCREEN_HEIGHT - 70

    //prongLeftX =x2+37;
    //prongRightX =x2+544;

    if inTime > wpTime {
        //		drawType = cgs.media.inventoryIconBackground;
        cg.iconSelectTime = cg.invenSelectTime
    } else {
        //		drawType = cgs.media.weaponIconBackground;
        cg.iconSelectTime = Float(cg.weaponSelectTime)
    }

    if fpTime > inTime && fpTime > wpTime {
        //		drawType = cgs.media.forceIconBackground;
        cg.iconSelectTime = cg.forceSelectTime
    }

    if (cg.iconSelectTime + WEAPON_SELECT_TIME) < cg.time {
        if cg.iconHUDActive {
            t = Int32(cg.time - (cg.iconSelectTime + WEAPON_SELECT_TIME))
            cg.iconHUDPercent = t / 130.0
            cg.iconHUDPercent = 1 - cg.iconHUDPercent

            if cg.iconHUDPercent < 0 {
                cg.iconHUDActive = false
                cg.iconHUDPercent = 0
            }

            xAdd = Int32(Int32(8) * cg.iconHUDPercent)

            height = Int32((60.0 * cg.iconHUDPercent))
            //CG_DrawPic( x2+60, y2+30+yOffset, 460, -height, drawType);	// Top half
            //CG_DrawPic( x2+60, y2+30-2+yOffset, 460, height, drawType);	// Bottom half
        } else {
            xAdd = 0
        }

        return
    }
    //prongLeftX =x2+37;
    //prongRightX =x2+544;

    if !cg.iconHUDActive {
        t = Int32(cg.time - cg.iconSelectTime)
        cg.iconHUDPercent = t / 130.0

        // Calc how far into opening sequence we are
        if cg.iconHUDPercent > 1 {
            cg.iconHUDActive = true
            cg.iconHUDPercent = 1
        } else if cg.iconHUDPercent < 0 {
            cg.iconHUDPercent = 0
        }
    } else {
        cg.iconHUDPercent = 1
    }

    //trap_R_SetColor( colorTable[CT_WHITE] );
    //height = (int) (60.0f*cg.iconHUDPercent);
    //CG_DrawPic( x2+60, y2+30+yOffset, 460, -height, drawType);	// Top half
    //CG_DrawPic( x2+60, y2+30-2+yOffset, 460, height, drawType);	// Bottom half

    // And now for the prongs
    /*	if ((cg.inventorySelectTime+WEAPON_SELECT_TIME)>cg.time)
    {
    cgs.media.currentBackground = ICON_INVENTORY;
    background = &cgs.media.inventoryProngsOn;
    }
    else if ((cg.weaponSelectTime+WEAPON_SELECT_TIME)>cg.time)
    {
    cgs.media.currentBackground = ICON_WEAPONS;
    }
    else
    {
    cgs.media.currentBackground = ICON_FORCE;
    background = &cgs.media.forceProngsOn;
    }
    */
    // Side Prongs
    //	trap_R_SetColor( colorTable[CT_WHITE]);
    //	xAdd = (int) 8*cg.iconHUDPercent;
    //	CG_DrawPic( prongLeftX+xAdd, y2-10, 40, 80, background);
    //	CG_DrawPic( prongRightX-xAdd, y2-10, -40, 80, background);
}

/// Source: oracle/codemp/cgame/cg_weapons.c:1024
func CG_WeaponCheck(_ weap: Int32) -> Bool {
    if cg.snap!.ps.ammo[weaponData[weap].ammoIndex] < weaponData[weap].energyPerShot && cg.snap!.ps.ammo[weaponData[weap].ammoIndex] < weaponData[weap].altEnergyPerShot {
        return false
    }

    return true
}

/**
```
===============
CG_WeaponSelectable
===============
```
*/
/// Source: oracle/codemp/cgame/cg_weapons.c:1040
private func CG_WeaponSelectable(_ i: Int32) -> Bool {
    /*if ( !cg.snap->ps.ammo[weaponData[i].ammoIndex] ) {
    return qfalse;
    }*/
    if i == 0 {
        return false
    }

    if cg.predictedPlayerState.ammo[weaponData[i].ammoIndex] < weaponData[i].energyPerShot && cg.predictedPlayerState.ammo[weaponData[i].ammoIndex] < weaponData[i].altEnergyPerShot {
        return false
    }

    if i == WP_DET_PACK && cg.predictedPlayerState.ammo[weaponData[i].ammoIndex] < 1 && !cg.predictedPlayerState.hasDetPackPlanted {
        return false
    }

    if !((cg.predictedPlayerState.stats[STAT_WEAPONS] & (1 << i)) != 0) {
        return false
    }

    return true
}

/// Source: oracle/codemp/cgame/cg_weapons.c:1076
func CG_DrawWeaponSelect() {
    var i: Int32
    let bits: Int32
    var count: Int32
    let smallIconSize: Int32
    let bigIconSize: Int32
    var holdX: Int32
    let x: Int32
    let y: Int32
    let pad: Int32
    var sideLeftIconCnt: Int32
    var sideRightIconCnt: Int32
    let sideMax: Int32
    let holdCount: Int32
    var iconCnt: Int32
    var height: Int32
    let yOffset: Int32 = 0
    var drewConc: Bool = false

    if cg.predictedPlayerState.emplacedIndex != 0 {
        //can't cycle when on a weapon
        cg.weaponSelectTime = 0
    }

    if (cg.weaponSelectTime + WEAPON_SELECT_TIME) < cg.time {
        return
    }

    // don't display if dead
    if cg.predictedPlayerState.stats[STAT_HEALTH] <= 0 {
        return
    }



    // showing weapon select clears pickup item display, but not the blend blob
    cg.itemPickupTime = 0

    bits = cg.predictedPlayerState.stats[STAT_WEAPONS]

    // count the number of weapons owned
    count = 0

    if !CG_WeaponSelectable(cg.weaponSelect) && (cg.weaponSelect == WP_THERMAL || cg.weaponSelect == WP_TRIP_MINE) {
        //display this weapon that we don't actually "have" as unhighlighted until it's deselected
        //since it's selected we must increase the count to display the proper number of valid selectable weapons
        count += 1
    }

    i = 1
    while i < WP_NUM_WEAPONS {
        if (bits & (1 << i)) != 0 {
            if CG_WeaponSelectable(i) || (i != WP_THERMAL && i != WP_TRIP_MINE) {
                count += 1
            }
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

    if cg.weaponSelect == WP_CONCUSSION {
        i = WP_FLECHETTE
    } else {
        i = cg.weaponSelect - 1
    }
    if i < 1 {
        i = WP_BRYAR_OLD
    }

    smallIconSize = 40
    bigIconSize = 80
    pad = 12

    x = 320
    y = 410

    // Background
    //	memcpy(calcColor, colorTable[CT_WHITE], sizeof(vec4_t));
    //	calcColor[3] = .35f;
    //	trap_R_SetColor( calcColor);

    // Left side ICONS
    trap_R_SetColor(colorTable[CT_WHITE])
    // Work backwards from current icon
    holdX = x - ((bigIconSize / 2) + pad + smallIconSize)
    height = smallIconSize * 1 //cg.iconHUDPercent;
    drewConc = false

    iconCnt = 1
    while iconCnt < (sideLeftIconCnt + 1) {
        if i == WP_CONCUSSION {
            i -= 1
        } else if i == WP_FLECHETTE && !drewConc && cg.weaponSelect != WP_CONCUSSION {
            i = WP_CONCUSSION
        }
        if i < 1 {
            //i = 13;
            //...don't ever do this.
            i = WP_BRYAR_OLD
        }

        if !((bits & (1 << i)) != 0) {
            if i == WP_CONCUSSION {
                drewConc = true
                i = WP_ROCKET_LAUNCHER
            }
            i -= 1
            continue
        }

        if !CG_WeaponSelectable(i) && (i == WP_THERMAL || i == WP_TRIP_MINE) {
            //Don't show thermal and tripmine when out of them
            i -= 1
            continue
        }

        iconCnt += 1 // Good icon

        if cgs.media.weaponIcons[i] != 0 {
            var weaponInfo: WeaponInfo?
            CG_RegisterWeapon(i)
            weaponInfo = cg_weapons[i]

            trap_R_SetColor(colorTable[CT_WHITE])
            if !CG_WeaponCheck(i) {
                CG_DrawPic(Float(holdX), Float(y + 10 + yOffset), Float(smallIconSize), Float(smallIconSize), cgs.media.weaponIcons_NA[i])
            } else {
                CG_DrawPic(Float(holdX), Float(y + 10 + yOffset), Float(smallIconSize), Float(smallIconSize), cgs.media.weaponIcons[i])
            }

            holdX -= (smallIconSize + pad)
        }
        if i == WP_CONCUSSION {
            drewConc = true
            i = WP_ROCKET_LAUNCHER
        }
        i -= 1
    }

    // Current Center Icon
    height = Int32(bigIconSize * cg.iconHUDPercent)
    if cgs.media.weaponIcons[cg.weaponSelect] != 0 {
        var weaponInfo: WeaponInfo?
        CG_RegisterWeapon(cg.weaponSelect)
        weaponInfo = cg_weapons[cg.weaponSelect]

        trap_R_SetColor(colorTable[CT_WHITE])
        if !CG_WeaponCheck(cg.weaponSelect) {
            CG_DrawPic(Float(x - (bigIconSize / 2)), Float((y - ((bigIconSize - smallIconSize) / 2)) + 10 + yOffset), Float(bigIconSize), Float(bigIconSize), cgs.media.weaponIcons_NA[cg.weaponSelect])
        } else {
            CG_DrawPic(Float(x - (bigIconSize / 2)), Float((y - ((bigIconSize - smallIconSize) / 2)) + 10 + yOffset), Float(bigIconSize), Float(bigIconSize), cgs.media.weaponIcons[cg.weaponSelect])
        }
    }

    if cg.weaponSelect == WP_CONCUSSION {
        i = WP_ROCKET_LAUNCHER
    } else {
        i = cg.weaponSelect + 1
    }
    if i > WP_BRYAR_OLD {
        i = 1
    }

    // Right side ICONS
    // Work forwards from current icon
    holdX = x + (bigIconSize / 2) + pad
    height = Int32(smallIconSize * cg.iconHUDPercent)
    iconCnt = 1
    while iconCnt < (sideRightIconCnt + 1) {
        if i == WP_CONCUSSION {
            i += 1
        } else if i == WP_ROCKET_LAUNCHER && !drewConc && cg.weaponSelect != WP_CONCUSSION {
            i = WP_CONCUSSION
        }
        if i > WP_BRYAR_OLD {
            i = 1
        }

        if !((bits & (1 << i)) != 0) {
            if i == WP_CONCUSSION {
                drewConc = true
                i = WP_FLECHETTE
            }
            i += 1
            continue
        }

        if !CG_WeaponSelectable(i) && (i == WP_THERMAL || i == WP_TRIP_MINE) {
            //Don't show thermal and tripmine when out of them
            i += 1
            continue
        }

        iconCnt += 1 // Good icon

        if cgs.media.weaponIcons[i] != 0 {
            var weaponInfo: WeaponInfo?
            CG_RegisterWeapon(i)
            weaponInfo = cg_weapons[i]
            // No ammo for this weapon?
            trap_R_SetColor(colorTable[CT_WHITE])
            if !CG_WeaponCheck(i) {
                CG_DrawPic(Float(holdX), Float(y + 10 + yOffset), Float(smallIconSize), Float(smallIconSize), cgs.media.weaponIcons_NA[i])
            } else {
                CG_DrawPic(Float(holdX), Float(y + 10 + yOffset), Float(smallIconSize), Float(smallIconSize), cgs.media.weaponIcons[i])
            }


            holdX += (smallIconSize + pad)
        }
        if i == WP_CONCUSSION {
            drewConc = true
            i = WP_FLECHETTE
        }
        i += 1
    }

    // draw the selected name
    if cg_weapons[cg.weaponSelect].item != nil {
        var textColor = vec4_t(0.875, 0.718, 0.121, 1.0)
        var text = CharBuf(1024)
        var upperKey = CharBuf(1024)

        strcpy(&upperKey, cg_weapons[cg.weaponSelect].item!.classname!)

        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'CharBuf' to expected argument type 'String'".
        // Raven wrote: if ( trap_SP_GetStringTextString( va("SP_INGAME_%s",Q_strupr(upperKey)), text, sizeof( text ))) { UI_DrawProportionalString(320, y+45+yOffset, text, UI_CENTER|UI_SMALLFONT, textColor); } else { UI_DrawProportionalString(320, y+45+yOffset, cg_weapons[ cg.weaponSelect ].item->classname, UI_CENTER|UI_SMALLFONT, textColor); }
        portMissing("CG_DrawWeaponSelect", source: "oracle/codemp/cgame/cg_weapons.c:1076")
    }

    trap_R_SetColor(nil)
}

/**
```
===============
CG_NextWeapon_f
===============
```
*/
/// Source: oracle/codemp/cgame/cg_weapons.c:1379
func CG_NextWeapon_f() {
    var i: Int32
    let original: Int32

    if cg.snap == nil {
        return
    }
    if (cg.snap!.ps.pm_flags & PMF_FOLLOW) != 0 {
        return
    }

    if cg.predictedPlayerState.pm_type == PM_SPECTATOR {
        return
    }

    if cg.snap!.ps.emplacedIndex != 0 {
        return
    }

    cg.weaponSelectTime = cg.time
    original = cg.weaponSelect

    i = 0
    while i < WP_NUM_WEAPONS {
        //*SIGH*... Hack to put concussion rifle before rocketlauncher
        if cg.weaponSelect == WP_FLECHETTE {
            cg.weaponSelect = WP_CONCUSSION
        } else if cg.weaponSelect == WP_CONCUSSION {
            cg.weaponSelect = WP_ROCKET_LAUNCHER
        } else if cg.weaponSelect == WP_DET_PACK {
            cg.weaponSelect = WP_BRYAR_OLD
        } else {
            cg.weaponSelect += 1
        }
        if cg.weaponSelect == WP_NUM_WEAPONS {
            cg.weaponSelect = 0
        }
        //	if ( cg.weaponSelect == WP_STUN_BATON ) {
        //		continue;		// never cycle to gauntlet
        //	}
        if CG_WeaponSelectable(cg.weaponSelect) {
            break
        }
        i += 1
    }
    if i == WP_NUM_WEAPONS {
        cg.weaponSelect = original
    } else {
        trap_S_MuteSound(cg.snap!.ps.clientNum, CHAN_WEAPON)
    }
}

/**
```
===============
CG_PrevWeapon_f
===============
```
*/
/// Source: oracle/codemp/cgame/cg_weapons.c:1445
func CG_PrevWeapon_f() {
    var i: Int32
    let original: Int32

    if cg.snap == nil {
        return
    }
    if (cg.snap!.ps.pm_flags & PMF_FOLLOW) != 0 {
        return
    }

    if cg.predictedPlayerState.pm_type == PM_SPECTATOR {
        return
    }

    if cg.snap!.ps.emplacedIndex != 0 {
        return
    }

    cg.weaponSelectTime = cg.time
    original = cg.weaponSelect

    i = 0
    while i < WP_NUM_WEAPONS {
        //*SIGH*... Hack to put concussion rifle before rocketlauncher
        if cg.weaponSelect == WP_ROCKET_LAUNCHER {
            cg.weaponSelect = WP_CONCUSSION
        } else if cg.weaponSelect == WP_CONCUSSION {
            cg.weaponSelect = WP_FLECHETTE
        } else if cg.weaponSelect == WP_BRYAR_OLD {
            cg.weaponSelect = WP_DET_PACK
        } else {
            cg.weaponSelect -= 1
        }
        if cg.weaponSelect == -1 {
            cg.weaponSelect = WP_NUM_WEAPONS - 1
        }
        //	if ( cg.weaponSelect == WP_STUN_BATON ) {
        //		continue;		// never cycle to gauntlet
        //	}
        if CG_WeaponSelectable(cg.weaponSelect) {
            break
        }
        i += 1
    }
    if i == WP_NUM_WEAPONS {
        cg.weaponSelect = original
    } else {
        trap_S_MuteSound(cg.snap!.ps.clientNum, CHAN_WEAPON)
    }
}

/**
```
===============
CG_Weapon_f
===============
```
*/
/// Source: oracle/codemp/cgame/cg_weapons.c:1511
func CG_Weapon_f() {
    var num: Int32

    if cg.snap == nil {
        return
    }
    if (cg.snap!.ps.pm_flags & PMF_FOLLOW) != 0 {
        return
    }

    if cg.snap!.ps.emplacedIndex != 0 {
        return
    }

    num = atoi(CG_Argv(1))

    if num < 1 || num > WP_BRYAR_OLD {
        return
    }

    if num == 1 && cg.snap!.ps.weapon == WP_SABER {
        if cg.snap!.ps.weaponTime < 1 {
            trap_SendConsoleCommand("sv_saberswitch\n")
        }
        return
    }

    //rww - hack to make weapon numbers same as single player
    if num > WP_STUN_BATON {
        //num++;
        num += 2 //I suppose this is getting kind of crazy, what with the wp_melee in there too now.
    } else {
        if (cg.snap!.ps.stats[STAT_WEAPONS] & (1 << WP_SABER)) != 0 {
            num = WP_SABER
        } else {
            num = WP_MELEE
        }
    }

    if num > WP_BRYAR_OLD + 1 {
        //other weapons are off limits due to not actually being weapon weapons
        return
    }

    if num >= WP_THERMAL && num <= WP_DET_PACK {
        var weap: Int32
        var i: Int32 = 0

        if cg.snap!.ps.weapon >= WP_THERMAL && cg.snap!.ps.weapon <= WP_DET_PACK {
            // already in cycle range so start with next cycle item
            weap = cg.snap!.ps.weapon + 1
        } else {
            // not in cycle range, so start with thermal detonator
            weap = WP_THERMAL
        }

        // prevent an endless loop
        while i <= 4 {
            if weap > WP_DET_PACK {
                weap = WP_THERMAL
            }

            if CG_WeaponSelectable(weap) {
                num = weap
                break
            }

            weap += 1
            i += 1
        }
    }

    if !CG_WeaponSelectable(num) {
        return
    }

    cg.weaponSelectTime = cg.time

    if !((cg.snap!.ps.stats[STAT_WEAPONS] & (1 << num)) != 0) {
        if num == WP_SABER {
            //don't have saber, try melee on the same slot
            num = WP_MELEE

            if !((cg.snap!.ps.stats[STAT_WEAPONS] & (1 << num)) != 0) {
                return
            }
        } else {
            return // don't have the weapon
        }
    }

    if cg.weaponSelect != num {
        trap_S_MuteSound(cg.snap!.ps.clientNum, CHAN_WEAPON)
    }

    cg.weaponSelect = num
}

//Version of the above which doesn't add +2 to a weapon.  The above can't
//triger WP_MELEE or WP_STUN_BATON.  Derogatory comments go here.
/// Source: oracle/codemp/cgame/cg_weapons.c:1634
func CG_WeaponClean_f() {
    var num: Int32

    if cg.snap == nil {
        return
    }
    if (cg.snap!.ps.pm_flags & PMF_FOLLOW) != 0 {
        return
    }

    if cg.snap!.ps.emplacedIndex != 0 {
        return
    }

    num = atoi(CG_Argv(1))

    if num < 1 || num > WP_BRYAR_OLD {
        return
    }

    if num == 1 && cg.snap!.ps.weapon == WP_SABER {
        if cg.snap!.ps.weaponTime < 1 {
            trap_SendConsoleCommand("sv_saberswitch\n")
        }
        return
    }

    if num == WP_STUN_BATON {
        if (cg.snap!.ps.stats[STAT_WEAPONS] & (1 << WP_SABER)) != 0 {
            num = WP_SABER
        } else {
            num = WP_MELEE
        }
    }

    if num > WP_BRYAR_OLD + 1 {
        //other weapons are off limits due to not actually being weapon weapons
        return
    }

    if num >= WP_THERMAL && num <= WP_DET_PACK {
        var weap: Int32
        var i: Int32 = 0

        if cg.snap!.ps.weapon >= WP_THERMAL && cg.snap!.ps.weapon <= WP_DET_PACK {
            // already in cycle range so start with next cycle item
            weap = cg.snap!.ps.weapon + 1
        } else {
            // not in cycle range, so start with thermal detonator
            weap = WP_THERMAL
        }

        // prevent an endless loop
        while i <= 4 {
            if weap > WP_DET_PACK {
                weap = WP_THERMAL
            }

            if CG_WeaponSelectable(weap) {
                num = weap
                break
            }

            weap += 1
            i += 1
        }
    }

    if !CG_WeaponSelectable(num) {
        return
    }

    cg.weaponSelectTime = cg.time

    if !((cg.snap!.ps.stats[STAT_WEAPONS] & (1 << num)) != 0) {
        if num == WP_SABER {
            //don't have saber, try melee on the same slot
            num = WP_MELEE

            if !((cg.snap!.ps.stats[STAT_WEAPONS] & (1 << num)) != 0) {
                return
            }
        } else {
            return // don't have the weapon
        }
    }

    if cg.weaponSelect != num {
        trap_S_MuteSound(cg.snap!.ps.clientNum, CHAN_WEAPON)
    }

    cg.weaponSelect = num
}

/**
```
===================
CG_OutOfAmmoChange

The current weapon has just run out of ammo
===================
```
*/
/// Source: oracle/codemp/cgame/cg_weapons.c:1756
func CG_OutOfAmmoChange(_ oldWeapon: Int32) {
    var i: Int32

    cg.weaponSelectTime = cg.time

    i = WP_BRYAR_OLD
    while i > 0 {
        if CG_WeaponSelectable(i) {
            /*
            if ( 1 == cg_autoswitch.integer &&
            ( i == WP_TRIP_MINE || i == WP_DET_PACK || i == WP_THERMAL || i == WP_ROCKET_LAUNCHER) ) // safe weapon switch
            */
            //rww - Don't we want to make sure i != one of these if autoswitch is 1 (safe)?
            if cg_autoswitch.integer != 1 || (i != WP_TRIP_MINE && i != WP_DET_PACK && i != WP_THERMAL && i != WP_ROCKET_LAUNCHER) {
                if i != oldWeapon {
                    //don't even do anything if we're just selecting the weapon we already have/had
                    cg.weaponSelect = i
                    break
                }
            }
        }
        i -= 1
    }

    trap_S_MuteSound(cg.snap!.ps.clientNum, CHAN_WEAPON)
}

/// Source: oracle/codemp/cgame/cg_weapons.c:1795
func CG_GetClientWeaponMuzzleBoltPoint(_ clIndex: Int32, _ to: inout JKAShared.vec3_t) {
    var cent: Centity?
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = MdxaBone.scratch { boltMatrix -> Bool in

        if clIndex < 0 || clIndex >= MAX_CLIENTS {
            return true
        }

        cent = cg_entities[clIndex]

        if cent == nil || cent!.ghoul2 == nil || !trap_G2_HaveWeGhoul2Models(cent!.ghoul2) || !trap_G2API_HasGhoul2ModelOnIndex((cent!.ghoul2), 1) {
            return true
        }

        trap_G2API_GetBoltMatrix(cent!.ghoul2, 1, 0, boltMatrix, cent!.turAngles, cent!.lerpOrigin, cg.time, cgs.gameModels, &cent!.modelScale)
        BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &to)
        return false
    }
    if earlyOut {
        return
    }
}

/**
```
================
CG_FireWeapon

Caused by an EV_FIRE_WEAPON event
================
```
*/
/// Source: oracle/codemp/cgame/cg_weapons.c:1824
func CG_FireWeapon(_ cent: Centity, _ altFire: Bool) {
    var ent: EntityState?
    var c: Int32
    var weap: WeaponInfo?

    ent = cent.currentState
    if ent!.weapon == WP_NONE {
        return
    }
    if ent!.weapon >= WP_NUM_WEAPONS {
        CG_Error("CG_FireWeapon: ent->weapon >= WP_NUM_WEAPONS")
        return
    }
    weap = cg_weapons[ent!.weapon]

    // mark the entity as muzzle flashing, so when it is added it will
    // append the flash to the weapon model
    cent.muzzleFlashTime = cg.time

    if cg.predictedPlayerState.clientNum == cent.currentState.number {
        if (ent!.weapon == WP_BRYAR_PISTOL && altFire) || (ent!.weapon == WP_BRYAR_OLD && altFire) || (ent!.weapon == WP_BOWCASTER && !altFire) || (ent!.weapon == WP_DEMP2 && altFire) {
            var val: Float = (cg.time - cent.currentState.constantLight) * 0.001

            if val > 3 {
                val = 3
            }
            if Double(val) < 0.2 {
                val = 0.2
            }

            val *= 2

            CGCam_Shake(val, 250)
        } else if ent!.weapon == WP_ROCKET_LAUNCHER || (ent!.weapon == WP_REPEATER && altFire) || ent!.weapon == WP_FLECHETTE || (ent!.weapon == WP_CONCUSSION && !altFire) {
            if ent!.weapon == WP_CONCUSSION {
                if !cg.renderingThirdPerson {
                    //kick the view back
                    cg.kick_angles[PITCH] = flrand(-10, -15)
                    cg.kick_time = cg.time
                }
            } else if ent!.weapon == WP_ROCKET_LAUNCHER {
                CGCam_Shake(flrand(2, 3), 350)
            } else if ent!.weapon == WP_REPEATER {
                CGCam_Shake(flrand(2, 3), 350)
            } else if ent!.weapon == WP_FLECHETTE {
                if altFire {
                    CGCam_Shake(flrand(2, 3), 350)
                } else {
                    CGCam_Shake(1.5, 250)
                }
            }
        }
    }
    // lightning gun only does this this on initial press
    if ent!.weapon == WP_DEMP2 {
        if cent.pe.lightningFiring != 0 {
            return
        }
    }

    // play quad sound if needed
    if (cent.currentState.powerups & (1 << PW_QUAD)) != 0 {
        //trap_S_StartSound (NULL, cent->currentState.number, CHAN_ITEM, cgs.media.quadSound );
    }


    // play a sound
    if altFire {
        // play a sound
        c = 0
        while c < 4 {
            if weap!.altFlashSound[c] == 0 {
                break
            }
            c += 1
        }
        if c > 0 {
            // The SDK also declares `rand`, so the call names the bg module.
            c = JKAMP_BG.rand() % c
            if weap!.altFlashSound[c] != 0 {
                trap_S_StartSound(nil, ent!.number, CHAN_WEAPON, weap!.altFlashSound[c])
            }
        }
        //		if ( weap->altFlashSnd )
        //		{
        //			trap_S_StartSound( NULL, ent->number, CHAN_WEAPON, weap->altFlashSnd );
        //		}
    } else {
        // play a sound
        c = 0
        while c < 4 {
            if weap!.flashSound[c] == 0 {
                break
            }
            c += 1
        }
        if c > 0 {
            // The SDK also declares `rand`, so the call names the bg module.
            c = JKAMP_BG.rand() % c
            if weap!.flashSound[c] != 0 {
                trap_S_StartSound(nil, ent!.number, CHAN_WEAPON, weap!.flashSound[c])
            }
        }
    }
}

/// Source: oracle/codemp/cgame/cg_weapons.c:1951
func CG_VehicleWeaponImpact(_ cent: Centity) -> Bool {
    //see if this is a missile entity that's owned by a vehicle and should do a special, overridden impact effect
    if (cent.currentState.eFlags & EF_JETPACK_ACTIVE) != 0 && cent.currentState.otherEntityNum2 != 0 && g_vehWeaponInfo[cent.currentState.otherEntityNum2].iImpactFX != 0 {
        //missile is from a special vehWeapon
        var normal = vec3_t()
        ByteToDir(cent.currentState.eventParm, &normal)

        trap_FX_PlayEffectID(g_vehWeaponInfo[cent.currentState.otherEntityNum2].iImpactFX, cent.lerpOrigin, normal, -1, -1)
        return true
    }
    return false
}

/**
```
=================
CG_MissileHitWall

Caused by an EV_MISSILE_MISS event, or directly by local bullet tracing
=================
```
*/
/// Source: oracle/codemp/cgame/cg_weapons.c:1973
func CG_MissileHitWall(_ weapon: Int32, _ clientNum: Int32, _ origin: JKAShared.vec3_t, _ dir: JKAShared.vec3_t, _ soundType: impactSound_t, _ altFire: Bool, _ charge: Int32) {
    var parm: Int32
    var up = vec3_t(0, 0, 1)

    switch weapon {
    case WP_BRYAR_PISTOL:
        if altFire {
            parm = charge
            FX_BryarAltHitWall(origin, dir, parm)
        } else {
            FX_BryarHitWall(origin, dir)
        }

    case WP_CONCUSSION:
        FX_ConcussionHitWall(origin, dir)

    case WP_BRYAR_OLD:
        if altFire {
            parm = charge
            FX_BryarAltHitWall(origin, dir, parm)
        } else {
            FX_BryarHitWall(origin, dir)
        }

    case WP_TURRET:
        FX_TurretHitWall(origin, dir)

    case WP_BLASTER:
        FX_BlasterWeaponHitWall(origin, dir)

    case WP_DISRUPTOR:
        FX_DisruptorAltMiss(origin, dir)

    case WP_BOWCASTER:
        FX_BowcasterHitWall(origin, dir)

    case WP_REPEATER:
        if altFire {
            FX_RepeaterAltHitWall(origin, dir)
        } else {
            FX_RepeaterHitWall(origin, dir)
        }

    case WP_DEMP2:
        if altFire {
            trap_FX_PlayEffectID(cgs.effects.mAltDetonate, origin, dir, -1, -1)
        } else {
            FX_DEMP2_HitWall(origin, dir)
        }

    case WP_FLECHETTE:
        /*if (altFire)
        {
        CG_SurfaceExplosion(origin, dir, 20.0f, 12.0f, qtrue);
        }
        else
        */
        if !altFire {
            FX_FlechetteWeaponHitWall(origin, dir)
        }

    case WP_ROCKET_LAUNCHER:
        FX_RocketHitWall(origin, dir)

    case WP_THERMAL:
        trap_FX_PlayEffectID(cgs.effects.thermalExplosionEffect, origin, dir, -1, -1)
        trap_FX_PlayEffectID(cgs.effects.thermalShockwaveEffect, origin, up, -1, -1)

    case WP_EMPLACED_GUN:
        FX_BlasterWeaponHitWall(origin, dir)

    default:
        break
    }
}

/**
```
=================
CG_MissileHitPlayer
=================
```
*/
/// Source: oracle/codemp/cgame/cg_weapons.c:2081
func CG_MissileHitPlayer(_ weapon: Int32, _ origin: JKAShared.vec3_t, _ dir: JKAShared.vec3_t, _ entityNum: Int32, _ altFire: Bool) {
    let humanoid: Bool = true
    var up = vec3_t(0, 0, 1)

    /*
    // NOTENOTE Non-portable code from single player
    if ( cent->gent )
    {
    other = &g_entities[cent->gent->s.otherEntityNum];

    if ( other->client && other->client->playerTeam == TEAM_BOTS )
    {
    humanoid = qfalse;
    }
    }
    */

    // NOTENOTE No bleeding in this game
    //	CG_Bleed( origin, entityNum );

    // some weapons will make an explosion with the blood, while
    // others will just make the blood
    switch weapon {
    case WP_BRYAR_PISTOL:
        if altFire {
            FX_BryarAltHitPlayer(origin, dir, humanoid)
        } else {
            FX_BryarHitPlayer(origin, dir, humanoid)
        }

    case WP_CONCUSSION:
        FX_ConcussionHitPlayer(origin, dir, humanoid)

    case WP_BRYAR_OLD:
        if altFire {
            FX_BryarAltHitPlayer(origin, dir, humanoid)
        } else {
            FX_BryarHitPlayer(origin, dir, humanoid)
        }

    case WP_TURRET:
        FX_TurretHitPlayer(origin, dir, humanoid)

    case WP_BLASTER:
        FX_BlasterWeaponHitPlayer(origin, dir, humanoid)

    case WP_DISRUPTOR:
        FX_DisruptorAltHit(origin, dir)

    case WP_BOWCASTER:
        FX_BowcasterHitPlayer(origin, dir, humanoid)

    case WP_REPEATER:
        if altFire {
            FX_RepeaterAltHitPlayer(origin, dir, humanoid)
        } else {
            FX_RepeaterHitPlayer(origin, dir, humanoid)
        }

    case WP_DEMP2:
        // Do a full body effect here for some more feedback
        // NOTENOTE The chaining of the demp2 is not yet implemented.
        /*
        if ( other )
        {
        other->s.powerups |= ( 1 << PW_DISINT_1 );
        other->client->ps.powerups[PW_DISINT_1] = cg.time + 650;
        }
        */
        if altFire {
            trap_FX_PlayEffectID(cgs.effects.mAltDetonate, origin, dir, -1, -1)
        } else {
            FX_DEMP2_HitPlayer(origin, dir, humanoid)
        }

    case WP_FLECHETTE:
        FX_FlechetteWeaponHitPlayer(origin, dir, humanoid)

    case WP_ROCKET_LAUNCHER:
        FX_RocketHitPlayer(origin, dir, humanoid)

    case WP_THERMAL:
        trap_FX_PlayEffectID(cgs.effects.thermalExplosionEffect, origin, dir, -1, -1)
        trap_FX_PlayEffectID(cgs.effects.thermalShockwaveEffect, origin, up, -1, -1)

    case WP_EMPLACED_GUN:
        //FIXME: Its own effect?
        FX_BlasterWeaponHitPlayer(origin, dir, humanoid)

    default:
        break
    }
}

/**
```
======================
CG_CalcMuzzlePoint
======================
```
*/
/// Source: oracle/codemp/cgame/cg_weapons.c:2215
func CG_CalcMuzzlePoint(_ entityNum: Int32, _ muzzle: inout JKAShared.vec3_t) -> Bool {
    var forward = vec3_t()
    var right = vec3_t()
    var gunpoint = vec3_t()
    var cent: Centity?
    let anim: Int32

    if entityNum == cg.snap!.ps.clientNum {
        //I'm not exactly sure why we'd be rendering someone else's crosshair, but hey.
        let weapontype: Int32 = cg.snap!.ps.weapon
        var weaponMuzzle = vec3_t()
        let pEnt: Centity? = cg_entities[cg.predictedPlayerState.clientNum]

        weaponMuzzle = WP_MuzzlePoint[weapontype]

        if weapontype == WP_DISRUPTOR || weapontype == WP_STUN_BATON || weapontype == WP_MELEE || weapontype == WP_SABER {
            weaponMuzzle = vec3_t()
        }

        if cg.renderingThirdPerson {
            gunpoint = pEnt!.lerpOrigin
            // Raven passes NULL for the `up` output.
            var scratchUp = vec3_t()
            AngleVectors(pEnt!.lerpAngles, &forward, &right, &scratchUp)
        } else {
            gunpoint = cg.refdef.vieworg
            // Raven passes NULL for the `up` output.
            var scratchUp2 = vec3_t()
            AngleVectors(cg.refdef.viewangles, &forward, &right, &scratchUp2)
        }

        if weapontype == WP_EMPLACED_GUN && cg.snap!.ps.emplacedIndex != 0 {
            let gunEnt: Centity? = cg_entities[cg.snap!.ps.emplacedIndex]

            if gunEnt != nil {
                var pitchConstraint = vec3_t()

                gunpoint = gunEnt!.lerpOrigin
                gunpoint[2] += 46

                if cg.renderingThirdPerson {
                    pitchConstraint = pEnt!.lerpAngles
                } else {
                    pitchConstraint = cg.refdef.viewangles
                }

                if pitchConstraint[PITCH] > 40 {
                    pitchConstraint[PITCH] = 40
                }
                // Raven passes NULL for the `up` output.
                var scratchUp3 = vec3_t()
                AngleVectors(pitchConstraint, &forward, &right, &scratchUp3)
            }
        }

        muzzle = gunpoint

        _VectorMA(muzzle, weaponMuzzle[0], forward, &muzzle)
        _VectorMA(muzzle, weaponMuzzle[1], right, &muzzle)

        if weapontype == WP_EMPLACED_GUN && cg.snap!.ps.emplacedIndex != 0 {
            //Do nothing
        } else if cg.renderingThirdPerson {
            muzzle[2] += cg.snap!.ps.viewheight + weaponMuzzle[2]
        } else {
            muzzle[2] += weaponMuzzle[2]
        }

        return true
    }

    cent = cg_entities[entityNum]
    if !cent!.currentValid {
        return false
    }

    muzzle = cent!.currentState.pos.trBase

    // Raven passes NULL for the `right` and `up` outputs.
    var scratchRight = vec3_t()
    var scratchUp4 = vec3_t()
    AngleVectors(cent!.currentState.apos.trBase, &forward, &scratchRight, &scratchUp4)
    anim = cent!.currentState.legsAnim
    if anim == BOTH_CROUCH1WALK || anim == BOTH_CROUCH1IDLE {
        muzzle[2] += CROUCH_VIEWHEIGHT
    } else {
        muzzle[2] += DEFAULT_VIEWHEIGHT
    }

    _VectorMA(muzzle, 14, forward, &muzzle)

    return true
}

/// Source: oracle/codemp/cgame/cg_weapons.c:2324
func CG_InitG2Weapons() {
    var i: Int32 = 0
    var item: Gitem?
    // Port-note: Raven's `memset(g2WeaponInstances, 0, sizeof(g2WeaponInstances))` runs over bytes that are not one record with a view.
    // Raven wrote: memset(g2WeaponInstances, 0, sizeof(g2WeaponInstances))
    portMissing("CG_InitG2Weapons", source: "oracle/codemp/cgame/cg_weapons.c:2324")
    // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '+' cannot be applied to operands of type 'Slots<Gitem>' and 'Int'".
    // Raven wrote: item = bg_itemlist + 1
    portMissing("CG_InitG2Weapons", source: "oracle/codemp/cgame/cg_weapons.c:2324")
    while item!.classname != nil {
        if item!.giType == IT_WEAPON {
            // initialise model
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'g2WeaponInstances' in scope".
            // Raven wrote: trap_G2API_InitGhoul2Model(&g2WeaponInstances[/*i*/item->giTag], item->world_model[0], 0, 0, 0, 0, 0)
            portMissing("CG_InitG2Weapons", source: "oracle/codemp/cgame/cg_weapons.c:2324")
            //			trap_G2API_InitGhoul2Model(&g2WeaponInstances[i], item->world_model[0],G_ModelIndex( item->world_model[0] ) , 0, 0, 0, 0);
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'g2WeaponInstances' in scope".
            // Raven wrote: if (g2WeaponInstances[/*i*/item->giTag]) { // indicate we will be bolted to model 0 (ie the player) on bolt 0 (always the right hand) when we get copied trap_G2API_SetBoltInfo(g2WeaponInstances[/*i*/item->giTag], 0, 0); // now set up the gun bolt on it if (item->giTag == WP_SABER) { trap_G2API_AddBolt(g2WeaponInstances[/*i*/item->giTag], 0, "*blade1"); } else { trap_G2API_AddBolt(g2WeaponInstances[/*i*/item->giTag], 0, "*flash"); } i++; }
            portMissing("CG_InitG2Weapons", source: "oracle/codemp/cgame/cg_weapons.c:2324")
            if i == MAX_WEAPONS {
                break
            }
        }
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Gitem?' to expected argument type 'Int'".
        // Raven wrote: item++
        portMissing("CG_InitG2Weapons", source: "oracle/codemp/cgame/cg_weapons.c:2324")
    }
}

// clean out any g2 models we instanciated for copying purposes
/// Source: oracle/codemp/cgame/cg_weapons.c:2364
func CG_ShutDownG2Weapons() {
    var i: Int32
    i = 0
    while i < MAX_WEAPONS {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'g2WeaponInstances' in scope".
        // Raven wrote: trap_G2API_CleanGhoul2Models(&g2WeaponInstances[i])
        portMissing("CG_ShutDownG2Weapons", source: "oracle/codemp/cgame/cg_weapons.c:2364")
        i += 1
    }
}

/// Source: oracle/codemp/cgame/cg_weapons.c:2373
// TODO: Port signature
// Raven wrote: void *CG_G2WeaponInstance(centity_t *cent, int weapon)
// No table row for the return `void *`.
func CG_G2WeaponInstance(_ cent: Centity, _ weapon: Int32) -> OpaquePointer? {
    // TODO: Port CG_G2WeaponInstance
    portMissing("CG_G2WeaponInstance", source: "oracle/codemp/cgame/cg_weapons.c:2373")
}

// what ghoul2 model do we want to copy ?
/// Source: oracle/codemp/cgame/cg_weapons.c:2414
func CG_CopyG2WeaponInstance(_ cent: Centity, _ weaponNum: Int32, _ toGhoul2: OpaquePointer?) {
    // Raven assigns his own `toGhoul2` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var toGhoul2 = toGhoul2
    //rww - the -1 is because there is no "weapon" for WP_NONE
    // Port-note: The draft of this statement did not compile, and the compiler wrote "argument passed to call that takes no arguments".
    // Raven wrote: if (CG_G2WeaponInstance(cent, weaponNum/*-1*/)) { if (weaponNum == WP_SABER) { clientInfo_t *ci = NULL; if (cent->currentState.eType == ET_NPC) { ci = cent->npcClient; } else { ci = &cgs.clientinfo[cent->currentState.number]; } if (!ci) { trap_G2API_CopySpecificGhoul2Model(CG_G2WeaponInstance(cent, weaponNum/*-1*/), 0, toGhoul2, 1); } else { //Try both the left hand saber and the right hand saber int i = 0; while (i < MAX_SABERS) { if (ci->saber[i].model[0] && ci->ghoul2Weapons[i]) { trap_G2API_CopySpecificGhoul2Model(ci->ghoul2Weapons[i], 0, toGhoul2, i+1); } else if (ci->ghoul2Weapons[i]) { //if the second saber has been removed, then be sure to remove it and free the instance. qboolean g2HasSecondSaber = trap_G2API_HasGhoul2ModelOnIndex(&(toGhoul2), 2); if (g2HasSecondSaber) { //remove it now since we're switching away from sabers trap_G2API_RemoveGhoul2Model(&(toGhoul2), 2); } trap_G2API_CleanGhoul2Models(&ci->ghoul2Weapons[i]); } i++; } } } else { qboolean g2HasSecondSaber = trap_G2API_HasGhoul2ModelOnIndex(&(toGhoul2), 2); if (g2HasSecondSaber) { //remove it now since we're switching away from sabers trap_G2API_RemoveGhoul2Model(&(toGhoul2), 2); } if (weaponNum == WP_EMPLACED_GUN) { //a bit of a hack to remove gun model when using an emplaced weap if (trap_G2API_HasGhoul2ModelOnIndex(&(toGhoul2), 1)) { trap_G2API_RemoveGhoul2Model(&(toGhoul2), 1); } } else if (weaponNum == WP_MELEE) { //don't want a weapon on the model for this one if (trap_G2API_HasGhoul2ModelOnIndex(&(toGhoul2), 1)) { trap_G2API_RemoveGhoul2Model(&(toGhoul2), 1); } } else { trap_G2API_CopySpecificGhoul2Model(CG_G2WeaponInstance(cent, weaponNum/*-1*/), 0, toGhoul2, 1); } } }
    portMissing("CG_CopyG2WeaponInstance", source: "oracle/codemp/cgame/cg_weapons.c:2414")
}

/// Source: oracle/codemp/cgame/cg_weapons.c:2494
func CG_CheckPlayerG2Weapons(_ ps: JKAMP.PlayerState, _ cent: Centity) {
    if (ps.pm_flags & PMF_FOLLOW) != 0 {
        return
    }

    if cent.currentState.eType == ET_NPC {
        return
    }

    // should we change the gun model on this player?
    if cent.currentState.saberInFlight {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "argument passed to call that takes no arguments".
        // Raven wrote: cent->ghoul2weapon = CG_G2WeaponInstance(cent, WP_SABER)
        portMissing("CG_CheckPlayerG2Weapons", source: "oracle/codemp/cgame/cg_weapons.c:2494")
    }

    if (cent.currentState.eFlags & EF_DEAD) != 0 {
        //no updating weapons when dead
        cent.ghoul2weapon = nil
        return
    }

    if cent.torsoBolt != 0 {
        //got our limb cut off, no updating weapons until it's restored
        cent.ghoul2weapon = nil
        return
    }

    if cgs.clientinfo[ps.clientNum].team == TEAM_SPECTATOR || ps.persistant[PERS_TEAM] == TEAM_SPECTATOR {
        cg_entities[ps.clientNum].ghoul2weapon = nil
        cent.ghoul2weapon = cg_entities[ps.clientNum].ghoul2weapon
        cg_entities[ps.clientNum].weapon = 0
        cent.weapon = cg_entities[ps.clientNum].weapon
        return
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "argument passed to call that takes no arguments".
    // Raven wrote: if (cent->ghoul2 && cent->ghoul2weapon != CG_G2WeaponInstance(cent, ps->weapon) && ps->clientNum == cent->currentState.number) //don't want spectator mode forcing one client's weapon instance over another's { CG_CopyG2WeaponInstance(cent, ps->weapon, cent->ghoul2); cent->ghoul2weapon = CG_G2WeaponInstance(cent, ps->weapon); if (cent->weapon == WP_SABER && cent->weapon != ps->weapon && !ps->saberHolstered) { //switching away from the saber //trap_S_StartSound(cent->lerpOrigin, cent->currentState.number, CHAN_AUTO, trap_S_RegisterSound( "sound/weapons/saber/saberoffquick.wav" )); if (cgs.clientinfo[ps->clientNum].saber[0].soundOff && !ps->saberHolstered) { trap_S_StartSound(cent->lerpOrigin, cent->currentState.number, CHAN_AUTO, cgs.clientinfo[ps->clientNum].saber[0].soundOff); } if (cgs.clientinfo[ps->clientNum].saber[1].soundOff && cgs.clientinfo[ps->clientNum].saber[1].model[0] && !ps->saberHolstered) { trap_S_StartSound(cent->lerpOrigin, cent->currentState.number, CHAN_AUTO, cgs.clientinfo[ps->clientNum].saber[1].soundOff); } } else if (ps->weapon == WP_SABER && cent->weapon != ps->weapon && !cent->saberWasInFlight) { //switching to the saber //trap_S_StartSound(cent->lerpOrigin, cent->currentState.number, CHAN_AUTO, trap_S_RegisterSound( "sound/weapons/saber/saberon.wav" )); if (cgs.clientinfo[ps->clientNum].saber[0].soundOn) { trap_S_StartSound(cent->lerpOrigin, cent->currentState.number, CHAN_AUTO, cgs.clientinfo[ps->clientNum].saber[0].soundOn); } if (cgs.clientinfo[ps->clientNum].saber[1].soundOn) { trap_S_StartSound(cent->lerpOrigin, cent->currentState.number, CHAN_AUTO, cgs.clientinfo[ps->clientNum].saber[1].soundOn); } BG_SI_SetDesiredLength(&cgs.clientinfo[ps->clientNum].saber[0], 0, -1); BG_SI_SetDesiredLength(&cgs.clientinfo[ps->clientNum].saber[1], 0, -1); } cent->weapon = ps->weapon; }
    portMissing("CG_CheckPlayerG2Weapons", source: "oracle/codemp/cgame/cg_weapons.c:2494")
}
