import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

// Raven's game arms of bg_pmove.c, the code under `#ifdef QAGAME` that reads the game's tables.
// The bg body reaches each one through the channel, and installBgChannel points the closure here. Rule 23, R30 and R31.

/// Source: oracle/codemp/game/bg_pmove.c:3684
func PM_CrashLandEffect() {
    var delta: Float
    let ps = pm.ps
    if pm.waterlevel != 0 {
        return
    }
    delta = Q_fabs(pml.previous_velocity[2]) / 10 //VectorLength( pml.previous_velocity );?
    if delta >= 30 {
        var bottom = vec3_t()
        var effectID: Int32 = -1
        let material = (pml.groundTrace.surfaceFlags & MATERIAL_MASK)
        bottom = vec3_t(ps.origin[0], ps.origin[1], ps.origin[2] + pm.mins[2] + 1)
        switch material {
        case MATERIAL_MUD:
            effectID = EFFECT_LANDING_MUD

        case MATERIAL_SAND:
            effectID = EFFECT_LANDING_SAND

        case MATERIAL_DIRT:
            effectID = EFFECT_LANDING_DIRT

        case MATERIAL_SNOW:
            effectID = EFFECT_LANDING_SNOW

        case MATERIAL_GRAVEL:
            effectID = EFFECT_LANDING_GRAVEL

        default:
            break
        }

        if effectID != -1 {
            var groundNormal = pml.groundTrace.plane.normal
            _ = G_PlayEffect(effectID, bottom, groundNormal)
        }
    }
}

/// The game arm of PM_GroundTrace. The bg body tested the client, the vehicle slot, the trace, and the zoom, and hands over the entity it landed on.
/// Source: oracle/codemp/game/bg_pmove.c:4234
func bgLandOnVehicle(_ entityNum: Int32) {
    //check if we landed on a vehicle
    let trEnt = g_entities[entityNum]
    if trEnt.inuse && trEnt.client != nil && trEnt.s.eType == ET_NPC && trEnt.s.NPC_class == CLASS_VEHICLE
        && trEnt.client!.ps.m_iVehicleNum == 0
        && trEnt.m_pVehicle != nil
        && trEnt.m_pVehicle!.m_pVehicleInfo!.type != VH_WALKER
        && trEnt.m_pVehicle!.m_pVehicleInfo!.type != VH_FIGHTER {
        //it's a vehicle alright, let's board it.. if it's not an atst or ship
        if !BG_SaberInSpecial(pm.ps.saberMove)
            && pm.ps.forceHandExtend == HANDEXTEND_NONE
            && pm.ps.weaponTime <= 0 {
            let servEnt = Entity(pm_entSelf!)
            if g_gametype.integer < GT_TEAM
                || trEnt.alliedTeam == 0
                || (trEnt.alliedTeam == servEnt.client!.sess.sessionTeam) {
                //not belonging to a team, or client is on same team
                _ = trEnt.m_pVehicle!.m_pVehicleInfo!.runBoard(trEnt.m_pVehicle, pm_entSelf)
            }
        }
    }
}

/// The game arm of PM_CheckDuck, where the vehicle rider cannot fit and the bg body zeroed the bounds.
/// Source: oracle/codemp/game/bg_pmove.c:4448
func bgSetSolidHack(_ clientNum: Int32) {
    let me = g_entities[clientNum]
    if me.inuse && me.client != nil {
        //yeah, this is a really terrible hack.
        me.client!.solidHack = level.time + 200
    }
}
