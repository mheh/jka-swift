import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/**
```
================
G_BounceObject

================
```
*/
/// Source: oracle/codemp/game/g_object.c:14
func G_BounceObject(_ ent: Entity, _ trace: JKAMP.Trace) {
    var velocity = vec3_t()
    let dot: Float
    var bounceFactor: Float
    let hitTime: Int32

    // reflect the velocity on the trace plane
    hitTime = Int32(level.previousTime + (level.time - level.previousTime) * trace.fraction)
    BG_EvaluateTrajectoryDelta(ent.s.pos, hitTime, &velocity)
    dot = _DotProduct(velocity, trace.plane.normal)
    //	bounceFactor = 60/ent->mass;		// NOTENOTE Mass is not yet implemented
    bounceFactor = 1.0
    if bounceFactor > 1.0 {
        bounceFactor = 1.0
    }
    _VectorMA(velocity, -2 * dot * bounceFactor, trace.plane.normal, &ent.s.pos.trDelta)

    //FIXME: customized or material-based impact/bounce sounds
    if (ent.flags & FL_BOUNCE_HALF) != 0 {
        ent.s.pos.trDelta = ent.s.pos.trDelta * 0.5

        // check for stop
        if ((trace.plane.normal[2] > 0.7 && g_gravity.value > 0) || (trace.plane.normal[2] < -0.7 && g_gravity.value < 0)) && ((ent.s.pos.trDelta[2] < 40 && g_gravity.value > 0) || (ent.s.pos.trDelta[2] > -40 && g_gravity.value < 0)) {
            //G_SetOrigin( ent, trace->endpos );
            //ent->nextthink = level.time + 500;
            ent.s.apos.trType = TR_STATIONARY
            ent.s.apos.trBase = ent.r.currentAngles
            ent.r.currentOrigin = trace.endpos
            ent.s.pos.trBase = trace.endpos
            ent.s.pos.trTime = level.time
            return
        }
    }

    // NEW--It would seem that we want to set our trBase to the trace endpos
    //	and set the trTime to the actual time of impact....
    //	FIXME: Should we still consider adding the normal though??
    ent.r.currentOrigin = trace.endpos
    ent.s.pos.trTime = hitTime

    ent.s.pos.trBase = ent.r.currentOrigin
    ent.pos1 = trace.plane.normal //???
}

/// Source: oracle/codemp/game/g_object.c:72
func G_RunObject(_ ent: Entity) {
    var origin = vec3_t()
    var oldOrg = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in
        var traceEnt: Entity? = nil

        //FIXME: floaters need to stop floating up after a while, even if gravity stays negative?
        if ent.s.pos.trType == TR_STATIONARY {
            ent.s.pos.trType = TR_GRAVITY
            ent.s.pos.trBase = ent.r.currentOrigin
            ent.s.pos.trTime = level.previousTime //?necc?
            if g_gravity.value == 0 {
                ent.s.pos.trDelta[2] += 100
            }
        }

        ent.nextthink = level.time + FRAMETIME

        oldOrg = ent.r.currentOrigin
        // get current position
        BG_EvaluateTrajectory(ent.s.pos, level.time, &origin)
        //Get current angles?
        BG_EvaluateTrajectory(ent.s.apos, level.time, &ent.r.currentAngles)

        if VectorCompare(ent.r.currentOrigin, origin) != 0 {
            //error - didn't move at all!
            return true
        }
        // trace a line from the previous position to the current position,
        // ignoring interactions with the missile owner
        trap_Trace(tr, ent.r.currentOrigin, ent.r.mins, ent.r.maxs, origin, ent.parent != nil ? ent.parent!.s.number : ent.s.number, ent.clipmask)

        if tr.startsolid == 0 && tr.allsolid == 0 && tr.fraction != 0 {
            ent.r.currentOrigin = tr.endpos
            trap_LinkEntity(ent)
        } else {
            //if ( tr.startsolid )
            tr.fraction = 0
        }

        G_MoverTouchPushTriggers(ent, &oldOrg)
        /*
        if ( !(ent->s.eFlags & EF_TELEPORT_BIT) && !(ent->svFlags & SVF_NO_TELEPORT) )
        {
        G_MoverTouchTeleportTriggers( ent, oldOrg );
        if ( ent->s.eFlags & EF_TELEPORT_BIT )
        {//was teleported
        return;
        }
        }
        else
        {
        ent->s.eFlags &= ~EF_TELEPORT_BIT;
        }
        */

        if tr.fraction == 1 {
            if g_gravity.value <= 0 {
                if ent.s.apos.trType == TR_STATIONARY {
                    ent.s.apos.trBase = ent.r.currentAngles
                    ent.s.apos.trType = TR_LINEAR
                    ent.s.apos.trDelta[1] = flrand(-300, 300)
                    ent.s.apos.trDelta[0] = flrand(-10, 10)
                    ent.s.apos.trDelta[2] = flrand(-10, 10)
                    ent.s.apos.trTime = level.time
                }
            }
            //friction in zero-G
            if g_gravity.value == 0 {
                var friction: Float = 0.975
                //friction -= ent->mass/1000.0f;
                if friction < 0.1 {
                    friction = 0.1
                }

                ent.s.pos.trDelta = ent.s.pos.trDelta * friction
                ent.s.pos.trBase = ent.r.currentOrigin
                ent.s.pos.trTime = level.time
            }
            return true
        }

        //hit something

        //Do impact damage
        traceEnt = g_entities[tr.entityNum]
        if tr.fraction != 0 || (traceEnt != nil && traceEnt!.takedamage) {
            if VectorCompare(ent.r.currentOrigin, oldOrg) == 0 {
                //moved and impacted
                if (traceEnt != nil && traceEnt!.takedamage) {
                    //hurt someone
                    //				G_Sound( ent, G_SoundIndex( "sound/movers/objects/objectHurt.wav" ) );
                }
                //			G_Sound( ent, G_SoundIndex( "sound/movers/objects/objectHit.wav" ) );
            }

            if ent.s.weapon != WP_SABER {
                DoImpact(ent, traceEnt!, true)
            }
        }

        if (ent.takedamage && ent.health <= 0) {
            //been destroyed by impact
            //chunks?
            //		G_Sound( ent, G_SoundIndex( "sound/movers/objects/objectBreak.wav" ) );
            return true
        }

        //do impact physics
        if ent.s.pos.trType == TR_GRAVITY {
            //FIXME: only do this if no trDelta
            if g_gravity.value <= 0 || tr.plane.normal[2] < 0.7 {
                if (ent.flags & (FL_BOUNCE | FL_BOUNCE_HALF)) != 0 {
                    if tr.fraction <= 0.0 {
                        ent.r.currentOrigin = tr.endpos
                        ent.s.pos.trBase = tr.endpos
                        ent.s.pos.trDelta = vec3_t()
                        ent.s.pos.trTime = level.time
                    } else {
                        G_BounceObject(ent, tr)
                    }
                } else {
                    //slide down?
                    //FIXME: slide off the slope
                }
            } else {
                ent.s.apos.trType = TR_STATIONARY
                pitch_roll_for_slope(ent, tr.plane.normal)
                //ent->r.currentAngles[0] = 0;//FIXME: match to slope
                //ent->r.currentAngles[2] = 0;//FIXME: match to slope
                ent.s.apos.trBase = ent.r.currentAngles
                //okay, we hit the floor, might as well stop or prediction will
                //make us go through the floor!
                //FIXME: this means we can't fall if something is pulled out from under us...
                G_StopObjectMoving(ent)
            }
        } else if ent.s.weapon != WP_SABER {
            ent.s.apos.trType = TR_STATIONARY
            pitch_roll_for_slope(ent, tr.plane.normal)
            //ent->r.currentAngles[0] = 0;//FIXME: match to slope
            //ent->r.currentAngles[2] = 0;//FIXME: match to slope
            ent.s.apos.trBase = ent.r.currentAngles
        }

        //call touch func
        ent.runTouch(g_entities[tr.entityNum], tr)
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/game/g_object.c:244
func G_StopObjectMoving(_ object: Entity) {
    object.s.pos.trType = TR_STATIONARY
    object.s.origin = object.r.currentOrigin
    object.s.pos.trBase = object.r.currentOrigin
    object.s.pos.trDelta = vec3_t()

    /*
    //Stop spinning
    VectorClear( self->s.apos.trDelta );
    vectoangles(trace->plane.normal, self->s.angles);
    VectorCopy(self->s.angles, self->r.currentAngles );
    VectorCopy(self->s.angles, self->s.apos.trBase);
    */
}

/// Source: oracle/codemp/game/g_object.c:260
func G_StartObjectMoving(_ object: Entity, _ dir: inout JKAShared.vec3_t, _ speed: Float, _ trType: JKAShared.trType_t) {
    VectorNormalize(&dir)

    //object->s.eType = ET_GENERAL;
    object.s.pos.trType = trType
    object.s.pos.trBase = object.r.currentOrigin
    object.s.pos.trDelta = dir * speed
    object.s.pos.trTime = level.time

    /*
    //FIXME: incorporate spin?
    vectoangles(dir, object->s.angles);
    VectorCopy(object->s.angles, object->s.apos.trBase);
    VectorSet(object->s.apos.trDelta, 300, 0, 0 );
    object->s.apos.trTime = level.time;
    */

    //FIXME: make these objects go through G_RunObject automatically, like missiles do
    if object.think == nil {
        object.nextthink = level.time + FRAMETIME
        object.think = Think.G_RunObject
    } else {
        //You're responsible for calling RunObject
    }
}
