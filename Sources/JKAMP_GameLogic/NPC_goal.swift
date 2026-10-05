import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_goal.c:10
func SetGoal(_ goal: Entity?, _ rating: Float) {
    NPCInfo!.goalEntity = goal
    //	NPCInfo->goalEntityNeed = rating;
    NPCInfo!.goalTime = level.time
    //	NAV_ClearLastRoute(NPC);
    if goal != nil {
        //		Debug_NPCPrintf( NPC, debugNPCAI, DEBUG_LEVEL_INFO, "NPC_SetGoal: %s @ %s (%f)\n", goal->classname, vtos( goal->currentOrigin), rating );
    } else {
        //		Debug_NPCPrintf( NPC, debugNPCAI, DEBUG_LEVEL_INFO, "NPC_SetGoal: NONE\n" );
    }
}

/// Source: oracle/codemp/game/NPC_goal.c:31
func NPC_SetGoal(_ goal: Entity, _ rating: Float) {
    if goal == NPCInfo!.goalEntity {
        return
    }


    if goal.client != nil {
        //		Debug_NPCPrintf( NPC, debugNPCAI, DEBUG_LEVEL_ERROR, "NPC_SetGoal: goal is a client\n" );
        return
    }

    if NPCInfo!.goalEntity != nil {
        //		Debug_NPCPrintf( NPC, debugNPCAI, DEBUG_LEVEL_INFO, "NPC_SetGoal: push %s\n", NPCInfo->goalEntity->classname );
        NPCInfo!.lastGoalEntity = NPCInfo!.goalEntity
        //		NPCInfo->lastGoalEntityNeed = NPCInfo->goalEntityNeed;
    }

    SetGoal(goal, rating)
}

/// Source: oracle/codemp/game/NPC_goal.c:65
func NPC_ClearGoal() {
    var goal: Entity?

    if NPCInfo!.lastGoalEntity == nil {
        SetGoal(nil, 0.0)
        return
    }

    goal = NPCInfo!.lastGoalEntity
    NPCInfo!.lastGoalEntity = nil
    //	NAV_ClearLastRoute(NPC);
    if goal!.inuse && !((goal!.s.eFlags & EF_NODRAW) != 0) {
        //		Debug_NPCPrintf( NPC, debugNPCAI, DEBUG_LEVEL_INFO, "NPC_ClearGoal: pop %s\n", goal->classname );
        SetGoal(goal, 0) //, NPCInfo->lastGoalEntityNeed
        return
    }

    SetGoal(nil, 0.0)
}

/// Source: oracle/codemp/game/NPC_goal.c:94
func G_BoundsOverlap(_ mins1: JKAShared.vec3_t, _ maxs1: JKAShared.vec3_t, _ mins2: JKAShared.vec3_t, _ maxs2: JKAShared.vec3_t) -> Bool {
    //NOTE: flush up against counts as overlapping
    if mins1[0] > maxs2[0] {
        return false
    }

    if mins1[1] > maxs2[1] {
        return false
    }

    if mins1[2] > maxs2[2] {
        return false
    }

    if maxs1[0] < mins2[0] {
        return false
    }

    if maxs1[1] < mins2[1] {
        return false
    }

    if maxs1[2] < mins2[2] {
        return false
    }

    return true
}

/// Source: oracle/codemp/game/NPC_goal.c:117
func NPC_ReachedGoal() {
    //	Debug_NPCPrintf( NPC, debugNPCAI, DEBUG_LEVEL_INFO, "UpdateGoal: reached goal entity\n" );
    NPC_ClearGoal()
    NPCInfo!.goalTime = level.time

    //MCG - Begin
    NPCInfo!.aiFlags &= ~NPCAI_MOVING
    ucmd.forwardmove = 0
    //Return that the goal was reached
    trap_ICARUS_TaskIDComplete(NPC!, TID_MOVE_NAV)
    //MCG - End
}

/**
```
ReachedGoal

id removed checks against waypoints and is now checking surfaces
```
*/
//qboolean NAV_HitNavGoal( vec3_t point, vec3_t mins, vec3_t maxs, gentity_t *goal, qboolean flying );
/// Source: oracle/codemp/game/NPC_goal.c:136
func ReachedGoal(_ goal: Entity) -> Bool {
    //FIXME: For script waypoints, need a special check
    /*
    int		goalWpNum;
    vec3_t	vec;
    //vec3_t	angles;
    float	delta;

    if ( goal->flags & FL_NAVGOAL )
    {//waypoint_navgoal
    return NAV_HitNavGoal( NPC->currentOrigin, NPC->mins, NPC->maxs, goal, FlyingCreature( NPC ) );
    }

    if ( goal == NPCInfo->tempGoal && !(goal->flags & FL_NAVGOAL))
    {//MUST touch waypoints, even if moving to it
    //This is odd, it just checks to see if they are on the same
    //surface and the tempGoal in in the FOV - does NOT check distance!
    // are we on same surface?

    //FIXME: NPC->waypoint reset every frame, need to find it first
    //Should we do that here?  (Still will do it only once per frame)
    if ( NPC->waypoint >= 0 && NPC->waypoint < num_waypoints )
    {
    goalWpNum = NAV_FindWaypointAt ( goal->currentOrigin );
    if ( NPC->waypoint != goalWpNum )
    {
    return qfalse;
    }
    }

    VectorSubtract ( NPCInfo->tempGoal->currentOrigin, NPC->currentOrigin, vec);
    //Who cares if it's in our FOV?!
    / *
    // is it in our FOV
    vectoangles ( vec, angles );
    delta = AngleDelta ( NPC->client->ps.viewangles[YAW], angles[YAW] );
    if ( fabs ( delta ) > NPCInfo->stats.hfov )
    {
    return qfalse;
    }
    */

    /*
    //If in the same waypoint as tempGoal, we're there, right?
    if ( goal->waypoint >= 0 && goal->waypoint < num_waypoints )
    {
    if ( NPC->waypoint == goal->waypoint )
    {
    return qtrue;
    }
    }
    */

    /*
    if ( VectorLengthSquared( vec ) < (64*64) )
    {//Close enough
    return qtrue;
    }

    return qfalse;
    }
    */
    if (NPCInfo!.aiFlags & NPCAI_TOUCHED_GOAL) != 0 {
        NPCInfo!.aiFlags &= ~NPCAI_TOUCHED_GOAL
        return true
    }
    /*
    if ( goal->s.eFlags & EF_NODRAW )
    {
    goalWpNum = NAV_FindWaypointAt( goal->currentOrigin );
    if ( NPC->waypoint == goalWpNum )
    {
    return qtrue;
    }
    return qfalse;
    }

    if(goal->client && goal->health <= 0)
    {//trying to get to dead guy
    goalWpNum = NAV_FindWaypointAt( goal->currentOrigin );
    if ( NPC->waypoint == goalWpNum )
    {
    VectorSubtract(NPC->currentOrigin, goal->currentOrigin, vec);
    vec[2] = 0;
    delta = VectorLengthSquared(vec);
    if(delta <= 800)
    {//with 20-30 of other guy's origin
    return qtrue;
    }
    }
    }
    */
    return NAV_HitNavGoal(NPC!.r.currentOrigin, NPC!.r.mins, NPC!.r.maxs, goal.r.currentOrigin, NPCInfo!.goalRadius, FlyingCreature(NPC!))
}

/// Source: oracle/codemp/game/NPC_goal.c:243
func UpdateGoal() -> Entity? {
    var goal: Entity?

    if NPCInfo!.goalEntity == nil {
        return nil
    }

    if !NPCInfo!.goalEntity!.inuse {
        //Somehow freed it, but didn't clear it
        NPC_ClearGoal()
        return nil
    }

    goal = NPCInfo!.goalEntity

    if ReachedGoal(goal!) {
        NPC_ReachedGoal()
        goal = nil //so they don't keep trying to move to it
    }

    return goal
}
