import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_exphysics.c:16
let MAX_GRAVITY_PULL = 512 as Int32

//Run physics on the object (purely origin-related) using custom epVelocity entity
//state value. Origin smoothing on the client is expected to compensate for choppy
//movement.
/// Source: oracle/codemp/game/g_exphysics.c:21
func G_RunExPhys(_ ent: Entity, _ gravity: Float, _ mass: Float, _ bounce: Float, _ autoKill: Bool, _ g2Bolts: UnsafeMutablePointer<Int32>?, _ numG2Bolts: Int32) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in
        var projectedOrigin = vec3_t()
        var vNorm = vec3_t()
        var ground = vec3_t()
        let velScaling: Float = 0.1
        var vTotal: Float = 0.0


        if gravity != 0 {
            //factor it in before we do anything.
            ground = ent.r.currentOrigin
            ground[2] -= 0.1

            trap_Trace(tr, ent.r.currentOrigin, ent.r.mins, ent.r.maxs, ground, ent.s.number, ent.clipmask)

            if tr.fraction == 1.0 {
                ent.s.groundEntityNum = ENTITYNUM_NONE
            } else {
                ent.s.groundEntityNum = tr.entityNum
            }

            if ent.s.groundEntityNum == ENTITYNUM_NONE {
                ent.epGravFactor += gravity

                if ent.epGravFactor > MAX_GRAVITY_PULL {
                    //cap it off if needed
                    ent.epGravFactor = Float(MAX_GRAVITY_PULL)
                }

                ent.epVelocity[2] -= ent.epGravFactor
            } else {
                //if we're sitting on something then reset the gravity factor.
                ent.epGravFactor = 0
            }
        }

        if ent.epVelocity[0] == 0 && ent.epVelocity[1] == 0 && ent.epVelocity[2] == 0 {
            //nothing to do if we have no velocity even after gravity.
            if ent.touch != nil {
                //call touch if we're in something
                trap_Trace(tr, ent.r.currentOrigin, ent.r.mins, ent.r.maxs, ent.r.currentOrigin, ent.s.number, ent.clipmask)
                if tr.startsolid != 0 || tr.allsolid != 0 {
                    ent.runTouch(g_entities[tr.entityNum], tr)
                }
            }
            return true
        }

        //get the projected origin based on velocity.
        _VectorMA(ent.r.currentOrigin, velScaling, ent.epVelocity, &projectedOrigin)

        ent.epVelocity = ent.epVelocity * (1.0 - mass) //scale it down based on mass

        vNorm = ent.epVelocity
        vTotal = VectorNormalize(&vNorm)

        if vTotal < 1 && ent.s.groundEntityNum != ENTITYNUM_NONE {
            //we've pretty much stopped moving anyway, just clear it out then.
            ent.epVelocity = vec3_t()
            ent.epGravFactor = 0
            trap_LinkEntity(ent)
            return true
        }

        if ent.ghoul2 != nil && g2Bolts != nil {
            //Have we been passed a bolt index array to clip against points on the skeleton?
            var tMins = vec3_t()
            var tMaxs = vec3_t()
            var trajDif = vec3_t()
            var gbmAngles = vec3_t()
            var boneOrg = vec3_t()
            var projectedBoneOrg = vec3_t()
            var collisionRootPos = vec3_t()
            // Raven's record lives to the end of his block, so the block is the closure.
            MdxaBone.scratch { matrix in
                // Raven's record lives to the end of his block, so the block is the closure.
                Trace.scratch { bestCollision in
                    var hasFirstCollision: Bool = false
                    var i: Int32 = 0

                    //Maybe we could use a trap call and get the default radius for the bone specified,
                    //but this will do at least for now.
                    tMins = vec3_t(-3, -3, -3)
                    tMaxs = vec3_t(3, 3, 3)

                    gbmAngles[ROLL] = 0
                    gbmAngles[PITCH] = gbmAngles[ROLL]
                    gbmAngles[YAW] = ent.s.apos.trBase[YAW]

                    //Get the difference relative to the entity origin and projected origin, to add to each bolt position.
                    trajDif = ent.r.currentOrigin - projectedOrigin

                    while i < numG2Bolts {
                        //Get the position of the actual bolt for this frame
                        // Port-note: Raven indexes `g2Bolts[i]` through the `int *` parameter, which crosses as a raw pointer under rule 11. A shape ruling is due.
                        // Raven wrote: trap_G2API_GetBoltMatrix(ent->ghoul2, 0, g2Bolts[i], &matrix, gbmAngles, ent->r.currentOrigin, level.time, NULL, ent->modelScale)
                        portMissing("G_RunExPhys", source: "oracle/codemp/game/g_exphysics.c:21")
                        BG_GiveMeVectorFromMatrix(matrix, ORIGIN, &boneOrg)

                        //Now add the projected positional difference into the result
                        projectedBoneOrg = boneOrg + trajDif

                        trap_Trace(tr, boneOrg, tMins, tMaxs, projectedBoneOrg, ent.s.number, ent.clipmask)

                        if tr.fraction != 1.0 || tr.startsolid != 0 || tr.allsolid != 0 {
                            //we've hit something
                            //Store the "deepest" collision we have
                            if !hasFirstCollision {
                                //don't have one yet so just use this one
                                bestCollision.copy(from: tr)
                                collisionRootPos = boneOrg
                                hasFirstCollision = true
                            } else {
                                if tr.allsolid != 0 && bestCollision.allsolid == 0 {
                                    //If the whole trace is solid then this one is deeper
                                    bestCollision.copy(from: tr)
                                    collisionRootPos = boneOrg
                                } else if tr.startsolid != 0 && bestCollision.startsolid == 0 && bestCollision.allsolid == 0 {
                                    //Next deepest is if it's startsolid
                                    bestCollision.copy(from: tr)
                                    collisionRootPos = boneOrg
                                } else if bestCollision.startsolid == 0 && bestCollision.allsolid == 0 && tr.fraction < bestCollision.fraction {
                                    //and finally, if neither is startsolid/allsolid, but the new one has a smaller fraction, then it's closer to an impact point so we will use it
                                    bestCollision.copy(from: tr)
                                    collisionRootPos = boneOrg
                                }
                            }
                        }

                        i += 1
                    }

                    if hasFirstCollision {
                        //at least one bolt collided
                        //We'll get the offset between the collided bolt and endpos, then trace there
                        //from the origin so that our desired position becomes that point.
                        trajDif = collisionRootPos - bestCollision.endpos

                        projectedOrigin = ent.r.currentOrigin + trajDif
                    }
                }
            }
        }

        //If we didn't collide with any bolts projectedOrigin will still be the original desired
        //projected position so all is well. If we did then projectedOrigin will be modified
        //to provide us with a relative position which does not place the bolt in a solid.
        trap_Trace(tr, ent.r.currentOrigin, ent.r.mins, ent.r.maxs, projectedOrigin, ent.s.number, ent.clipmask)

        if tr.startsolid != 0 || tr.allsolid != 0 {
            //can't go anywhere from here
            if autoKill {
                ent.think = Think.G_FreeEntity
                ent.nextthink = level.time
            }
            return true
        }

        //Go ahead and set it to the trace endpoint regardless of what it hit
        G_SetOrigin(ent, &tr.endpos)
        trap_LinkEntity(ent)

        if tr.fraction == 1.0 {
            //Nothing was in the way.
            return true
        }

        if bounce != 0 {
            vTotal *= bounce //scale it by bounce

            vNorm = tr.plane.normal * vTotal //scale the trace plane normal by the bounce factor

            if vNorm[2] > 0 {
                ent.epGravFactor -= vNorm[2] * (1.0 - mass) //The lighter it is the more gravity will be reduced by bouncing vertically.
                if ent.epGravFactor < 0 {
                    ent.epGravFactor = 0
                }
            }

            //call touch first so we can check velocity upon impact if we want
            if tr.entityNum != ENTITYNUM_NONE && ent.touch != nil {
                //then call the touch function
                ent.runTouch(g_entities[tr.entityNum], tr)
            }

            ent.epVelocity = ent.epVelocity + vNorm //add it into the existing velocity.
        } else {
            //if no bounce, kill when it hits something.
            ent.epVelocity[0] = 0
            ent.epVelocity[1] = 0

            if gravity == 0 {
                ent.epVelocity[2] = 0
            }
        }
        return false
    }
    if earlyOut {
        return
    }
}
