import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_AI_Utils.c:9
private let MAX_RADIUS_ENTS = 128 as Int32

/// Source: oracle/codemp/game/NPC_AI_Utils.c:10
let DEFAULT_RADIUS = 45 as Int32

/// Source: oracle/codemp/game/NPC_AI_Utils.c:23
func AI_GetGroupSize(_ origin: JKAShared.vec3_t, _ radius: Int32, _ playerTeam: JKAMP.team_t, _ avoid: Entity) -> Int32 {
    var radiusEnts: [Int32] = [Int32](repeating: 0, count: 128)
    var check: Entity?
    var mins = vec3_t()
    var maxs = vec3_t()
    let numEnts: Int32
    var realCount: Int32 = 0
    var i: Int32
    var j: Int32

    //Setup the bbox to search in
    i = 0
    while i < 3 {
        mins[i] = origin[i] - radius
        maxs[i] = origin[i] + radius
        i += 1
    }

    //Get the number of entities in a given space
    numEnts = trap_EntitiesInBox(mins, maxs, &radiusEnts, MAX_RADIUS_ENTS)

    //Cull this list
    j = 0
    while j < numEnts {
        check = g_entities[radiusEnts[j]]

        //Validate clients
        if check!.client == nil {
            j += 1
            continue
        }

        //Skip the requested avoid ent if present
        if (avoid != nil) && (check == avoid) {
            j += 1
            continue
        }

        //Must be on the same team
        if check!.client!.playerTeam != playerTeam {
            j += 1
            continue
        }

        //Must be alive
        if check!.health <= 0 {
            j += 1
            continue
        }

        realCount += 1
        j += 1
    }

    return realCount
}

/// Source: oracle/codemp/game/NPC_AI_Utils.c:71
func AI_GetGroupSize2(_ ent: Entity, _ radius: Int32) -> Int32 {
    if (ent == nil) || (ent.client == nil) {
        return -1
    }

    return AI_GetGroupSize(ent.r.currentOrigin, radius, ent.client!.playerTeam, ent)
}

/// Source: oracle/codemp/game/NPC_AI_Utils.c:80
func AI_ClosestGroupEntityNumToPoint(_ group: AIGroupInfo, _ point: inout JKAShared.vec3_t) -> Int32 {
    var markerWP: Int32 = WAYPOINT_NONE
    var cost: Int32
    var bestCost: Int32 = Q3_INFINITE
    var closest: Int32 = ENTITYNUM_NONE
    var i: Int32

    if group == nil || group.numGroup <= 0 {
        return ENTITYNUM_NONE
    }

    markerWP = NAV_FindClosestWaypointForPoint(g_entities[group.member[0].number], &point)

    if markerWP == WAYPOINT_NONE {
        return ENTITYNUM_NONE
    }

    i = 0
    while i < group.numGroup {
        cost = trap_Nav_GetPathCost(group.member[i].waypoint, markerWP)
        if cost < bestCost {
            bestCost = cost
            closest = group.member[i].number
        }
        i += 1
    }

    return closest
}

/// Source: oracle/codemp/game/NPC_AI_Utils.c:112
func AI_SetClosestBuddy(_ group: AIGroupInfo) {
    var i: Int32
    var j: Int32
    var dist: Int32
    var bestDist: Int32

    i = 0
    while i < group.numGroup {
        group.member[i].closestBuddy = ENTITYNUM_NONE

        bestDist = Q3_INFINITE
        j = 0
        while j < group.numGroup {
            dist = Int32(DistanceSquared(g_entities[group.member[i].number].r.currentOrigin, g_entities[group.member[j].number].r.currentOrigin))
            if dist < bestDist {
                bestDist = dist
                group.member[i].closestBuddy = group.member[j].number
            }
            j += 1
        }
        i += 1
    }
}

/// Source: oracle/codemp/game/NPC_AI_Utils.c:134
func AI_SortGroupByPathCostToEnemy(_ group: AIGroupInfo) {
    // Raven's array of records lives to the end of his function, so the rest of the body is the closure.
    AIGroupMember.scratch(count: Int(MAX_GROUP_MEMBERS)) { bestMembers in
        var i: Int32
        var j: Int32
        var k: Int32
        var sort: Bool = false

        if group.enemy != nil {
            //FIXME: just use enemy->waypoint?
            group.enemyWP = NAV_FindClosestWaypointForEnt(group.enemy!, WAYPOINT_NONE)
        } else {
            group.enemyWP = WAYPOINT_NONE
        }

        i = 0
        while i < group.numGroup {
            if group.enemyWP == WAYPOINT_NONE {
                //FIXME: just use member->waypoint?
                group.member[i].waypoint = WAYPOINT_NONE
                group.member[i].pathCostToEnemy = Q3_INFINITE
            } else {
                //FIXME: just use member->waypoint?
                group.member[i].waypoint = NAV_FindClosestWaypointForEnt(group.enemy!, WAYPOINT_NONE)
                if group.member[i].waypoint != WAYPOINT_NONE {
                    group.member[i].pathCostToEnemy = trap_Nav_GetPathCost(group.member[i].waypoint, group.enemyWP)
                    //at least one of us has a path, so do sorting
                    sort = true
                } else {
                    group.member[i].pathCostToEnemy = Q3_INFINITE
                }
            }
            i += 1
        }
        //Now sort
        if sort {
            //initialize bestMembers data
            j = 0
            while j < group.numGroup {
                bestMembers[j].number = ENTITYNUM_NONE
                j += 1
            }

            i = 0
            while i < group.numGroup {
                j = 0
                while j < group.numGroup {
                    if bestMembers[j].number != ENTITYNUM_NONE {
                        //slot occupied
                        if group.member[i].pathCostToEnemy < bestMembers[j].pathCostToEnemy {
                            //this guy has a shorter path than the one currenly in this spot, bump him and put myself in here
                            k = group.numGroup
                            while k > j {
                                bestMembers[k].copy(from: bestMembers[k - 1])
                                k += 1
                            }
                            bestMembers[j].copy(from: group.member[i])
                            break
                        }
                    } else {
                        //slot unoccupied, reached end of list, throw self in here
                        bestMembers[j].copy(from: group.member[i])
                        break
                    }
                    j += 1
                }
                i += 1
            }

            //Okay, now bestMembers is a sorted list, just copy it into group->members
            i = 0
            while i < group.numGroup {
                group.member[i].copy(from: bestMembers[i])
                i += 1
            }
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_Utils.c:212
func AI_FindSelfInPreviousGroup(_ `self`: Entity) -> Bool {
    //go through other groups made this frame and see if any of those contain me already
    var i: Int32
    var j: Int32
    i = 0
    while i < MAX_FRAME_GROUPS {
        if level.groups[i].numGroup != 0 {
            //check this one
            j = 0
            while j < level.groups[i].numGroup {
                if level.groups[i].member[j].number == `self`.s.number {
                    `self`.NPC!.group = level.groups[i]
                    return true
                }
                j += 1
            }
        }
        i += 1
    }
    return false
}

/// Source: oracle/codemp/game/NPC_AI_Utils.c:232
func AI_InsertGroupMember(_ group: AIGroupInfo, _ member: Entity) {
    var i: Int32

    //okay, you know what?  Check this damn group and make sure we're not already in here!
    i = 0
    while i < group.numGroup {
        if group.member[i].number == member.s.number {
            //already in here
            break
        }
        i += 1
    }
    if i < group.numGroup {
        //found him in group already
    } else {
        //add him in
        group.member[group.numGroup].number = member.s.number
        group.numGroup += 1
        group.numState[member.NPC!.squadState] += 1
    }
    if group.commander == nil || (member.NPC!.rank > group.commander!.NPC!.rank) {
        //keep track of highest rank
        group.commander = member
    }
    member.NPC!.group = group
}

/// Source: oracle/codemp/game/NPC_AI_Utils.c:259
func AI_TryJoinPreviousGroup(_ `self`: Entity) -> Bool {
    //go through other groups made this frame and see if any of those have the same enemy as me... if so, add me in!
    var i: Int32
    i = 0
    while i < MAX_FRAME_GROUPS {
        if level.groups[i].numGroup != 0 && level.groups[i].numGroup < (MAX_GROUP_MEMBERS - 1) && level.groups[i].enemy == `self`.enemy {
            //has members, not full and has my enemy
            if AI_ValidateGroupMember(level.groups[i], `self`) {
                //I am a valid member for this group
                AI_InsertGroupMember(level.groups[i], `self`)
                return true
            }
        }
        i += 1
    }
    return false
}

/// Source: oracle/codemp/game/NPC_AI_Utils.c:279
func AI_GetNextEmptyGroup(_ `self`: Entity) -> Bool {
    var i: Int32

    if AI_FindSelfInPreviousGroup(`self`) {
        //already in one, no need to make a new one
        return false
    }

    if AI_TryJoinPreviousGroup(`self`) {
        //try to just put us in one that already exists
        return false
    }

    //okay, make a whole new one, then
    i = 0
    while i < MAX_FRAME_GROUPS {
        if level.groups[i].numGroup == 0 {
            //make a new one
            `self`.NPC!.group = level.groups[i]
            return true
        }
        i += 1
    }

    //if ( i >= MAX_FRAME_GROUPS )
    do {
        //WTF?  Out of groups!
        `self`.NPC!.group = nil
        return false
    }
}

/// Source: oracle/codemp/game/NPC_AI_Utils.c:310
func AI_ValidateNoEnemyGroupMember(_ group: AIGroupInfo, _ member: Entity) -> Bool {
    var center = vec3_t()

    if group.commander != nil {
        center = group.commander!.r.currentOrigin
    } else {
        //hmm, just pick the first member
        if group.member[0].number < 0 || group.member[0].number >= ENTITYNUM_WORLD {
            return false
        }
        center = g_entities[group.member[0].number].r.currentOrigin
    }
    //FIXME: maybe it should be based on the center of the mass of the group, not the commander?
    if DistanceSquared(center, member.r.currentOrigin) > 147456 {
        return false
    }
    if !trap_InPVS(member.r.currentOrigin, center) {
        //not within PVS of the group enemy
        return false
    }
    return true
}

/// Source: oracle/codemp/game/NPC_AI_Utils.c:342
func AI_ValidateGroupMember(_ group: AIGroupInfo, _ member: Entity) -> Bool {
    //Validate ents
    if member == nil {
        return false
    }

    //Validate clients
    if member.client == nil {
        return false
    }

    //Validate NPCs
    if member.NPC == nil {
        return false
    }

    //must be aware
    if member.NPC!.confusionTime > level.time {
        return false
    }

    //must be allowed to join groups
    if (member.NPC!.scriptFlags & SCF_NO_GROUPS) != 0 {
        return false
    }

    //Must not be in another group
    if member.NPC!.group != nil && member.NPC!.group != group {
        //FIXME: if that group's enemy is mine, why not absorb that group into mine?
        return false
    }

    //Must be alive
    if member.health <= 0 {
        return false
    }

    //can't be in an emplaced gun
    //	if( member->s.eFlags & EF_LOCKED_TO_WEAPON )
    //		return qfalse;
    //rwwFIXMEFIXME: support this flag

    //Must be on the same team
    if member.client!.playerTeam != group.team {
        return false
    }

    if member.client!.ps.weapon == WP_SABER || member.client!.ps.weapon == WP_THERMAL || member.client!.ps.weapon == WP_DISRUPTOR || member.client!.ps.weapon == WP_EMPLACED_GUN || member.client!.ps.weapon == WP_STUN_BATON || member.client!.ps.weapon == WP_TURRET {
        //not really a squad-type guy
        return false
    }

    if member.client!.NPC_class == CLASS_ATST || member.client!.NPC_class == CLASS_PROBE || member.client!.NPC_class == CLASS_SEEKER || member.client!.NPC_class == CLASS_REMOTE || member.client!.NPC_class == CLASS_SENTRY || member.client!.NPC_class == CLASS_INTERROGATOR || member.client!.NPC_class == CLASS_MINEMONSTER || member.client!.NPC_class == CLASS_HOWLER || member.client!.NPC_class == CLASS_MARK1 || member.client!.NPC_class == CLASS_MARK2 {
        //these kinds of enemies don't actually use this group AI
        return false
    }

    //should have same enemy
    if member.enemy != group.enemy {
        if member.enemy != nil {
            //he's fighting someone else, leave him out
            return false
        }
        if !trap_InPVS(member.r.currentOrigin, group.enemy!.r.currentOrigin) {
            //not within PVS of the group enemy
            return false
        }
    } else if group.enemy == nil {
        //if the group is a patrol group, only take those within the room and radius
        if !AI_ValidateNoEnemyGroupMember(group, member) {
            return false
        }
    }
    //must be actually in combat mode
    if !TIMER_Done(member, "interrogating") {
        return false
    }
    //FIXME: need to have a route to enemy and/or clear shot?
    return true
}

/**
```
-------------------------
AI_GetGroup
-------------------------
```
*/
//#define MAX_WAITERS	128
/// Source: oracle/codemp/game/NPC_AI_Utils.c:443
func AI_GetGroup(_ `self`: Entity) {
    var i: Int32
    var member: Entity?
    //int	waiters[MAX_WAITERS];

    if `self`.NPC == nil {
        return
    }

    if d_noGroupAI.integer != 0 {
        `self`.NPC!.group = nil
        return
    }

    if `self`.client == nil {
        `self`.NPC!.group = nil
        return
    }

    if (`self`.NPC!.scriptFlags & SCF_NO_GROUPS) != 0 {
        `self`.NPC!.group = nil
        return
    }

    if `self`.enemy != nil && (`self`.enemy!.client == nil || (level.time - `self`.NPC!.enemyLastSeenTime > 7000)) {
        `self`.NPC!.group = nil
        return
    }

    if !AI_GetNextEmptyGroup(`self`) {
        //either no more groups left or we're already in a group built earlier
        return
    }

    //create a new one
    `self`.NPC!.group!.clear()

    `self`.NPC!.group!.enemy = `self`.enemy
    `self`.NPC!.group!.team = `self`.client!.playerTeam
    `self`.NPC!.group!.processed = false
    `self`.NPC!.group!.commander = `self`
    `self`.NPC!.group!.memberValidateTime = level.time + 2000
    `self`.NPC!.group!.activeMemberNum = 0

    if `self`.NPC!.group!.enemy != nil {
        `self`.NPC!.group!.lastSeenEnemyTime = level.time
        `self`.NPC!.group!.lastClearShotTime = level.time
        `self`.NPC!.group!.enemyLastSeenPos = `self`.NPC!.group!.enemy!.r.currentOrigin
    }

    //	for ( i = 0, member = &g_entities[0]; i < globals.num_entities ; i++, member++)
    i = 0
    while i < level.num_entities {
        member = g_entities[i]

        if !member!.inuse {
            i += 1
            continue
        }

        if !AI_ValidateGroupMember(`self`.NPC!.group!, member!) {
            //FIXME: keep track of those who aren't angry yet and see if we should wake them after we assemble the core group
            i += 1
            continue
        }

        //store it
        AI_InsertGroupMember(`self`.NPC!.group!, member!)

        if `self`.NPC!.group!.numGroup >= (MAX_GROUP_MEMBERS - 1) {
            //full
            break
        }
        i += 1
    }

    /*
    //now go through waiters and see if any should join the group
    //NOTE:  Some should hang back and probably not attack, so we can ambush
    //NOTE: only do this if calling for reinforcements?
    for ( i = 0; i < numWaiters; i++ )
    {
    waiter = &g_entities[waiters[i]];

    for ( j = 0; j < self->NPC->group->numGroup; j++ )
    {
    member = &g_entities[self->NPC->group->member[j];

    if ( trap_InPVS( waiter->r.currentOrigin, member->r.currentOrigin ) )
    {//this waiter is within PVS of a current member
    }
    }
    }
    */

    if `self`.NPC!.group!.numGroup <= 0 {
        //none in group
        `self`.NPC!.group = nil
        return
    }

    AI_SortGroupByPathCostToEnemy(`self`.NPC!.group!)
    AI_SetClosestBuddy(`self`.NPC!.group!)
}

/// Source: oracle/codemp/game/NPC_AI_Utils.c:553
func AI_SetNewGroupCommander(_ group: AIGroupInfo) {
    var member: Entity? = nil
    var i: Int32

    group.commander = nil
    i = 0
    while i < group.numGroup {
        member = g_entities[group.member[i].number]

        if group.commander == nil || (member != nil && member!.NPC != nil && group.commander!.NPC != nil && member!.NPC!.rank > group.commander!.NPC!.rank) {
            //keep track of highest rank
            group.commander = member
        }
        i += 1
    }
}

/// Source: oracle/codemp/game/NPC_AI_Utils.c:570
func AI_DeleteGroupMember(_ group: AIGroupInfo, _ memberNum: Int32) {
    var i: Int32

    if group.commander != nil && group.commander!.s.number == group.member[memberNum].number {
        group.commander = nil
    }
    if g_entities[group.member[memberNum].number].NPC != nil {
        g_entities[group.member[memberNum].number].NPC!.group = nil
    }
    i = memberNum
    while i < (group.numGroup - 1) {
        group.member[i].copy(from: group.member[i + 1])
        i += 1
    }
    if memberNum < group.activeMemberNum {
        group.activeMemberNum -= 1
        if group.activeMemberNum < 0 {
            group.activeMemberNum = 0
        }
    }
    group.numGroup -= 1
    if group.numGroup < 0 {
        group.numGroup = 0
    }
    AI_SetNewGroupCommander(group)
}

/// Source: oracle/codemp/game/NPC_AI_Utils.c:602
func AI_DeleteSelfFromGroup(_ `self`: Entity) {
    var i: Int32

    //FIXME: if killed, keep track of how many in group killed?  To affect morale?
    i = 0
    while i < `self`.NPC!.group!.numGroup {
        if `self`.NPC!.group!.member[i].number == `self`.s.number {
            AI_DeleteGroupMember(`self`.NPC!.group!, i)
            return
        }
        i += 1
    }
}

/// Source: oracle/codemp/game/NPC_AI_Utils.c:620
func AI_GroupMemberKilled(_ `self`: Entity) {
    let group: AIGroupInfo? = `self`.NPC!.group
    var member: Entity?
    var noflee: Bool = false
    var i: Int32

    if group == nil {
        //what group?
        return
    }
    if `self`.NPC == nil || `self`.NPC!.rank < RANK_ENSIGN {
        //I'm not an officer, let's not really care for now
        return
    }
    //temporarily drop group morale for a few seconds
    group!.moraleAdjust -= `self`.NPC!.rank
    //go through and drop aggression on my teammates (more cover, worse aim)
    i = 0
    while i < group!.numGroup {
        member = g_entities[group!.member[i].number]
        if member == `self` {
            i += 1
            continue
        }
        if member!.NPC!.rank > RANK_ENSIGN {
            //officers do not panic
            noflee = true
        } else {
            ST_AggressionAdjust(member!, -1)
            member!.NPC!.currentAim -= Q_irand(0, 10) //Q_irand( 0, 2);//drop their aim accuracy
        }
        i += 1
    }
    //okay, if I'm the group commander, make everyone else flee
    if group!.commander != `self` {
        //I'm not the commander... hmm, should maybe a couple flee... maybe those near me?
        return
    }
    //now see if there is another of sufficient rank to keep them from fleeing
    if !noflee {
        `self`.NPC!.group!.speechDebounceTime = 0
        i = 0
        while i < group!.numGroup {
            member = g_entities[group!.member[i].number]
            if member == `self` {
                i += 1
                continue
            }
            if member!.NPC!.rank < RANK_ENSIGN {
                //grunt
                if group!.enemy != nil && DistanceSquared(member!.r.currentOrigin, group!.enemy!.r.currentOrigin) < 65536 {
                    //those close to enemy run away!
                    ST_StartFlee(member!, group!.enemy!, member!.r.currentOrigin, AEL_DANGER_GREAT, 3000, 5000)
                } else if DistanceSquared(member!.r.currentOrigin, `self`.r.currentOrigin) < 65536 {
                    //those close to me run away!
                    ST_StartFlee(member!, group!.enemy!, member!.r.currentOrigin, AEL_DANGER_GREAT, 3000, 5000)
                } else {
                    //else, maybe just a random chance
                    if Q_irand(0, `self`.NPC!.rank) > member!.NPC!.rank {
                        //lower rank they are, higher rank I am, more likely they are to flee
                        ST_StartFlee(member!, group!.enemy!, member!.r.currentOrigin, AEL_DANGER_GREAT, 3000, 5000)
                    } else {
                        ST_MarkToCover(member!)
                    }
                }
                member!.NPC!.currentAim -= Q_irand(1, 15) //Q_irand( 1, 3 );//drop their aim accuracy even more
            }
            member!.NPC!.currentAim -= Q_irand(1, 15) //Q_irand( 1, 3 );//drop their aim accuracy even more
            i += 1
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_Utils.c:699
func AI_GroupUpdateEnemyLastSeen(_ group: AIGroupInfo?, _ spot: JKAShared.vec3_t) {
    if group == nil {
        return
    }
    group!.lastSeenEnemyTime = level.time
    group!.enemyLastSeenPos = spot
}

/// Source: oracle/codemp/game/NPC_AI_Utils.c:709
func AI_GroupUpdateClearShotTime(_ group: AIGroupInfo?) {
    if group == nil {
        return
    }
    group!.lastClearShotTime = level.time
}

/// Source: oracle/codemp/game/NPC_AI_Utils.c:718
func AI_GroupUpdateSquadstates(_ group: AIGroupInfo?, _ member: Entity, _ newSquadState: Int32) {
    if group == nil {
        return
    }
    var i: Int32


    i = 0
    while i < group!.numGroup {
        if group!.member[i].number == member.s.number {
            group!.numState[member.NPC!.squadState] -= 1
            member.NPC!.squadState = newSquadState
            group!.numState[member.NPC!.squadState] += 1
            return
        }
        i += 1
    }
}

/// Source: oracle/codemp/game/NPC_AI_Utils.c:740
func AI_RefreshGroup(_ group: AIGroupInfo) -> Bool {
    var member: Entity?
    var i: Int32

    //see if we should merge with another group
    i = 0
    while i < MAX_FRAME_GROUPS {
        if level.groups[i] == group {
            break
        } else {
            if level.groups[i].enemy == group.enemy {
                //2 groups with same enemy
                if level.groups[i].numGroup + group.numGroup < (MAX_GROUP_MEMBERS - 1) {
                    //combining the members would fit in one group
                    var deleteWhenDone: Bool = true
                    var j: Int32

                    //combine the members of mine into theirs
                    j = 0
                    while j < group.numGroup {
                        member = g_entities[group.member[j].number]
                        if level.groups[i].enemy == nil {
                            //special case for groups without enemies, must be in range
                            if !AI_ValidateNoEnemyGroupMember(level.groups[i], member!) {
                                deleteWhenDone = false
                                j += 1
                                continue
                            }
                        }
                        //remove this member from this group
                        AI_DeleteGroupMember(group, j)
                        //keep marker at same place since we deleted this guy and shifted everyone up one
                        j -= 1
                        //add them to the earlier group
                        AI_InsertGroupMember(level.groups[i], member!)
                        j += 1
                    }
                    //return and delete this group
                    if deleteWhenDone {
                        return false
                    }
                }
            }
        }
        i += 1
    }
    //clear numStates
    i = 0
    while i < NUM_SQUAD_STATES {
        group.numState[i] = 0
        i += 1
    }

    //go through group and validate each membership
    group.commander = nil
    i = 0
    while i < group.numGroup {
        /*
        //this checks for duplicate copies of one member in a group
        for ( j = 0; j < group->numGroup; j++ )
        {
        if ( i != j )
        {
        if ( group->member[i].number == group->member[j].number )
        {
        break;
        }
        }
        }
        if ( j < group->numGroup )
        {//found a dupe!
        gi.Printf( S_COLOR_RED"ERROR: member %s(%d) a duplicate group member!!!\n", g_entities[group->member[i].number].targetname, group->member[i].number );
        AI_DeleteGroupMember( group, i );
        i--;
        continue;
        }
        */
        member = g_entities[group.member[i].number]

        //Must be alive
        if member!.health <= 0 {
            AI_DeleteGroupMember(group, i)
            //keep marker at same place since we deleted this guy and shifted everyone up one
            i -= 1
        } else if group.memberValidateTime < level.time && !AI_ValidateGroupMember(group, member!) {
            //remove this one from the group
            AI_DeleteGroupMember(group, i)
            //keep marker at same place since we deleted this guy and shifted everyone up one
            i -= 1
        } else {
            //membership is valid
            //keep track of squadStates
            group.numState[member!.NPC!.squadState] += 1
            if group.commander == nil || member!.NPC!.rank > group.commander!.NPC!.rank {
                //keep track of highest rank
                group.commander = member
            }
        }
        i += 1
    }
    if group.memberValidateTime < level.time {
        group.memberValidateTime = level.time + Q_irand(500, 2500)
    }
    //Now add any new guys as long as we're not full
    /*
    for ( i = 0, member = &g_entities[0]; i < globals.num_entities && group->numGroup < (MAX_GROUP_MEMBERS - 1); i++, member++)
    {
    if ( !AI_ValidateGroupMember( group, member ) )
    {//FIXME: keep track of those who aren't angry yet and see if we should wake them after we assemble the core group
    continue;
    }
    if ( member->NPC->group == group )
    {//DOH, already in our group
    continue;
    }

    //store it
    AI_InsertGroupMember( group, member );
    }
    */

    //calc the morale of this group
    group.morale = group.moraleAdjust
    i = 0
    while i < group.numGroup {
        member = g_entities[group.member[i].number]
        if member!.NPC!.rank < RANK_ENSIGN {
            //grunts
            group.morale += 1
        } else {
            group.morale += member!.NPC!.rank
        }
        if group.commander != nil && debugNPCAI.integer != 0 {
            //G_DebugLine( group->commander->r.currentOrigin, member->r.currentOrigin, FRAMETIME, 0x00ff00ff, qtrue );
            G_TestLine(group.commander!.r.currentOrigin, member!.r.currentOrigin, 0x00000ff, FRAMETIME)
        }
        i += 1
    }
    if group.enemy != nil {
        //modify morale based on enemy health and weapon
        if group.enemy!.health < 10 {
            group.morale += 10
        } else if group.enemy!.health < 25 {
            group.morale += 5
        } else if group.enemy!.health < 50 {
            group.morale += 2
        }
        switch group.enemy!.s.weapon {
        case WP_SABER:
            group.morale -= 5

        case WP_BRYAR_PISTOL:
            group.morale += 3

        case WP_DISRUPTOR:
            group.morale += 2

        case WP_REPEATER:
            group.morale -= 1

        case WP_FLECHETTE:
            group.morale -= 2

        case WP_ROCKET_LAUNCHER:
            group.morale -= 10

        case WP_THERMAL:
            group.morale -= 5

        case WP_TRIP_MINE:
            group.morale -= 3

        case WP_DET_PACK:
            group.morale -= 10
            //		case WP_MELEE:			// Any ol' melee attack
            //			group->morale += 20;
            //			break;

        case WP_STUN_BATON:
            group.morale += 10

        case WP_EMPLACED_GUN:
            group.morale -= 8

        default:
            break
        }
    }
    if group.moraleDebounce < level.time {
        //slowly degrade whatever moraleAdjusters we may have
        if group.moraleAdjust > 0 {
            group.moraleAdjust -= 1
        } else if group.moraleAdjust < 0 {
            group.moraleAdjust += 1
        }
        group.moraleDebounce = level.time + 1000 //FIXME: define?
    }
    //mark this group as not having been run this frame
    group.processed = false

    return (group.numGroup > 0)
}

/// Source: oracle/codemp/game/NPC_AI_Utils.c:964
func AI_UpdateGroups() {
    var i: Int32

    if d_noGroupAI.integer != 0 {
        return
    }
    //Clear all Groups
    i = 0
    while i < MAX_FRAME_GROUPS {
        if level.groups[i].numGroup == 0 || AI_RefreshGroup(level.groups[i]) == false {
            level.groups[i].clear()
        }
        i += 1
    }
}

/// Source: oracle/codemp/game/NPC_AI_Utils.c:982
func AI_GroupContainsEntNum(_ group: AIGroupInfo?, _ entNum: Int32) -> Bool {
    if group == nil {
        return false
    }
    var i: Int32

    i = 0
    while i < group!.numGroup {
        if group!.member[i].number == entNum {
            return true
        }
        i += 1
    }
    return false
}

/// Source: oracle/codemp/game/NPC_AI_Utils.c:1030
func AI_CheckEnemyCollision(_ ent: Entity, _ takeEnemy: Bool) -> Bool {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return NavInfo.scratch { info -> Bool in

        if ent == nil {
            return false
        }

        //	if ( ent->svFlags & SVF_LOCKEDENEMY )
        //		return qfalse;

        NAV_GetLastMove(info)

        //See if we've hit something
        if info.blocker != nil && (info.blocker != ent.enemy) {
            if info.blocker!.client != nil && (info.blocker!.client!.playerTeam == ent.client!.enemyTeam) {
                if takeEnemy {
                    G_SetEnemy(ent, info.blocker!)
                }

                return true
            }
        }

        return false
    }
}

/// Source: oracle/codemp/game/NPC_AI_Utils.c:1065
func AI_DistributeAttack(_ attacker: Entity, _ enemy: Entity, _ team: JKAMP.team_t, _ threshold: Int32) -> Entity? {
    var radiusEnts: [Int32] = [Int32](repeating: 0, count: 128)
    var check: Entity?
    let numEnts: Int32
    let numSurrounding: Int32
    var i: Int32
    var j: Int32
    var mins = vec3_t()
    var maxs = vec3_t()

    //Don't take new targets
    //	if ( NPC->svFlags & SVF_LOCKEDENEMY )
    //		return enemy;

    numSurrounding = AI_GetGroupSize(enemy.r.currentOrigin, 48, team, attacker)

    //First, see if we should look for the player
    if enemy != g_entities[0] {
        //rwwFIXMEFIXME: care about all clients not just 0
        let aroundPlayer: Int32 = AI_GetGroupSize(g_entities[0].r.currentOrigin, 48, team, attacker)

        //See if we're above our threshold
        if aroundPlayer < threshold {
            return g_entities[0]
        }
    }

    //See if our current enemy is still ok
    if numSurrounding < threshold {
        return enemy
    }

    //Otherwise we need to take a new enemy if possible

    //Setup the bbox to search in
    i = 0
    while i < 3 {
        mins[i] = enemy.r.currentOrigin[i] - 512
        maxs[i] = enemy.r.currentOrigin[i] + 512
        i += 1
    }

    //Get the number of entities in a given space
    numEnts = trap_EntitiesInBox(mins, maxs, &radiusEnts, MAX_RADIUS_ENTS)

    //Cull this list
    j = 0
    while j < numEnts {
        check = g_entities[radiusEnts[j]]

        //Validate clients
        if check!.client == nil {
            j += 1
            continue
        }

        //Skip the requested avoid ent if present
        if (check == enemy) {
            j += 1
            continue
        }

        //Must be on the same team
        if check!.client!.playerTeam != enemy.client!.playerTeam {
            j += 1
            continue
        }

        //Must be alive
        if check!.health <= 0 {
            j += 1
            continue
        }

        //Must not be overwhelmed
        if AI_GetGroupSize(check!.r.currentOrigin, 48, team, attacker) > threshold {
            j += 1
            continue
        }

        return check
        j += 1
    }

    return nil
}
