# Hole round: g_nav, g_navnew, ai_util

This record gives one verdict for each Port-note of `Sources/JKAMP_GameLogic/g_nav.swift`, `Sources/JKAMP_GameLogic/g_navnew.swift`, and `Sources/JKAMP_GameLogic/ai_util.swift`.
The round filled 52 holes. 6 holes stand and 11 holes are blocked.

| File | Filled | Stands | Blocked |
|---|---|---|---|
| g_nav.swift | 18 | 6 | 7 |
| g_navnew.swift | 10 | 0 | 0 |
| ai_util.swift | 24 | 0 | 4 |

## g_nav.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| NAV_ClearPathToPoint | `trace.startsolid == qfalse` did not compile, Int32 against Bool | stands | No form compares a `byte` field with `qfalse`. Docket row 1. |
| NAV_Steer | NULL `right` output of AngleVectors, first call | filled | The plain comment of the NULL-output rule replaces the note: `// Raven passes NULL for the right and up outputs.` |
| NAV_Steer | NULL `up` output of AngleVectors, first call | filled | Same comment as the row above. |
| NAV_Steer | NULL `right` output of AngleVectors, second call | filled | Same comment form. |
| NAV_Steer | NULL `up` output of AngleVectors, second call | filled | Same comment form. |
| NAV_CheckAhead | `trace->allsolid == qfalse` did not compile, Int32 against Bool | stands | Docket row 1. |
| NAV_CheckAhead | `if VALIDSTRING( blocker->classname )` with no parentheses | filled | `if VALIDSTRING(blocker!.classname)` with the door block. `blocker` is the draft's `Entity?` local, so each read is the force unwrap. |
| NAV_TestBypass | NULL `right` output of AngleVectors | filled | Same comment form. |
| NAV_TestBypass | NULL `up` output of AngleVectors | filled | Same comment form. |
| NAV_Bypass | NULL `forward` output of AngleVectors | filled | `// Raven passes NULL for the forward and up outputs.` |
| NAV_Bypass | NULL `up` output of AngleVectors | filled | Same comment as the row above. |
| NAV_MoveBlocker | NULL `right` output of AngleVectors | filled | Same comment form. |
| NAV_MoveBlocker | NULL `up` output of AngleVectors | filled | Same comment form. |
| NAV_StackedCanyon | `tr.startsolid == qfalse` did not compile, first test | stands | Docket row 1. |
| NAV_StackedCanyon | `tr.startsolid == qfalse` did not compile, second test | stands | Docket row 1. |
| NAV_TestBestNode | `trace.allsolid == qfalse` did not compile, Int32 against Bool | stands | Docket row 1. |
| NAV_TestBestNode | `if VALIDSTRING( blocker->classname )` with no parentheses | filled | The whole door, breakable, usable, and brush chain, with `trap_Nav_AddFailedEdge` under `if failEdge`. `fabs` is `abs`. |
| NAV_MoveToGoal | Store inside the test of `goalEntity->waypoint` | filled | The store lifts before `if ... == WAYPOINT_NONE`. |
| NAV_MoveToGoal | Store inside the test of `self->waypoint` | filled | The store lifts before `if ... == WAYPOINT_NONE`. |
| waypoint_testDirection | NULL `right` output of AngleVectors | filled | Same comment form. |
| waypoint_testDirection | NULL `up` output of AngleVectors | filled | Same comment form. |
| waypoint_getRadius | `unsigned int minDist = MAX_RADIUS_CHECK + 1` did not compile, Int32 into UInt32 | stands | No form stores a C `int` into an `unsigned` local. Docket row 2. |
| waypoint_getRadius | Read of `minDist` in the call to waypoint_testDirection | blocked | The declaration of `minDist` stands, so the read has no local. |
| waypoint_getRadius | Read of `minDist` in `if ( dist < minDist )` | blocked | Same cause as the row above. |
| waypoint_getRadius | Read of `minDist` in `return minDist` | blocked | Same cause as the row above. |
| NAV_WaypointsTooFar | `(fatalErrorPointer-fatalErrorString)+len` did not compile | blocked | The write-cursor form makes `fatalErrorPointer` an `Int32` offset into `fatalErrorString`. The property `world.variables.fatalErrorPointer` is a generated `String` in `GameVariables`, so the fill needs a generator change. |
| NAV_WaypointsTooFar | `strcat( fatalErrorPointer, temp )` did not compile | blocked | Same cause. With an `Int32` offset the line is `strcat(&fatalErrorString, String(temp), at: fatalErrorPointer)`. |
| NAV_WaypointsTooFar | `fatalErrorPointer += len` did not compile | blocked | Same cause. |
| NAV_CalculatePaths | `if ( !tempWaypointList )` did not compile | filled | `tempWaypointList` is a file-scope array and is never NULL, so the guard drops under the never-null rule, as in NAV_GetStoredWaypoint. |
| NAV_CalculatePaths | `memset( fatalErrorString, 0, sizeof( fatalErrorString ) )` | filled | `fatalErrorString.zero()`, the form for a file-scope `char buf[N]`. |
| NAV_CalculatePaths | `fatalErrorPointer = &fatalErrorString[0]` did not compile | blocked | Same cause as NAV_WaypointsTooFar. With an `Int32` offset the line is `fatalErrorPointer = 0`. |

## g_navnew.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| NAVNEW_SidestepBlocker | NULL `right` output of AngleVectors, held side | filled | `// Raven passes NULL for the right and up outputs.` |
| NAVNEW_SidestepBlocker | NULL `up` output of AngleVectors, held side | filled | Same comment as the row above. |
| NAVNEW_SidestepBlocker | NULL `right` output of AngleVectors, right test | filled | Same comment form. |
| NAVNEW_SidestepBlocker | NULL `up` output of AngleVectors, right test | filled | Same comment form. |
| NAVNEW_SidestepBlocker | NULL `right` output of AngleVectors, left test | filled | Same comment form. |
| NAVNEW_SidestepBlocker | NULL `up` output of AngleVectors, left test | filled | Same comment form. |
| NAVNEW_Bypass | NULL `forward` output of AngleVectors | filled | `// Raven passes NULL for the forward and up outputs.` |
| NAVNEW_Bypass | NULL `up` output of AngleVectors | filled | Same comment as the row above. |
| NAVNEW_MoveToGoal | Store of `bestNode` inside an else-if test | filled | The store opens the else block, then `if bestNode == NODE_NONE`. The lookup tool has no row for `trap_Nav_GetBestNodeAltRoute2` or `trap_Nav_GetBestPathBetweenEnts`, so the calls take the shape of the sibling `trap_Nav_AddFailedNode(self, ...)`, and the build confirms them. |
| NAVNEW_MoveToGoal | `++numTries` inside the test of `if` | filled | `numTries += 1` lifts before `if numTries >= 10 { break failed }`, the draft's form for `goto failed`. |

## ai_util.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| GetValueGroup | Pointer local `char *place` | filled | `var place: Int32?`, the byte offset that `strstr` returns. |
| GetValueGroup | Pointer local `char *placesecond` | filled | `var placesecond: Int32?`. |
| GetValueGroup | Store `place = strstr(buf, group)` | filled | As Raven wrote it. |
| GetValueGroup | Read `if (!place)` | filled | `if place == nil { return 0 }`. |
| GetValueGroup | Read `startpoint = place - buf + strlen(group) + 1` | filled | A pointer minus its own buffer is the offset, `place! + strlen(group) + 1`. |
| GetValueGroup | Read `startletter = (place - buf) - 1` | filled | `(place!) - 1`. |
| GetValueGroup | Store `placesecond = strstr(place+1, group)` | blocked | The suffix subscript `buf[(place! + 1)...]` is the form for the read. The fill needs to know if `strstr` over a suffix returns an offset from the suffix or from the whole buffer. That fact is in `CString.swift` and `CharBuf.swift`, outside the read set. |
| GetValueGroup | Read of `placesecond` in the if-else | blocked | It depends on the store above. |
| GetPairedValue | Pointer local `char *place` | filled | `var place: Int32?`. |
| GetPairedValue | Pointer local `char *placesecond` | filled | `var placesecond: Int32?`. |
| GetPairedValue | Store `place = strstr(buf, key)` | filled | As Raven wrote it. |
| GetPairedValue | Read `if (!place)` | filled | `if place == nil { return 0 }`. |
| GetPairedValue | Read `startpoint = place - buf + strlen(key)` | filled | `place! + strlen(key)`. |
| GetPairedValue | Read `startletter = (place - buf) - 1` | filled | `(place!) - 1`. |
| GetPairedValue | Store `placesecond = strstr(place+1, key)` | blocked | Same cause as in GetValueGroup. |
| GetPairedValue | Read of `placesecond` in the if-else | blocked | It depends on the store above. |
| GetPairedValue | Read of `place` in `if (!found \|\| !place \|\| ...)` | filled | `!buf[startpoint]` and `buf[startpoint] == '\0'` read the same, so the test is written once under the two-line comment of the guide. |
| BotDoChat | `while (cobject->client->pers.netname[inc_n])` did not compile, Character against Int | filled | The byte reads take `pers.netnameBuffer`, and the byte stores take `bs.currentChatBuffer`. |
| BotDoChat | Byte store into `bs->currentChat` held as a String | filled | `bs.currentChatBuffer[inc_2] = chatgroup[inc_1]`. |
| BotDoChat | `bs->currentChat[inc_2] = '\0'` | filled | `bs.currentChatBuffer[inc_2] = 0`. |
| BotDoChat | `chatTime_stored` store did not compile, UInt against Int | filled | An `int` into a `float` with no operator at the store takes `Float(...)`. |
| ParseEmotionalAttachments | Byte store into `loved[].name` held as a String | filled | `bs.loved[bs.lovednum].nameBuffer[i_c] = buf[i]`. |
| ParseEmotionalAttachments | `loved[].name[i_c] = '\0'` | filled | `bs.loved[bs.lovednum].nameBuffer[i_c] = 0`. |
| ReadChatGroups | Pointer local `char *cgroupbegin` | filled | `var cgroupbegin: Int32?`. |
| ReadChatGroups | Store `cgroupbegin = strstr(buf, "BEGIN_CHAT_GROUPS")` | filled | As Raven wrote it. |
| ReadChatGroups | Read `if (!cgroupbegin)` | filled | `if cgroupbegin == nil { return 0 }`. |
| ReadChatGroups | Read `strlen(cgroupbegin)` | filled | The suffix subscript, `strlen(buf[cgroupbegin!...])`. |
| ReadChatGroups | Read `cgbplace = cgroupbegin - buf+1` | filled | `cgroupbegin! + 1`. |

## GameWorld properties

None. No hole of the three files needs a static local or a file-scope static.

## Docket rows

1. `trace.startsolid == qfalse` and the same compare on `allsolid`, five holes in NAV_ClearPathToPoint, NAV_CheckAhead, NAV_StackedCanyon (two), and NAV_TestBestNode. The `byte` field is `Int32` on the view and `qfalse` is `Bool`, and no form compares the two. Proposed form: a compare of a C integer with `qfalse` or `qtrue` spells the constant as `0` or `1`, `trace.startsolid == 0`, the same text the truth-test form already gives for `!trace.startsolid`.
2. `unsigned int minDist = MAX_RADIUS_CHECK + 1` of waypoint_getRadius. The guide gives the `unsigned` overload for a pass to a parameter, but no form for a store of an `int` into an `unsigned` local. Proposed form: an `int` stored into an `unsigned` local takes `UInt32(...)` at the store, the mirror of the `float`-into-`int` rule, `var minDist: UInt32 = UInt32(MAX_RADIUS_CHECK + 1)`.
