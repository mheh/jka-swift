import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/ai_wpnav.c:6
var gWPRenderTime: Float {
    get { world.variables.gWPRenderTime }
    set { world.variables.gWPRenderTime = newValue }
}

/// Source: oracle/codemp/game/ai_wpnav.c:7
var gDeactivated: Float {
    get { world.variables.gDeactivated }
    set { world.variables.gDeactivated = newValue }
}

/// Source: oracle/codemp/game/ai_wpnav.c:8
var gBotEdit: Float {
    get { world.variables.gBotEdit }
    set { world.variables.gBotEdit = newValue }
}

/// Source: oracle/codemp/game/ai_wpnav.c:9
var gWPRenderedFrame: Int32 {
    get { world.variables.gWPRenderedFrame }
    set { world.variables.gWPRenderedFrame = newValue }
}

/// Source: oracle/codemp/game/ai_wpnav.c:12
var gWPArray: Slots<JKAMP.Wpobject?> { world.storage.gWPArray }

/// Source: oracle/codemp/game/ai_wpnav.c:13
var gWPNum: Int32 {
    get { world.variables.gWPNum }
    set { world.variables.gWPNum = newValue }
}

/// Source: oracle/codemp/game/ai_wpnav.c:16
var gLastPrintedIndex: Int32 {
    get { world.variables.gLastPrintedIndex }
    set { world.variables.gLastPrintedIndex = newValue }
}

/// Source: oracle/codemp/game/ai_wpnav.c:19
var nodetable: Slots<Nodeobject> { world.storage.nodetable }

/// Source: oracle/codemp/game/ai_wpnav.c:20
var nodenum: Int32 {
    get { world.variables.nodenum }
    set { world.variables.nodenum = newValue }
}

/// Source: oracle/codemp/game/ai_wpnav.c:23
var gLevelFlags: Int32 {
    get { world.variables.gLevelFlags }
    set { world.variables.gLevelFlags = newValue }
}

/// Source: oracle/codemp/game/ai_wpnav.c:1796
// Raven wrote: float botGlobalNavWeaponWeights[WP_NUM_WEAPONS]
let botGlobalNavWeaponWeights: [Float] = { () -> [Float] in portMissing("botGlobalNavWeaponWeights", source: "oracle/codemp/game/ai_wpnav.c:1796") }()

/// Source: oracle/codemp/game/ai_wpnav.c:2505
let MAX_SPAWNPOINT_ARRAY = 64 as Int32

/// Source: oracle/codemp/game/ai_wpnav.c:2506
var gSpawnPointNum: Int32 {
    get { world.variables.gSpawnPointNum }
    set { world.variables.gSpawnPointNum = newValue }
}

/// Source: oracle/codemp/game/ai_wpnav.c:2507
var gSpawnPoints: Slots<Entity?> { world.storage.gSpawnPoints }

/// Source: oracle/codemp/game/ai_wpnav.c:25
func GetFlagStr(_ flags: Int32) -> String {
    var flagstr = CharBuf(128)
    var i: Int32

    fend: do {
        _ = B_TempAlloc(128)
        i = 0

        if flags == 0 {
            strcpy(&flagstr, "none\0")
            break fend
        }

        if (flags & WPFLAG_JUMP) != 0 {
            flagstr[i] = Int32(ascii: "j")
            i += 1
        }

        if (flags & WPFLAG_DUCK) != 0 {
            flagstr[i] = Int32(ascii: "d")
            i += 1
        }

        if (flags & WPFLAG_SNIPEORCAMPSTAND) != 0 {
            flagstr[i] = Int32(ascii: "c")
            i += 1
        }

        if (flags & WPFLAG_WAITFORFUNC) != 0 {
            flagstr[i] = Int32(ascii: "f")
            i += 1
        }

        if (flags & WPFLAG_SNIPEORCAMP) != 0 {
            flagstr[i] = Int32(ascii: "s")
            i += 1
        }

        if (flags & WPFLAG_ONEWAY_FWD) != 0 {
            flagstr[i] = Int32(ascii: "x")
            i += 1
        }

        if (flags & WPFLAG_ONEWAY_BACK) != 0 {
            flagstr[i] = Int32(ascii: "y")
            i += 1
        }

        if (flags & WPFLAG_GOALPOINT) != 0 {
            flagstr[i] = Int32(ascii: "g")
            i += 1
        }

        if (flags & WPFLAG_NOVIS) != 0 {
            flagstr[i] = Int32(ascii: "n")
            i += 1
        }

        if (flags & WPFLAG_NOMOVEFUNC) != 0 {
            flagstr[i] = Int32(ascii: "m")
            i += 1
        }

        if (flags & WPFLAG_RED_FLAG) != 0 {
            if i != 0 {
                flagstr[i] = Int32(ascii: " ")
                i += 1
            }
            flagstr[i] = Int32(ascii: "r")
            i += 1
            flagstr[i] = Int32(ascii: "e")
            i += 1
            flagstr[i] = Int32(ascii: "d")
            i += 1
            flagstr[i] = Int32(ascii: " ")
            i += 1
            flagstr[i] = Int32(ascii: "f")
            i += 1
            flagstr[i] = Int32(ascii: "l")
            i += 1
            flagstr[i] = Int32(ascii: "a")
            i += 1
            flagstr[i] = Int32(ascii: "g")
            i += 1
        }

        if (flags & WPFLAG_BLUE_FLAG) != 0 {
            if i != 0 {
                flagstr[i] = Int32(ascii: " ")
                i += 1
            }
            flagstr[i] = Int32(ascii: "b")
            i += 1
            flagstr[i] = Int32(ascii: "l")
            i += 1
            flagstr[i] = Int32(ascii: "u")
            i += 1
            flagstr[i] = Int32(ascii: "e")
            i += 1
            flagstr[i] = Int32(ascii: " ")
            i += 1
            flagstr[i] = Int32(ascii: "f")
            i += 1
            flagstr[i] = Int32(ascii: "l")
            i += 1
            flagstr[i] = Int32(ascii: "a")
            i += 1
            flagstr[i] = Int32(ascii: "g")
            i += 1
        }

        if (flags & WPFLAG_SIEGE_IMPERIALOBJ) != 0 {
            if i != 0 {
                flagstr[i] = Int32(ascii: " ")
                i += 1
            }
            flagstr[i] = Int32(ascii: "s")
            i += 1
            flagstr[i] = Int32(ascii: "a")
            i += 1
            flagstr[i] = Int32(ascii: "g")
            i += 1
            flagstr[i] = Int32(ascii: "a")
            i += 1
            flagstr[i] = Int32(ascii: "_")
            i += 1
            flagstr[i] = Int32(ascii: "i")
            i += 1
            flagstr[i] = Int32(ascii: "m")
            i += 1
            flagstr[i] = Int32(ascii: "p")
            i += 1
        }

        if (flags & WPFLAG_SIEGE_REBELOBJ) != 0 {
            if i != 0 {
                flagstr[i] = Int32(ascii: " ")
                i += 1
            }
            flagstr[i] = Int32(ascii: "s")
            i += 1
            flagstr[i] = Int32(ascii: "a")
            i += 1
            flagstr[i] = Int32(ascii: "g")
            i += 1
            flagstr[i] = Int32(ascii: "a")
            i += 1
            flagstr[i] = Int32(ascii: "_")
            i += 1
            flagstr[i] = Int32(ascii: "r")
            i += 1
            flagstr[i] = Int32(ascii: "e")
            i += 1
            flagstr[i] = Int32(ascii: "b")
            i += 1
        }

        flagstr[i] = 0

        if i == 0 {
            strcpy(&flagstr, "unknown\0")
        }

    }
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert return expression of type 'CharBuf' to return type 'String'".
    // Raven wrote: return flagstr
    portMissing("GetFlagStr", source: "oracle/codemp/game/ai_wpnav.c:25")
}

/// Source: oracle/codemp/game/ai_wpnav.c:212
func G_TestLine(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ color: Int32, _ time: Int32) {
    var te: Entity?

    te = G_TempEntity(start, EV_TESTLINE)
    te!.s.origin = start
    te!.s.origin2 = end
    te!.s.time2 = time
    te!.s.weapon = color
    te!.r.svFlags |= SVF_BROADCAST
}

/// Source: oracle/codemp/game/ai_wpnav.c:224
func BotWaypointRender() {
    var i: Int32
    var n: Int32
    let inc_checker: Int32
    var bestindex: Int32
    var gotbestindex: Int32
    var bestdist: Float
    var checkdist: Float
    var plum: Entity?
    var viewent: Entity?
    let flagstr: String
    var a = vec3_t()

    checkprint: do {
        if gBotEdit == 0 {
            return
        }

        bestindex = 0

        if gWPRenderTime > level.time {
            break checkprint
        }

        gWPRenderTime = Float(level.time + 100)

        i = gWPRenderedFrame
        inc_checker = gWPRenderedFrame

        while i < gWPNum {
            if gWPArray[i] != nil && gWPArray[i]!.inuse != 0 {
                plum = G_TempEntity(gWPArray[i]!.origin, EV_SCOREPLUM)
                plum!.r.svFlags |= SVF_BROADCAST
                plum!.s.time = i

                n = 0

                while n < gWPArray[i]!.neighbornum {
                    if gWPArray[i]!.neighbors[n].forceJumpTo != 0 && gWPArray[gWPArray[i]!.neighbors[n].num] != nil {
                        G_TestLine(gWPArray[i]!.origin, gWPArray[gWPArray[i]!.neighbors[n].num]!.origin, 0x0000ff, 5000)
                    }
                    n += 1
                }

                gWPRenderedFrame += 1
            } else {
                gWPRenderedFrame = 0
                break
            }

            if (i - inc_checker) > 4 {
                break //don't render too many at once
            }
            i += 1
        }

        if i >= gWPNum {
            gWPRenderTime = Float(level.time + 1500) //wait a bit after we finish doing the whole trail
            gWPRenderedFrame = 0
        }

    }

    if bot_wp_info.value == 0 {
        return
    }

    viewent = g_entities[0] //only show info to the first client

    if viewent == nil || viewent!.client == nil {
        //client isn't in the game yet?
        return
    }

    bestdist = 256 //max distance for showing point info
    gotbestindex = 0

    i = 0

    while i < gWPNum {
        if gWPArray[i] != nil && gWPArray[i]!.inuse != 0 {
            a = viewent!.client!.ps.origin - gWPArray[i]!.origin

            checkdist = VectorLength(a)

            if checkdist < bestdist {
                bestdist = checkdist
                bestindex = i
                gotbestindex = 1
            }
        }
        i += 1
    }

    if gotbestindex != 0 && bestindex != gLastPrintedIndex {
        flagstr = GetFlagStr(gWPArray[bestindex]!.flags)
        gLastPrintedIndex = bestindex
        G_Printf(S_COLOR_YELLOW + "Waypoint %i\nFlags - %i (%s) (w%f)\nOrigin - (%i %i %i)\n", Int32((gWPArray[bestindex]!.index)), Int32((gWPArray[bestindex]!.flags)), flagstr, gWPArray[bestindex]!.weight, Int32((gWPArray[bestindex]!.origin[0])), Int32((gWPArray[bestindex]!.origin[1])), Int32((gWPArray[bestindex]!.origin[2])))
        //GetFlagStr allocates 128 bytes for this, if it's changed then obviously this must be as well
        B_TempFree(128) //flagstr

        plum = G_TempEntity(gWPArray[bestindex]!.origin, EV_SCOREPLUM)
        plum!.r.svFlags |= SVF_BROADCAST
        plum!.s.time = bestindex //render it once
    } else if gotbestindex == 0 {
        gLastPrintedIndex = -1
    }
}

/// Source: oracle/codemp/game/ai_wpnav.c:349
func TransferWPData(_ from: Int32, _ to: Int32) {
    if gWPArray[to] == nil {
        gWPArray[to] = Wpobject(B_Alloc(Int32(Wpobject.byteCount)))
    }

    if gWPArray[to] == nil {
        G_Printf(S_COLOR_RED + "FATAL ERROR: Could not allocated memory for waypoint\n")
    }

    gWPArray[to]!.flags = gWPArray[from]!.flags
    gWPArray[to]!.weight = gWPArray[from]!.weight
    gWPArray[to]!.associated_entity = gWPArray[from]!.associated_entity
    gWPArray[to]!.disttonext = gWPArray[from]!.disttonext
    gWPArray[to]!.forceJumpTo = gWPArray[from]!.forceJumpTo
    gWPArray[to]!.index = to
    gWPArray[to]!.inuse = gWPArray[from]!.inuse
    gWPArray[to]!.origin = gWPArray[from]!.origin
}

/// Source: oracle/codemp/game/ai_wpnav.c:371
func CreateNewWP(_ origin: JKAShared.vec3_t, _ flags: Int32) {
    if gWPNum >= MAX_WPARRAY_SIZE {
        if g_RMG.integer == 0 {
            G_Printf(S_COLOR_YELLOW + "Warning: Waypoint limit hit (%i)\n", MAX_WPARRAY_SIZE)
        }
        return
    }

    if gWPArray[gWPNum] == nil {
        gWPArray[gWPNum] = Wpobject(B_Alloc(Int32(Wpobject.byteCount)))
    }

    if gWPArray[gWPNum] == nil {
        G_Printf(S_COLOR_RED + "ERROR: Could not allocated memory for waypoint\n")
    }

    gWPArray[gWPNum]!.flags = flags
    gWPArray[gWPNum]!.weight = 0 //calculated elsewhere
    gWPArray[gWPNum]!.associated_entity = ENTITYNUM_NONE //set elsewhere
    gWPArray[gWPNum]!.forceJumpTo = 0
    gWPArray[gWPNum]!.disttonext = 0 //calculated elsewhere
    gWPArray[gWPNum]!.index = gWPNum
    gWPArray[gWPNum]!.inuse = 1
    gWPArray[gWPNum]!.origin = origin
    gWPNum += 1
}

/// Source: oracle/codemp/game/ai_wpnav.c:403
func CreateNewWP_FromObject(_ wp: JKAMP.Wpobject) {
    var i: Int32

    if gWPNum >= MAX_WPARRAY_SIZE {
        return
    }

    if gWPArray[gWPNum] == nil {
        gWPArray[gWPNum] = Wpobject(B_Alloc(Int32(Wpobject.byteCount)))
    }

    if gWPArray[gWPNum] == nil {
        G_Printf(S_COLOR_RED + "ERROR: Could not allocated memory for waypoint\n")
    }

    gWPArray[gWPNum]!.flags = wp.flags
    gWPArray[gWPNum]!.weight = wp.weight
    gWPArray[gWPNum]!.associated_entity = wp.associated_entity
    gWPArray[gWPNum]!.disttonext = wp.disttonext
    gWPArray[gWPNum]!.forceJumpTo = wp.forceJumpTo
    gWPArray[gWPNum]!.index = gWPNum
    gWPArray[gWPNum]!.inuse = 1
    gWPArray[gWPNum]!.origin = wp.origin
    gWPArray[gWPNum]!.neighbornum = wp.neighbornum

    i = wp.neighbornum

    while i >= 0 {
        gWPArray[gWPNum]!.neighbors[i].num = wp.neighbors[i].num
        gWPArray[gWPNum]!.neighbors[i].forceJumpTo = wp.neighbors[i].forceJumpTo

        i -= 1
    }

    if (gWPArray[gWPNum]!.flags & WPFLAG_RED_FLAG) != 0 {
        flagRed = gWPArray[gWPNum]
        oFlagRed = flagRed
    } else if (gWPArray[gWPNum]!.flags & WPFLAG_BLUE_FLAG) != 0 {
        flagBlue = gWPArray[gWPNum]
        oFlagBlue = flagBlue
    }

    gWPNum += 1
}

/// Source: oracle/codemp/game/ai_wpnav.c:456
func RemoveWP() {
    if gWPNum <= 0 {
        return
    }

    gWPNum -= 1

    if gWPArray[gWPNum] == nil || gWPArray[gWPNum]!.inuse == 0 {
        return
    }

    //B_Free((wpobject_t *)gWPArray[gWPNum]);
    if gWPArray[gWPNum] != nil {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'Wpobject?' must be unwrapped to refer to member 'clear' of wrapped base type 'Wpobject'".
        // Raven wrote: memset( gWPArray[gWPNum], 0, sizeof(gWPArray[gWPNum]) )
        portMissing("RemoveWP", source: "oracle/codemp/game/ai_wpnav.c:456")
    }

    //gWPArray[gWPNum] = NULL;

    if gWPArray[gWPNum] != nil {
        gWPArray[gWPNum]!.inuse = 0
    }
}

/// Source: oracle/codemp/game/ai_wpnav.c:484
func RemoveAllWP() {
    while gWPNum != 0 {
        RemoveWP()
    }
}

/// Source: oracle/codemp/game/ai_wpnav.c:491
func RemoveWP_InTrail(_ afterindex: Int32) {
    var foundindex: Int32
    var foundanindex: Int32
    var didchange: Int32
    var i: Int32

    foundindex = 0
    foundanindex = 0
    didchange = 0
    i = 0

    if afterindex < 0 || afterindex >= gWPNum {
        G_Printf(S_COLOR_YELLOW + "Waypoint number %i does not exist\n", afterindex)
        return
    }

    while i < gWPNum {
        if gWPArray[i] != nil && gWPArray[i]!.inuse != 0 && gWPArray[i]!.index == afterindex {
            foundindex = i
            foundanindex = 1
            break
        }

        i += 1
    }

    if foundanindex == 0 {
        G_Printf(S_COLOR_YELLOW + "Waypoint index %i should exist, but does not (?)\n", afterindex)
        return
    }

    i = 0

    while i <= gWPNum {
        if gWPArray[i] != nil && gWPArray[i]!.index == foundindex {
            //B_Free(gWPArray[i]);

            //Keep reusing the memory
            // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'Wpobject?' must be unwrapped to refer to member 'clear' of wrapped base type 'Wpobject'".
            // Raven wrote: memset( gWPArray[i], 0, sizeof(gWPArray[i]) )
            portMissing("RemoveWP_InTrail", source: "oracle/codemp/game/ai_wpnav.c:491")

            //gWPArray[i] = NULL;
            gWPArray[i]!.inuse = 0
            didchange = 1
        } else if gWPArray[i] != nil && didchange != 0 {
            TransferWPData(i, i - 1)
            //B_Free(gWPArray[i]);

            //Keep reusing the memory
            // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'Wpobject?' must be unwrapped to refer to member 'clear' of wrapped base type 'Wpobject'".
            // Raven wrote: memset( gWPArray[i], 0, sizeof(gWPArray[i]) )
            portMissing("RemoveWP_InTrail", source: "oracle/codemp/game/ai_wpnav.c:491")

            //gWPArray[i] = NULL;
            gWPArray[i]!.inuse = 0
        }

        i += 1
    }
    gWPNum -= 1
}

/// Source: oracle/codemp/game/ai_wpnav.c:559
func CreateNewWP_InTrail(_ origin: JKAShared.vec3_t, _ flags: Int32, _ afterindex: Int32) -> Int32 {
    var foundindex: Int32
    var foundanindex: Int32
    var i: Int32

    foundindex = 0
    foundanindex = 0
    i = 0

    if gWPNum >= MAX_WPARRAY_SIZE {
        if g_RMG.integer == 0 {
            G_Printf(S_COLOR_YELLOW + "Warning: Waypoint limit hit (%i)\n", MAX_WPARRAY_SIZE)
        }
        return 0
    }

    if afterindex < 0 || afterindex >= gWPNum {
        G_Printf(S_COLOR_YELLOW + "Waypoint number %i does not exist\n", afterindex)
        return 0
    }

    while i < gWPNum {
        if gWPArray[i] != nil && gWPArray[i]!.inuse != 0 && gWPArray[i]!.index == afterindex {
            foundindex = i
            foundanindex = 1
            break
        }

        i += 1
    }

    if foundanindex == 0 {
        G_Printf(S_COLOR_YELLOW + "Waypoint index %i should exist, but does not (?)\n", afterindex)
        return 0
    }

    i = gWPNum

    while i >= 0 {
        if gWPArray[i] != nil && gWPArray[i]!.inuse != 0 && gWPArray[i]!.index != foundindex {
            TransferWPData(i, i + 1)
        } else if gWPArray[i] != nil && gWPArray[i]!.inuse != 0 && gWPArray[i]!.index == foundindex {
            i += 1

            if gWPArray[i] == nil {
                gWPArray[i] = Wpobject(B_Alloc(Int32(Wpobject.byteCount)))
            }

            gWPArray[i]!.flags = flags
            gWPArray[i]!.weight = 0 //calculated elsewhere
            gWPArray[i]!.associated_entity = ENTITYNUM_NONE //set elsewhere
            gWPArray[i]!.disttonext = 0 //calculated elsewhere
            gWPArray[i]!.forceJumpTo = 0
            gWPArray[i]!.index = i
            gWPArray[i]!.inuse = 1
            gWPArray[i]!.origin = origin
            gWPNum += 1
            break
        }

        i -= 1
    }

    return 1
}

/// Source: oracle/codemp/game/ai_wpnav.c:637
func CreateNewWP_InsertUnder(_ origin: JKAShared.vec3_t, _ flags: Int32, _ afterindex: Int32) -> Int32 {
    var foundindex: Int32
    var foundanindex: Int32
    var i: Int32

    foundindex = 0
    foundanindex = 0
    i = 0

    if gWPNum >= MAX_WPARRAY_SIZE {
        if g_RMG.integer == 0 {
            G_Printf(S_COLOR_YELLOW + "Warning: Waypoint limit hit (%i)\n", MAX_WPARRAY_SIZE)
        }
        return 0
    }

    if afterindex < 0 || afterindex >= gWPNum {
        G_Printf(S_COLOR_YELLOW + "Waypoint number %i does not exist\n", afterindex)
        return 0
    }

    while i < gWPNum {
        if gWPArray[i] != nil && gWPArray[i]!.inuse != 0 && gWPArray[i]!.index == afterindex {
            foundindex = i
            foundanindex = 1
            break
        }

        i += 1
    }

    if foundanindex == 0 {
        G_Printf(S_COLOR_YELLOW + "Waypoint index %i should exist, but does not (?)\n", afterindex)
        return 0
    }

    i = gWPNum

    while i >= 0 {
        if gWPArray[i] != nil && gWPArray[i]!.inuse != 0 && gWPArray[i]!.index != foundindex {
            TransferWPData(i, i + 1)
        } else if gWPArray[i] != nil && gWPArray[i]!.inuse != 0 && gWPArray[i]!.index == foundindex {
            //i++;
            TransferWPData(i, i + 1)

            if gWPArray[i] == nil {
                gWPArray[i] = Wpobject(B_Alloc(Int32(Wpobject.byteCount)))
            }

            gWPArray[i]!.flags = flags
            gWPArray[i]!.weight = 0 //calculated elsewhere
            gWPArray[i]!.associated_entity = ENTITYNUM_NONE //set elsewhere
            gWPArray[i]!.disttonext = 0 //calculated elsewhere
            gWPArray[i]!.forceJumpTo = 0
            gWPArray[i]!.index = i
            gWPArray[i]!.inuse = 1
            gWPArray[i]!.origin = origin
            gWPNum += 1
            break
        }

        i -= 1
    }

    return 1
}

/// Source: oracle/codemp/game/ai_wpnav.c:716
func TeleportToWP(_ pl: Entity, _ afterindex: Int32) {
    var foundindex: Int32
    var foundanindex: Int32
    var i: Int32

    if pl.client == nil {
        return
    }

    foundindex = 0
    foundanindex = 0
    i = 0

    if afterindex < 0 || afterindex >= gWPNum {
        G_Printf(S_COLOR_YELLOW + "Waypoint number %i does not exist\n", afterindex)
        return
    }

    while i < gWPNum {
        if gWPArray[i] != nil && gWPArray[i]!.inuse != 0 && gWPArray[i]!.index == afterindex {
            foundindex = i
            foundanindex = 1
            break
        }

        i += 1
    }

    if foundanindex == 0 {
        G_Printf(S_COLOR_YELLOW + "Waypoint index %i should exist, but does not (?)\n", afterindex)
        return
    }

    pl.client!.ps.origin = gWPArray[foundindex]!.origin

    return
}

/// Source: oracle/codemp/game/ai_wpnav.c:760
func WPFlagsModify(_ wpnum: Int32, _ flags: Int32) {
    if wpnum < 0 || wpnum >= gWPNum || gWPArray[wpnum] == nil || gWPArray[wpnum]!.inuse == 0 {
        G_Printf(S_COLOR_YELLOW + "WPFlagsModify: Waypoint %i does not exist\n", wpnum)
        return
    }

    gWPArray[wpnum]!.flags = flags
}

/// Source: oracle/codemp/game/ai_wpnav.c:771
private func NotWithinRange(_ base: Int32, _ extent: Int32) -> Int32 {
    if extent > base && base + 5 >= extent {
        return 0
    }

    if extent < base && base - 5 <= extent {
        return 0
    }

    return 1
}

/// Source: oracle/codemp/game/ai_wpnav.c:787
func NodeHere(_ spot: JKAShared.vec3_t) -> Int32 {
    var i: Int32

    i = 0

    while i < nodenum {
        if Int32(nodetable[i].origin[0]) == Int32(spot[0]) && Int32(nodetable[i].origin[1]) == Int32(spot[1]) {
            if Int32(nodetable[i].origin[2]) == Int32(spot[2]) || (Int32(nodetable[i].origin[2]) < Int32(spot[2]) && Int32(nodetable[i].origin[2]) + 5 > Int32(spot[2])) || (Int32(nodetable[i].origin[2]) > Int32(spot[2]) && Int32(nodetable[i].origin[2]) - 5 < Int32(spot[2])) {
                return 1
            }
        }
        i += 1
    }

    return 0
}

/// Source: oracle/codemp/game/ai_wpnav.c:812
func CanGetToVector(_ org1: JKAShared.vec3_t, _ org2: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t) -> Int32 {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Int32 in

        trap_Trace(tr, org1, mins, maxs, org2, ENTITYNUM_NONE, MASK_SOLID)

        if tr.fraction == 1 && tr.startsolid == 0 && tr.allsolid == 0 {
            return 1
        }

        return 0
    }
}

/// Source: oracle/codemp/game/ai_wpnav.c:883
func CanGetToVectorTravel(_ org1: JKAShared.vec3_t, _ moveTo: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t) -> Int32 {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Int32 in
        var stepTo = vec3_t()
        var stepSub = vec3_t()
        var stepGoal = vec3_t()
        var workingOrg = vec3_t()
        var lastIncrement = vec3_t()
        var finalMeasure = vec3_t()
        var stepSize: Float = 0
        var measureLength: Float = 0
        var didMove: Int32 = 0
        let traceMask: Int32 = MASK_PLAYERSOLID
        var initialDone: Bool = false

        workingOrg = org1
        lastIncrement = org1

        stepTo = moveTo
        stepTo[2] = workingOrg[2]

        stepSub = stepTo - workingOrg
        stepSize = VectorLength(stepSub) //make the step size the length of the original positions without Z

        VectorNormalize(&stepSub)

        while !initialDone || didMove != 0 {
            initialDone = true
            didMove = 0

            stepGoal[0] = workingOrg[0] + stepSub[0] * stepSize
            stepGoal[1] = workingOrg[1] + stepSub[1] * stepSize
            stepGoal[2] = workingOrg[2] + stepSub[2] * stepSize

            trap_Trace(tr, workingOrg, mins, maxs, stepGoal, ENTITYNUM_NONE, traceMask)

            if tr.startsolid == 0 && tr.allsolid == 0 && tr.fraction != 0 {
                var vecSub = vec3_t()
                vecSub = workingOrg - tr.endpos

                if VectorLength(vecSub) > (stepSize / 2) {
                    workingOrg[0] = tr.endpos[0]
                    workingOrg[1] = tr.endpos[1]
                    //trap_LinkEntity(self);
                    didMove = 1
                }
            }

            if didMove != 1 {
                //stair check
                var trFrom = vec3_t()
                var trTo = vec3_t()
                var trDir = vec3_t()
                var vecMeasure = vec3_t()

                trFrom = tr.endpos
                trFrom[2] += 16

                trDir = stepGoal - workingOrg
                VectorNormalize(&trDir)
                trTo[0] = tr.endpos[0] + trDir[0] * 2
                trTo[1] = tr.endpos[1] + trDir[1] * 2
                trTo[2] = tr.endpos[2] + trDir[2] * 2
                trTo[2] += 16

                vecMeasure = trFrom - trTo

                if VectorLength(vecMeasure) > 1 {
                    trap_Trace(tr, trFrom, mins, maxs, trTo, ENTITYNUM_NONE, traceMask)

                    if tr.startsolid == 0 && tr.allsolid == 0 && tr.fraction == 1 {
                        //clear trace here, probably up a step
                        var trDown = vec3_t()
                        var trUp = vec3_t()
                        trUp = tr.endpos
                        trDown = tr.endpos
                        trDown[2] -= 16

                        trap_Trace(tr, trFrom, mins, maxs, trTo, ENTITYNUM_NONE, traceMask)

                        if tr.startsolid == 0 && tr.allsolid == 0 {
                            //plop us down on the step after moving up
                            workingOrg = tr.endpos
                            //trap_LinkEntity(self);
                            didMove = 1
                        }
                    }
                }
            }

            finalMeasure = lastIncrement - workingOrg
            measureLength = VectorLength(finalMeasure)

            if measureLength == 0 {
                //no progress, break out. If last movement was a sucess didMove will equal 1.
                break
            }

            stepSize -= measureLength //subtract the progress distance from the step size so we don't overshoot the mark.
            if stepSize <= 0 {
                break
            }

            lastIncrement = workingOrg
        }

        return didMove
    }
}

/// Source: oracle/codemp/game/ai_wpnav.c:1000
func ConnectTrail(_ startindex: Int32, _ endindex: Int32, _ behindTheScenes: Bool) -> Int32 {
    var foundit: Int32 = 0
    var cancontinue: Int32 = 0
    var i: Int32 = 0
    var failsafe: Int32 = 0
    var successnodeindex: Int32 = 0
    var insertindex: Int32 = 0
    var prenodestart: Int32 = 0
    var extendednodes: [Int32] = [Int32](repeating: 0, count: 16384)
    var fvecmeas: Float = 0
    var baseheight: Float = 0
    var branchDistance: Float = 0
    var maxDistFactor: Float = 256
    var a = vec3_t()
    var startplace = vec3_t()
    var starttrace = vec3_t()
    var mins = vec3_t()
    var maxs = vec3_t()
    var testspot = vec3_t()
    var validspotpos = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Int32 in

        if g_RMG.integer != 0 {
            //this might be temporary. Or not.
            if !((gWPArray[startindex]!.flags & WPFLAG_NEVERONEWAY) != 0) && !((gWPArray[endindex]!.flags & WPFLAG_NEVERONEWAY) != 0) {
                gWPArray[startindex]!.flags |= WPFLAG_ONEWAY_FWD
                gWPArray[endindex]!.flags |= WPFLAG_ONEWAY_BACK
            }
            return 0
        }

        if g_RMG.integer == 0 {
            branchDistance = Float(TABLE_BRANCH_DISTANCE)
        } else {
            branchDistance = 512 //be less precise here, terrain is fairly broad, and we don't want to take an hour precalculating
        }

        if g_RMG.integer != 0 {
            maxDistFactor = 700
        }

        mins[0] = -15
        mins[1] = -15
        mins[2] = 0
        maxs[0] = 15
        maxs[1] = 15
        maxs[2] = 0

        nodenum = 0
        foundit = 0

        i = 0

        successnodeindex = 0

        while i < MAX_NODETABLE_SIZE {
            nodetable[i].flags = 0
            //		nodetable[i].index = 0;
            nodetable[i].inuse = 0
            nodetable[i].neighbornum = 0
            nodetable[i].origin[0] = 0
            nodetable[i].origin[1] = 0
            nodetable[i].origin[2] = 0
            nodetable[i].weight = 0

            extendednodes[i] = 0

            i += 1
        }

        i = 0

        if !behindTheScenes {
            G_Printf(S_COLOR_YELLOW + "Point %i is not connected to %i - Repairing...\n", startindex, endindex)
        }

        startplace = gWPArray[startindex]!.origin

        starttrace = startplace

        starttrace[2] -= 4096

        // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
        portMissing("ConnectTrail", source: "oracle/codemp/game/ai_wpnav.c:1000")
        // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
        portMissing("ConnectTrail", source: "oracle/codemp/game/ai_wpnav.c:1000")
        trap_Trace(tr, startplace, vec3_origin, vec3_origin, starttrace, ENTITYNUM_NONE, MASK_SOLID)

        baseheight = startplace[2] - tr.endpos[2]

        cancontinue = 1

        nodetable[nodenum].origin = startplace
        nodetable[nodenum].weight = 1
        nodetable[nodenum].inuse = 1
        //	nodetable[nodenum].index = nodenum;
        nodenum += 1

        while nodenum < MAX_NODETABLE_SIZE && foundit == 0 && cancontinue != 0 {
            if g_RMG.integer != 0 {
                //adjust the branch distance dynamically depending on the distance from the start and end points.
                var startDist = vec3_t()
                var endDist = vec3_t()
                var startDistf: Float = 0
                var endDistf: Float = 0

                startDist = nodetable[nodenum - 1].origin - gWPArray[startindex]!.origin
                endDist = nodetable[nodenum - 1].origin - gWPArray[endindex]!.origin

                startDistf = VectorLength(startDist)
                endDistf = VectorLength(endDist)

                if startDistf < 64 || endDistf < 64 {
                    branchDistance = 64
                } else if startDistf < 128 || endDistf < 128 {
                    branchDistance = 128
                } else if startDistf < 256 || endDistf < 256 {
                    branchDistance = 256
                } else if startDistf < 512 || endDistf < 512 {
                    branchDistance = 512
                } else {
                    branchDistance = 800
                }
            }
            cancontinue = 0
            i = 0
            prenodestart = nodenum

            while i < prenodestart {
                if extendednodes[i] != 1 {
                    a = gWPArray[endindex]!.origin - nodetable[i].origin
                    fvecmeas = VectorLength(a)

                    if fvecmeas < 128 && CanGetToVector(gWPArray[endindex]!.origin, nodetable[i].origin, mins, maxs) != 0 {
                        foundit = 1
                        successnodeindex = i
                        break
                    }

                    testspot = nodetable[i].origin
                    testspot[0] += branchDistance

                    starttrace = testspot

                    starttrace[2] -= 4096

                    // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
                    portMissing("ConnectTrail", source: "oracle/codemp/game/ai_wpnav.c:1000")
                    // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
                    portMissing("ConnectTrail", source: "oracle/codemp/game/ai_wpnav.c:1000")
                    trap_Trace(tr, testspot, vec3_origin, vec3_origin, starttrace, ENTITYNUM_NONE, MASK_SOLID)

                    testspot[2] = tr.endpos[2] + baseheight

                    if NodeHere(testspot) == 0 && tr.startsolid == 0 && tr.allsolid == 0 && CanGetToVector(nodetable[i].origin, testspot, mins, maxs) != 0 {
                        nodetable[nodenum].origin = testspot
                        nodetable[nodenum].inuse = 1
                        //					nodetable[nodenum].index = nodenum;
                        nodetable[nodenum].weight = nodetable[i].weight + 1
                        nodetable[nodenum].neighbornum = i
                        if (nodetable[i].origin[2] - nodetable[nodenum].origin[2]) > 50 {
                            //if there's a big drop, make sure we know we can't just magically fly back up
                            nodetable[nodenum].flags = WPFLAG_ONEWAY_FWD
                        }
                        nodenum += 1
                        cancontinue = 1
                    }

                    if nodenum >= MAX_NODETABLE_SIZE {
                        break //failure
                    }

                    testspot = nodetable[i].origin
                    testspot[0] -= branchDistance

                    starttrace = testspot

                    starttrace[2] -= 4096

                    // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
                    portMissing("ConnectTrail", source: "oracle/codemp/game/ai_wpnav.c:1000")
                    // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
                    portMissing("ConnectTrail", source: "oracle/codemp/game/ai_wpnav.c:1000")
                    trap_Trace(tr, testspot, vec3_origin, vec3_origin, starttrace, ENTITYNUM_NONE, MASK_SOLID)

                    testspot[2] = tr.endpos[2] + baseheight

                    if NodeHere(testspot) == 0 && tr.startsolid == 0 && tr.allsolid == 0 && CanGetToVector(nodetable[i].origin, testspot, mins, maxs) != 0 {
                        nodetable[nodenum].origin = testspot
                        nodetable[nodenum].inuse = 1
                        //					nodetable[nodenum].index = nodenum;
                        nodetable[nodenum].weight = nodetable[i].weight + 1
                        nodetable[nodenum].neighbornum = i
                        if (nodetable[i].origin[2] - nodetable[nodenum].origin[2]) > 50 {
                            //if there's a big drop, make sure we know we can't just magically fly back up
                            nodetable[nodenum].flags = WPFLAG_ONEWAY_FWD
                        }
                        nodenum += 1
                        cancontinue = 1
                    }

                    if nodenum >= MAX_NODETABLE_SIZE {
                        break //failure
                    }

                    testspot = nodetable[i].origin
                    testspot[1] += branchDistance

                    starttrace = testspot

                    starttrace[2] -= 4096

                    // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
                    portMissing("ConnectTrail", source: "oracle/codemp/game/ai_wpnav.c:1000")
                    // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
                    portMissing("ConnectTrail", source: "oracle/codemp/game/ai_wpnav.c:1000")
                    trap_Trace(tr, testspot, vec3_origin, vec3_origin, starttrace, ENTITYNUM_NONE, MASK_SOLID)

                    testspot[2] = tr.endpos[2] + baseheight

                    if NodeHere(testspot) == 0 && tr.startsolid == 0 && tr.allsolid == 0 && CanGetToVector(nodetable[i].origin, testspot, mins, maxs) != 0 {
                        nodetable[nodenum].origin = testspot
                        nodetable[nodenum].inuse = 1
                        //					nodetable[nodenum].index = nodenum;
                        nodetable[nodenum].weight = nodetable[i].weight + 1
                        nodetable[nodenum].neighbornum = i
                        if (nodetable[i].origin[2] - nodetable[nodenum].origin[2]) > 50 {
                            //if there's a big drop, make sure we know we can't just magically fly back up
                            nodetable[nodenum].flags = WPFLAG_ONEWAY_FWD
                        }
                        nodenum += 1
                        cancontinue = 1
                    }

                    if nodenum >= MAX_NODETABLE_SIZE {
                        break //failure
                    }

                    testspot = nodetable[i].origin
                    testspot[1] -= branchDistance

                    starttrace = testspot

                    starttrace[2] -= 4096

                    // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
                    portMissing("ConnectTrail", source: "oracle/codemp/game/ai_wpnav.c:1000")
                    // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
                    portMissing("ConnectTrail", source: "oracle/codemp/game/ai_wpnav.c:1000")
                    trap_Trace(tr, testspot, vec3_origin, vec3_origin, starttrace, ENTITYNUM_NONE, MASK_SOLID)

                    testspot[2] = tr.endpos[2] + baseheight

                    if NodeHere(testspot) == 0 && tr.startsolid == 0 && tr.allsolid == 0 && CanGetToVector(nodetable[i].origin, testspot, mins, maxs) != 0 {
                        nodetable[nodenum].origin = testspot
                        nodetable[nodenum].inuse = 1
                        //					nodetable[nodenum].index = nodenum;
                        nodetable[nodenum].weight = nodetable[i].weight + 1
                        nodetable[nodenum].neighbornum = i
                        if (nodetable[i].origin[2] - nodetable[nodenum].origin[2]) > 50 {
                            //if there's a big drop, make sure we know we can't just magically fly back up
                            nodetable[nodenum].flags = WPFLAG_ONEWAY_FWD
                        }
                        nodenum += 1
                        cancontinue = 1
                    }

                    if nodenum >= MAX_NODETABLE_SIZE {
                        break //failure
                    }

                    extendednodes[i] = 1
                }

                i += 1
            }
        }

        if foundit == 0 {
            if !behindTheScenes {
                G_Printf(S_COLOR_RED + "Could not link %i to %i, unreachable by node branching.\n", startindex, endindex)
            }
            gWPArray[startindex]!.flags |= WPFLAG_ONEWAY_FWD
            gWPArray[endindex]!.flags |= WPFLAG_ONEWAY_BACK
            if !behindTheScenes {
                G_Printf(S_COLOR_YELLOW + "Since points cannot be connected, point %i has been flagged as only-forward and point %i has been flagged as only-backward.\n", startindex, endindex)
            }

            /*while (nodenum >= 0)
            {
            if (nodetable[nodenum].origin[0] || nodetable[nodenum].origin[1] || nodetable[nodenum].origin[2])
            {
            CreateNewWP(nodetable[nodenum].origin, nodetable[nodenum].flags);
            }

            nodenum--;
            }*/
            //The above code transfers nodes into the "rendered" waypoint array. Strictly for debugging.

            if !behindTheScenes {
                //just use what we have if we're auto-pathing the level
                return 0
            } else {
                var endDist = vec3_t()
                var nCount: Int32 = 0
                var idealNode: Int32 = -1
                var bestDist: Float = 0
                var testDist: Float = 0

                if nodenum <= 10 {
                    //not enough to even really bother.
                    return 0
                }

                //Since it failed, find whichever node is closest to the desired end.
                while nCount < nodenum {
                    endDist = nodetable[nCount].origin - gWPArray[endindex]!.origin
                    testDist = VectorLength(endDist)
                    if idealNode == -1 {
                        idealNode = nCount
                        bestDist = testDist
                        nCount += 1
                        continue
                    }

                    if testDist < bestDist {
                        idealNode = nCount
                        bestDist = testDist
                    }

                    nCount += 1
                }

                if idealNode == -1 {
                    return 0
                }

                successnodeindex = idealNode
            }
        }

        i = successnodeindex
        insertindex = startindex
        failsafe = 0
        validspotpos = gWPArray[startindex]!.origin

        while failsafe < MAX_NODETABLE_SIZE && i < MAX_NODETABLE_SIZE && i >= 0 {
            a = validspotpos - nodetable[i].origin
            if nodetable[nodetable[i].neighbornum].inuse == 0 || CanGetToVectorTravel(validspotpos, nodetable[i].origin, mins, maxs) == 0 || VectorLength(a) > maxDistFactor || (CanGetToVectorTravel(validspotpos, gWPArray[endindex]!.origin, mins, maxs) == 0 && CanGetToVectorTravel(nodetable[i].origin, gWPArray[endindex]!.origin, mins, maxs) != 0) {
                nodetable[i].flags |= WPFLAG_CALCULATED
                if CreateNewWP_InTrail(nodetable[i].origin, nodetable[i].flags, insertindex) == 0 {
                    if !behindTheScenes {
                        G_Printf(S_COLOR_RED + "Could not link %i to %i, waypoint limit hit.\n", startindex, endindex)
                    }
                    return 0
                }

                validspotpos = nodetable[i].origin
            }

            if i == 0 {
                break
            }

            i = nodetable[i].neighbornum

            failsafe += 1
        }

        if !behindTheScenes {
            G_Printf(S_COLOR_YELLOW + "Finished connecting %i to %i.\n", startindex, endindex)
        }

        return 1
    }
}

/// Source: oracle/codemp/game/ai_wpnav.c:1402
func OpposingEnds(_ start: Int32, _ end: Int32) -> Int32 {
    if gWPArray[start] == nil || gWPArray[start]!.inuse == 0 || gWPArray[end] == nil || gWPArray[end]!.inuse == 0 {
        return 0
    }

    if (gWPArray[start]!.flags & WPFLAG_ONEWAY_FWD) != 0 && (gWPArray[end]!.flags & WPFLAG_ONEWAY_BACK) != 0 {
        return 1
    }

    return 0
}

/// Source: oracle/codemp/game/ai_wpnav.c:1418
func DoorBlockingSection(_ start: Int32, _ end: Int32) -> Int32 {
    //if a door blocks the trail, we'll just have to assume the points on each side are in visibility when it's open
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Int32 in
        var testdoor: Entity?
        var start_trace_index: Int32 = 0

        if gWPArray[start] == nil || gWPArray[start]!.inuse == 0 || gWPArray[end] == nil || gWPArray[end]!.inuse == 0 {
            return 0
        }

        // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
        portMissing("DoorBlockingSection", source: "oracle/codemp/game/ai_wpnav.c:1418")
        // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
        portMissing("DoorBlockingSection", source: "oracle/codemp/game/ai_wpnav.c:1418")
        trap_Trace(tr, gWPArray[start]!.origin, vec3_origin, vec3_origin, gWPArray[end]!.origin, ENTITYNUM_NONE, MASK_SOLID)

        if tr.fraction == 1 {
            return 0
        }

        testdoor = g_entities[tr.entityNum]

        if testdoor == nil {
            return 0
        }

        if strstr(testdoor!.classname!, "func_") == nil {
            return 0
        }

        start_trace_index = tr.entityNum

        // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
        portMissing("DoorBlockingSection", source: "oracle/codemp/game/ai_wpnav.c:1418")
        // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
        portMissing("DoorBlockingSection", source: "oracle/codemp/game/ai_wpnav.c:1418")
        trap_Trace(tr, gWPArray[end]!.origin, vec3_origin, vec3_origin, gWPArray[start]!.origin, ENTITYNUM_NONE, MASK_SOLID)

        if tr.fraction == 1 {
            return 0
        }

        if start_trace_index == tr.entityNum {
            return 1
        }

        return 0
    }
}

/// Source: oracle/codemp/game/ai_wpnav.c:1466
func RepairPaths(_ behindTheScenes: Bool) -> Int32 {
    var i: Int32
    var preAmount: Int32 = 0
    var ctRet: Int32
    var a = vec3_t()
    var maxDistFactor: Float = 400

    if gWPNum == 0 {
        return 0
    }

    if g_RMG.integer != 0 {
        maxDistFactor = 800 //higher tolerance here.
    }

    i = 0

    preAmount = gWPNum

    trap_Cvar_Update(bot_wp_distconnect)
    trap_Cvar_Update(bot_wp_visconnect)

    while i < gWPNum {
        if gWPArray[i] != nil && gWPArray[i]!.inuse != 0 && gWPArray[i + 1] != nil && gWPArray[i + 1]!.inuse != 0 {
            a = gWPArray[i]!.origin - gWPArray[i + 1]!.origin

            if !((gWPArray[i + 1]!.flags & WPFLAG_NOVIS) != 0) && !((gWPArray[i + 1]!.flags & WPFLAG_JUMP) != 0) && !((gWPArray[i]!.flags & WPFLAG_CALCULATED) != 0) && OpposingEnds(i, i + 1) == 0 && ((bot_wp_distconnect.value != 0 && VectorLength(a) > maxDistFactor) || (OrgVisible(gWPArray[i]!.origin, gWPArray[i + 1]!.origin, ENTITYNUM_NONE) == 0 && bot_wp_visconnect.value != 0)) && DoorBlockingSection(i, i + 1) == 0 {
                ctRet = ConnectTrail(i, i + 1, behindTheScenes)

                if gWPNum >= MAX_WPARRAY_SIZE {
                    //Bad!
                    gWPNum = MAX_WPARRAY_SIZE
                    break
                }

                /*if (!ctRet)
                {
                return 0;
                }*/
            }
        }

        i += 1
    }

    return 1
}

/// Source: oracle/codemp/game/ai_wpnav.c:1526
func OrgVisibleCurve(_ org1: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ org2: JKAShared.vec3_t, _ ignore: Int32) -> Int32 {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Int32 in
        var evenorg1 = vec3_t()

        evenorg1 = org1
        evenorg1[2] = org2[2]

        trap_Trace(tr, evenorg1, mins, maxs, org2, ignore, MASK_SOLID)

        if tr.fraction == 1 && tr.startsolid == 0 && tr.allsolid == 0 {
            trap_Trace(tr, evenorg1, mins, maxs, org1, ignore, MASK_SOLID)

            if tr.fraction == 1 && tr.startsolid == 0 && tr.allsolid == 0 {
                return 1
            }
        }

        return 0
    }
}

/// Source: oracle/codemp/game/ai_wpnav.c:1549
func CanForceJumpTo(_ baseindex: Int32, _ testingindex: Int32, _ distance: Float) -> Int32 {
    let heightdif: Float
    var xy_base = vec3_t()
    var xy_test = vec3_t()
    var v = vec3_t()
    var mins = vec3_t()
    var maxs = vec3_t()
    let wpBase: Wpobject? = gWPArray[baseindex]
    let wpTest: Wpobject? = gWPArray[testingindex]

    mins[0] = -15
    mins[1] = -15
    mins[2] = -15 //-1
    maxs[0] = 15
    maxs[1] = 15
    maxs[2] = 15 //1

    if wpBase == nil || wpBase!.inuse == 0 || wpTest == nil || wpTest!.inuse == 0 {
        return 0
    }

    if distance > 400 {
        return 0
    }

    xy_base = wpBase!.origin
    xy_test = wpTest!.origin

    xy_base[2] = xy_test[2]

    v = xy_base - xy_test

    if VectorLength(v) > MAX_NEIGHBOR_LINK_DISTANCE {
        return 0
    }

    if Int32(wpBase!.origin[2]) < Int32(wpTest!.origin[2]) {
        heightdif = wpTest!.origin[2] - wpBase!.origin[2]
    } else {
        return 0 //err..
    }

    if heightdif < 128 {
        //don't bother..
        return 0
    }

    if heightdif > 512 {
        //too high
        return 0
    }

    if OrgVisibleCurve(wpBase!.origin, mins, maxs, wpTest!.origin, ENTITYNUM_NONE) == 0 {
        return 0
    }

    if heightdif > 400 {
        return 3
    } else if heightdif > 256 {
        return 2
    } else {
        return 1
    }
}

/// Source: oracle/codemp/game/ai_wpnav.c:1623
func CalculatePaths() {
    var i: Int32
    var c: Int32
    var forceJumpable: Int32
    var maxNeighborDist: Int32 = MAX_NEIGHBOR_LINK_DISTANCE
    var nLDist: Float
    var a = vec3_t()
    var mins = vec3_t()
    var maxs = vec3_t()

    if gWPNum == 0 {
        return
    }

    if g_RMG.integer != 0 {
        maxNeighborDist = Int32(Double(DEFAULT_GRID_SPACING) + (Double(DEFAULT_GRID_SPACING) * 0.5))
    }

    mins[0] = -15
    mins[1] = -15
    mins[2] = -15 //-1
    maxs[0] = 15
    maxs[1] = 15
    maxs[2] = 15 //1

    //now clear out all the neighbor data before we recalculate
    i = 0

    while i < gWPNum {
        if gWPArray[i] != nil && gWPArray[i]!.inuse != 0 && gWPArray[i]!.neighbornum != 0 {
            while gWPArray[i]!.neighbornum >= 0 {
                gWPArray[i]!.neighbors[gWPArray[i]!.neighbornum].num = 0
                gWPArray[i]!.neighbors[gWPArray[i]!.neighbornum].forceJumpTo = 0
                gWPArray[i]!.neighbornum -= 1
            }
            gWPArray[i]!.neighbornum = 0
        }

        i += 1
    }

    i = 0

    while i < gWPNum {
        if gWPArray[i] != nil && gWPArray[i]!.inuse != 0 {
            c = 0

            while c < gWPNum {
                if gWPArray[c] != nil && gWPArray[c]!.inuse != 0 && i != c && NotWithinRange(i, c) != 0 {
                    a = gWPArray[i]!.origin - gWPArray[c]!.origin

                    nLDist = VectorLength(a)
                    forceJumpable = CanForceJumpTo(i, c, nLDist)

                    if (nLDist < maxNeighborDist || forceJumpable != 0) && (Int32(gWPArray[i]!.origin[2]) == Int32(gWPArray[c]!.origin[2]) || forceJumpable != 0) && (OrgVisibleBox(gWPArray[i]!.origin, mins, maxs, gWPArray[c]!.origin, ENTITYNUM_NONE) != 0 || forceJumpable != 0) {
                        gWPArray[i]!.neighbors[gWPArray[i]!.neighbornum].num = c
                        if forceJumpable != 0 && (Int32(gWPArray[i]!.origin[2]) != Int32(gWPArray[c]!.origin[2]) || nLDist < maxNeighborDist) {
                            gWPArray[i]!.neighbors[gWPArray[i]!.neighbornum].forceJumpTo = 999 //forceJumpable; //FJSR
                        } else {
                            gWPArray[i]!.neighbors[gWPArray[i]!.neighbornum].forceJumpTo = 0
                        }
                        gWPArray[i]!.neighbornum += 1
                    }

                    if gWPArray[i]!.neighbornum >= MAX_NEIGHBOR_SIZE {
                        break
                    }
                }
                c += 1
            }
        }
        i += 1
    }
}

/// Source: oracle/codemp/game/ai_wpnav.c:1715
func GetObjectThatTargets(_ ent: Entity) -> Entity? {
    var next: Entity? = nil

    if ent.targetname == nil {
        return nil
    }

    // Port-note: No operator beside the operand, the text there is ``.
    // Raven wrote: next = G_Find( next, FOFS(target), ent->targetname )
    portMissing("GetObjectThatTargets", source: "oracle/codemp/game/ai_wpnav.c:1715")

    if next != nil {
        return next
    }

    return nil
}

/// Source: oracle/codemp/game/ai_wpnav.c:1734
func CalculateSiegeGoals() {
    var i: Int32 = 0
    var looptracker: Int32 = 0
    var wpindex: Int32 = 0
    var dif = vec3_t()
    var ent: Entity?
    var tent: Entity? = nil
    var t2ent: Entity? = nil

    while i < level.num_entities {
        ent = g_entities[i]

        tent = nil

        if ent != nil && ent!.classname != nil && strcmp(ent!.classname!, "info_siege_objective") == 0 {
            tent = ent
            t2ent = GetObjectThatTargets(tent!)
            looptracker = 0

            while t2ent != nil && looptracker < 2048 {
                //looptracker keeps us from getting stuck in case something is set up weird on this map
                tent = t2ent
                t2ent = GetObjectThatTargets(tent!)
                looptracker += 1
            }

            if looptracker >= 2048 {
                //something unpleasent has happened
                tent = nil
                break
            }
        }

        if tent != nil && ent != nil && tent != ent {
            //tent should now be the object attached to the mission objective
            dif[0] = (tent!.r.absmax[0] + tent!.r.absmin[0]) / 2
            dif[1] = (tent!.r.absmax[1] + tent!.r.absmin[1]) / 2
            dif[2] = (tent!.r.absmax[2] + tent!.r.absmin[2]) / 2

            wpindex = GetNearestVisibleWP(dif, tent!.s.number)

            if wpindex != -1 && gWPArray[wpindex] != nil && gWPArray[wpindex]!.inuse != 0 {
                //found the waypoint nearest the center of this objective-related object
                if ent!.side == SIEGETEAM_TEAM1 {
                    gWPArray[wpindex]!.flags |= WPFLAG_SIEGE_IMPERIALOBJ
                } else {
                    gWPArray[wpindex]!.flags |= WPFLAG_SIEGE_REBELOBJ
                }

                gWPArray[wpindex]!.associated_entity = tent!.s.number
            }
        }

        i += 1
    }
}

/// Source: oracle/codemp/game/ai_wpnav.c:1817
func GetNearestVisibleWPToItem(_ org: JKAShared.vec3_t, _ ignore: Int32) -> Int32 {
    var i: Int32
    var bestdist: Float
    var flLen: Float
    var bestindex: Int32
    var a = vec3_t()
    var mins = vec3_t()
    var maxs = vec3_t()

    i = 0
    bestdist = 64 //has to be less than 64 units to the item or it isn't safe enough
    bestindex = -1

    mins[0] = -15
    mins[1] = -15
    mins[2] = 0
    maxs[0] = 15
    maxs[1] = 15
    maxs[2] = 0

    while i < gWPNum {
        if gWPArray[i] != nil && gWPArray[i]!.inuse != 0 && gWPArray[i]!.origin[2] - 15 < org[2] && gWPArray[i]!.origin[2] + 15 > org[2] {
            a = org - gWPArray[i]!.origin
            flLen = VectorLength(a)

            if flLen < bestdist && trap_InPVS(org, gWPArray[i]!.origin) && OrgVisibleBox(org, mins, maxs, gWPArray[i]!.origin, ignore) != 0 {
                bestdist = flLen
                bestindex = i
            }
        }

        i += 1
    }

    return bestindex
}

/// Source: oracle/codemp/game/ai_wpnav.c:1858
func CalculateWeightGoals() {
    //set waypoint weights depending on weapon and item placement
    var i: Int32 = 0
    var wpindex: Int32 = 0
    var ent: Entity?
    var weight: Float

    trap_Cvar_Update(bot_wp_clearweight)

    if bot_wp_clearweight.integer != 0 {
        //if set then flush out all weight/goal values before calculating them again
        while i < gWPNum {
            if gWPArray[i] != nil && gWPArray[i]!.inuse != 0 {
                gWPArray[i]!.weight = 0

                if (gWPArray[i]!.flags & WPFLAG_GOALPOINT) != 0 {
                    gWPArray[i]!.flags -= WPFLAG_GOALPOINT
                }
            }

            i += 1
        }
    }

    i = 0

    while i < level.num_entities {
        ent = g_entities[i]

        weight = 0

        if ent != nil && ent!.classname != nil {
            if strcmp(ent!.classname!, "item_seeker") == 0 {
                weight = 2
            } else if strcmp(ent!.classname!, "item_shield") == 0 {
                weight = 2
            } else if strcmp(ent!.classname!, "item_medpac") == 0 {
                weight = 2
            } else if strcmp(ent!.classname!, "item_sentry_gun") == 0 {
                weight = 2
            } else if strcmp(ent!.classname!, "item_force_enlighten_dark") == 0 {
                weight = 5
            } else if strcmp(ent!.classname!, "item_force_enlighten_light") == 0 {
                weight = 5
            } else if strcmp(ent!.classname!, "item_force_boon") == 0 {
                weight = 5
            } else if strcmp(ent!.classname!, "item_ysalimari") == 0 {
                weight = 2
            } else if strstr(ent!.classname!, "weapon_") != nil && ent!.item != nil {
                weight = botGlobalNavWeaponWeights[ent!.item!.giTag]
            } else if ent!.item != nil && ent!.item!.giType == IT_AMMO {
                weight = 3
            }
        }

        if ent != nil && weight != 0 {
            wpindex = GetNearestVisibleWPToItem(ent!.s.pos.trBase, ent!.s.number)

            if wpindex != -1 && gWPArray[wpindex] != nil && gWPArray[wpindex]!.inuse != 0 {
                //found the waypoint nearest the center of this object
                gWPArray[wpindex]!.weight = weight
                gWPArray[wpindex]!.flags |= WPFLAG_GOALPOINT
                gWPArray[wpindex]!.associated_entity = ent!.s.number
            }
        }

        i += 1
    }
}

/// Source: oracle/codemp/game/ai_wpnav.c:1953
func CalculateJumpRoutes() {
    var i: Int32 = 0
    var nheightdif: Float = 0
    var pheightdif: Float = 0

    while i < gWPNum {
        if gWPArray[i] != nil && gWPArray[i]!.inuse != 0 {
            if (gWPArray[i]!.flags & WPFLAG_JUMP) != 0 {
                nheightdif = 0
                pheightdif = 0

                gWPArray[i]!.forceJumpTo = 0

                if gWPArray[i - 1] != nil && gWPArray[i - 1]!.inuse != 0 && (gWPArray[i - 1]!.origin[2] + 16) < gWPArray[i]!.origin[2] {
                    nheightdif = (gWPArray[i]!.origin[2] - gWPArray[i - 1]!.origin[2])
                }

                if gWPArray[i + 1] != nil && gWPArray[i + 1]!.inuse != 0 && (gWPArray[i + 1]!.origin[2] + 16) < gWPArray[i]!.origin[2] {
                    pheightdif = (gWPArray[i]!.origin[2] - gWPArray[i + 1]!.origin[2])
                }

                if nheightdif > pheightdif {
                    pheightdif = nheightdif
                }

                if pheightdif != 0 {
                    if pheightdif > 500 {
                        gWPArray[i]!.forceJumpTo = 999 //FORCE_LEVEL_3; //FJSR
                    } else if pheightdif > 256 {
                        gWPArray[i]!.forceJumpTo = 999 //FORCE_LEVEL_2; //FJSR
                    } else if pheightdif > 128 {
                        gWPArray[i]!.forceJumpTo = 999 //FORCE_LEVEL_1; //FJSR
                    }
                }
            }
        }

        i += 1
    }
}

/// Source: oracle/codemp/game/ai_wpnav.c:2007
func LoadPathData(_ filename: String) -> Int32 {
    var f: fileHandle_t = 0
    var fileString = CharBuf(524288)
    var currentVar = CharBuf(2048)
    var routePath = CharBuf(1024)
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Wpobject.scratch { thiswp -> Int32 in
        var len: Int32 = 0
        var i: Int32 = 0
        var i_cv: Int32 = 0
        var nei_num: Int32 = 0

        i = 0
        i_cv = 0

        _ = B_TempAlloc(1024)

        Com_sprintf(&routePath, 1024, "botroutes/%s.wnt\0", filename)

        len = trap_FS_FOpenFile(String(routePath), &f, FS_READ)

        B_TempFree(1024) //routePath

        if f == 0 {
            G_Printf(S_COLOR_YELLOW + "Bot route data not found for %s\n", filename)
            return 2
        }

        if len >= 524288 {
            G_Printf(S_COLOR_RED + "Route file exceeds maximum length\n")
            return 0
        }

        _ = B_TempAlloc(524288)
        _ = B_TempAlloc(2048)

        trap_FS_Read(&fileString, len, f)

        if fileString[i] == Int32(ascii: "l") {
            //contains a "levelflags" entry..
            var readLFlags = CharBuf(64)
            i_cv = 0

            while fileString[i] != Int32(ascii: " ") {
                i += 1
            }
            i += 1
            while fileString[i] != Int32(ascii: "\n") {
                readLFlags[i_cv] = fileString[i]
                i_cv += 1
                i += 1
            }
            readLFlags[i_cv] = 0
            i += 1

            gLevelFlags = atoi(readLFlags)
        } else {
            gLevelFlags = 0
        }

        while i < len {
            i_cv = 0

            thiswp.index = 0
            thiswp.flags = 0
            thiswp.inuse = 0
            thiswp.neighbornum = 0
            thiswp.origin[0] = 0
            thiswp.origin[1] = 0
            thiswp.origin[2] = 0
            thiswp.weight = 0
            thiswp.associated_entity = ENTITYNUM_NONE
            thiswp.forceJumpTo = 0
            thiswp.disttonext = 0
            nei_num = 0

            while nei_num < MAX_NEIGHBOR_SIZE {
                thiswp.neighbors[nei_num].num = 0
                thiswp.neighbors[nei_num].forceJumpTo = 0

                nei_num += 1
            }

            while fileString[i] != Int32(ascii: " ") {
                currentVar[i_cv] = fileString[i]
                i_cv += 1
                i += 1
            }
            currentVar[i_cv] = 0

            thiswp.index = atoi(currentVar)

            i_cv = 0
            i += 1

            while fileString[i] != Int32(ascii: " ") {
                currentVar[i_cv] = fileString[i]
                i_cv += 1
                i += 1
            }
            currentVar[i_cv] = 0

            thiswp.flags = atoi(currentVar)

            i_cv = 0
            i += 1

            while fileString[i] != Int32(ascii: " ") {
                currentVar[i_cv] = fileString[i]
                i_cv += 1
                i += 1
            }
            currentVar[i_cv] = 0

            thiswp.weight = atof(currentVar)

            i_cv = 0
            i += 1
            i += 1

            while fileString[i] != Int32(ascii: " ") {
                currentVar[i_cv] = fileString[i]
                i_cv += 1
                i += 1
            }
            currentVar[i_cv] = 0

            thiswp.origin[0] = atof(currentVar)

            i_cv = 0
            i += 1

            while fileString[i] != Int32(ascii: " ") {
                currentVar[i_cv] = fileString[i]
                i_cv += 1
                i += 1
            }
            currentVar[i_cv] = 0

            thiswp.origin[1] = atof(currentVar)

            i_cv = 0
            i += 1

            while fileString[i] != Int32(ascii: ")") {
                currentVar[i_cv] = fileString[i]
                i_cv += 1
                i += 1
            }
            currentVar[i_cv] = 0

            thiswp.origin[2] = atof(currentVar)

            i += 4

            while fileString[i] != Int32(ascii: "}") {
                i_cv = 0
                while fileString[i] != Int32(ascii: " ") && fileString[i] != Int32(ascii: "-") {
                    currentVar[i_cv] = fileString[i]
                    i_cv += 1
                    i += 1
                }
                currentVar[i_cv] = 0

                thiswp.neighbors[thiswp.neighbornum].num = atoi(currentVar)

                if fileString[i] == Int32(ascii: "-") {
                    i_cv = 0
                    i += 1

                    while fileString[i] != Int32(ascii: " ") {
                        currentVar[i_cv] = fileString[i]
                        i_cv += 1
                        i += 1
                    }
                    currentVar[i_cv] = 0

                    thiswp.neighbors[thiswp.neighbornum].forceJumpTo = 999 //atoi(currentVar); //FJSR
                } else {
                    thiswp.neighbors[thiswp.neighbornum].forceJumpTo = 0
                }

                thiswp.neighbornum += 1

                i += 1
            }

            i_cv = 0
            i += 1
            i += 1

            while fileString[i] != Int32(ascii: "\n") {
                currentVar[i_cv] = fileString[i]
                i_cv += 1
                i += 1
            }
            currentVar[i_cv] = 0

            thiswp.disttonext = atof(currentVar)

            CreateNewWP_FromObject(thiswp)
            i += 1
        }

        B_TempFree(524288) //fileString
        B_TempFree(2048) //currentVar

        trap_FS_FCloseFile(f)

        if g_gametype.integer == GT_SIEGE {
            CalculateSiegeGoals()
        }

        CalculateWeightGoals()
        //calculate weights for idle activity goals when
        //the bot has absolutely nothing else to do

        CalculateJumpRoutes()
        //Look at jump points and mark them as requiring
        //force jumping as needed

        return 1
    }
}

/// Source: oracle/codemp/game/ai_wpnav.c:2252
func FlagObjects() {
    var i: Int32 = 0
    var bestindex: Int32 = 0
    var found: Int32 = 0
    var bestdist: Float = 999999
    var tlen: Float = 0
    var flag_red: Entity?
    var flag_blue: Entity?
    var ent: Entity?
    var a = vec3_t()
    var mins = vec3_t()
    var maxs = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in

        flag_red = nil
        flag_blue = nil

        mins[0] = -15
        mins[1] = -15
        mins[2] = -5
        maxs[0] = 15
        maxs[1] = 15
        maxs[2] = 5

        while i < level.num_entities {
            ent = g_entities[i]

            if ent != nil && ent!.inuse && ent!.classname != nil {
                if flag_red == nil && strcmp(ent!.classname!, "team_CTF_redflag") == 0 {
                    flag_red = ent
                } else if flag_blue == nil && strcmp(ent!.classname!, "team_CTF_blueflag") == 0 {
                    flag_blue = ent
                }

                if flag_red != nil && flag_blue != nil {
                    break
                }
            }

            i += 1
        }

        i = 0

        if flag_red == nil || flag_blue == nil {
            return true
        }

        while i < gWPNum {
            if gWPArray[i] != nil && gWPArray[i]!.inuse != 0 {
                a = flag_red!.s.pos.trBase - gWPArray[i]!.origin
                tlen = VectorLength(a)

                if tlen < bestdist {
                    trap_Trace(tr, flag_red!.s.pos.trBase, mins, maxs, gWPArray[i]!.origin, flag_red!.s.number, MASK_SOLID)

                    if tr.fraction == 1 || tr.entityNum == flag_red!.s.number {
                        bestdist = tlen
                        bestindex = i
                        found = 1
                    }
                }
            }

            i += 1
        }

        if found != 0 {
            gWPArray[bestindex]!.flags |= WPFLAG_RED_FLAG
            flagRed = gWPArray[bestindex]
            oFlagRed = flagRed
            eFlagRed = flag_red
        }

        bestdist = 999999
        bestindex = 0
        found = 0
        i = 0

        while i < gWPNum {
            if gWPArray[i] != nil && gWPArray[i]!.inuse != 0 {
                a = flag_blue!.s.pos.trBase - gWPArray[i]!.origin
                tlen = VectorLength(a)

                if tlen < bestdist {
                    trap_Trace(tr, flag_blue!.s.pos.trBase, mins, maxs, gWPArray[i]!.origin, flag_blue!.s.number, MASK_SOLID)

                    if tr.fraction == 1 || tr.entityNum == flag_blue!.s.number {
                        bestdist = tlen
                        bestindex = i
                        found = 1
                    }
                }
            }

            i += 1
        }

        if found != 0 {
            gWPArray[bestindex]!.flags |= WPFLAG_BLUE_FLAG
            flagBlue = gWPArray[bestindex]
            oFlagBlue = flagBlue
            eFlagBlue = flag_blue
        }
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/game/ai_wpnav.c:2372
func SavePathData(_ filename: String) -> Int32 {
    var f: fileHandle_t = 0
    // Port-note: A pointer local `char * fileString` with no view.
    // Raven wrote: char *fileString;
    portMissing("SavePathData", source: "oracle/codemp/game/ai_wpnav.c:2372")
    var storeString = CharBuf(4096)
    var routePath = CharBuf(1024)
    var a = vec3_t()
    var flLen: Float
    var i: Int32
    let s: Int32
    var n: Int32

    // Port-note: A store into `fileString`, a local the draft left as a hole.
    // Raven wrote: fileString = NULL
    portMissing("SavePathData", source: "oracle/codemp/game/ai_wpnav.c:2372")
    i = 0
    s = 0

    if gWPNum == 0 {
        return 0
    }

    _ = B_TempAlloc(1024)

    Com_sprintf(&routePath, 1024, "botroutes/%s.wnt\0", filename)

    trap_FS_FOpenFile(String(routePath), &f, FS_WRITE)

    B_TempFree(1024) //routePath

    if f == 0 {
        G_Printf(S_COLOR_RED + "ERROR: Could not open file to write path data\n")
        return 0
    }

    if RepairPaths(false) == 0 {
        trap_FS_FCloseFile(f)
        return 0
    }

    CalculatePaths() //make everything nice and connected before saving

    FlagObjects() //currently only used for flagging waypoints nearest CTF flags

    // Port-note: A store into `fileString`, a local the draft left as a hole.
    // Raven wrote: fileString = (char *)B_TempAlloc(524288)
    portMissing("SavePathData", source: "oracle/codemp/game/ai_wpnav.c:2372")
    _ = B_TempAlloc(4096)

    // Port-note: A read of `fileString`, a local the draft left as a hole.
    // Raven wrote: Com_sprintf(fileString, 524288, "%i %i %f (%f %f %f) { ", gWPArray[i]->index, gWPArray[i]->flags, gWPArray[i]->weight, gWPArray[i]->origin[0], gWPArray[i]->origin[1], gWPArray[i]->origin[2])
    portMissing("SavePathData", source: "oracle/codemp/game/ai_wpnav.c:2372")

    n = 0

    while n < gWPArray[i]!.neighbornum {
        if gWPArray[i]!.neighbors[n].forceJumpTo != 0 {
            Com_sprintf(&storeString, 4096, "%s%i-%i ", storeString, gWPArray[i]!.neighbors[n].num, gWPArray[i]!.neighbors[n].forceJumpTo)
        } else {
            Com_sprintf(&storeString, 4096, "%s%i ", storeString, gWPArray[i]!.neighbors[n].num)
        }
        n += 1
    }

    if gWPArray[i + 1] != nil && gWPArray[i + 1]!.inuse != 0 && gWPArray[i + 1]!.index != 0 {
        a = gWPArray[i]!.origin - gWPArray[i + 1]!.origin
        flLen = VectorLength(a)
    } else {
        flLen = 0
    }

    gWPArray[i]!.disttonext = flLen

    // Port-note: A read of `fileString`, a local the draft left as a hole.
    // Raven wrote: Com_sprintf(fileString, 524288, "%s} %f\n", fileString, flLen)
    portMissing("SavePathData", source: "oracle/codemp/game/ai_wpnav.c:2372")

    i += 1

    while i < gWPNum {
        //sprintf(fileString, "%s%i %i %f (%f %f %f) { ", fileString, gWPArray[i]->index, gWPArray[i]->flags, gWPArray[i]->weight, gWPArray[i]->origin[0], gWPArray[i]->origin[1], gWPArray[i]->origin[2]);
        Com_sprintf(&storeString, 4096, "%i %i %f (%f %f %f) { ", gWPArray[i]!.index, gWPArray[i]!.flags, gWPArray[i]!.weight, gWPArray[i]!.origin[0], gWPArray[i]!.origin[1], gWPArray[i]!.origin[2])

        n = 0

        while n < gWPArray[i]!.neighbornum {
            if gWPArray[i]!.neighbors[n].forceJumpTo != 0 {
                Com_sprintf(&storeString, 4096, "%s%i-%i ", storeString, gWPArray[i]!.neighbors[n].num, gWPArray[i]!.neighbors[n].forceJumpTo)
            } else {
                Com_sprintf(&storeString, 4096, "%s%i ", storeString, gWPArray[i]!.neighbors[n].num)
            }
            n += 1
        }

        if gWPArray[i + 1] != nil && gWPArray[i + 1]!.inuse != 0 && gWPArray[i + 1]!.index != 0 {
            a = gWPArray[i]!.origin - gWPArray[i + 1]!.origin
            flLen = VectorLength(a)
        } else {
            flLen = 0
        }

        gWPArray[i]!.disttonext = flLen

        Com_sprintf(&storeString, 4096, "%s} %f\n", storeString, flLen)

        // Port-note: A read of `fileString`, a local the draft left as a hole.
        // Raven wrote: strcat(fileString, storeString)
        portMissing("SavePathData", source: "oracle/codemp/game/ai_wpnav.c:2372")

        i += 1
    }

    // Port-note: A read of `fileString`, a local the draft left as a hole.
    // Raven wrote: trap_FS_Write(fileString, strlen(fileString), f)
    portMissing("SavePathData", source: "oracle/codemp/game/ai_wpnav.c:2372")

    B_TempFree(524288) //fileString
    B_TempFree(4096) //storeString

    trap_FS_FCloseFile(f)

    G_Printf("Path data has been saved and updated. You may need to restart the level for some things to be properly calculated.\n")

    return 1
}

/// Source: oracle/codemp/game/ai_wpnav.c:2510
func G_NearestNodeToPoint(_ point: JKAShared.vec3_t) -> Int32 {
    //gets the node on the entire grid which is nearest to the specified coordinates.
    var vSub = vec3_t()
    var bestIndex: Int32 = -1
    var i: Int32 = 0
    var bestDist: Float = 0
    var testDist: Float = 0

    while i < nodenum {
        vSub = nodetable[i].origin - point
        testDist = VectorLength(vSub)

        if bestIndex == -1 {
            bestIndex = i
            bestDist = testDist

            i += 1
            continue
        }

        if testDist < bestDist {
            bestIndex = i
            bestDist = testDist
        }
        i += 1
    }

    return bestIndex
}

/// Source: oracle/codemp/game/ai_wpnav.c:2545
func G_NodeClearForNext() {
    //reset nodes for the next trail connection.
    var i: Int32 = 0

    while i < nodenum {
        nodetable[i].flags = 0
        nodetable[i].weight = 99999

        i += 1
    }
}

/// Source: oracle/codemp/game/ai_wpnav.c:2558
func G_NodeClearFlags() {
    //only clear out flags so nodes can be reused.
    var i: Int32 = 0

    while i < nodenum {
        nodetable[i].flags = 0

        i += 1
    }
}

/// Source: oracle/codemp/game/ai_wpnav.c:2570
func G_NodeMatchingXY(_ x: Float, _ y: Float) -> Int32 {
    //just get the first unflagged node with the matching x,y coordinates.
    var i: Int32 = 0

    while i < nodenum {
        if nodetable[i].origin[0] == x && nodetable[i].origin[1] == y && nodetable[i].flags == 0 {
            return i
        }

        i += 1
    }

    return -1
}

/// Source: oracle/codemp/game/ai_wpnav.c:2589
func G_NodeMatchingXY_BA(_ x: Int32, _ y: Int32, _ final: Int32) -> Int32 {
    //return the node with the lowest weight that matches the specified x,y coordinates.
    var i: Int32 = 0
    var bestindex: Int32 = -1
    var bestWeight: Float = 9999

    while i < nodenum {
        if Int32(nodetable[i].origin[0]) == x && Int32(nodetable[i].origin[1]) == y && nodetable[i].flags == 0 && ((nodetable[i].weight < bestWeight) || (i == final)) {
            if i == final {
                return i
            }
            bestindex = i
            bestWeight = nodetable[i].weight
        }

        i += 1
    }

    return bestindex
}

/// Source: oracle/codemp/game/ai_wpnav.c:2616
func G_RecursiveConnection(_ start: Int32, _ end: Int32, _ weight: Int32, _ traceCheck: Bool, _ baseHeight: Float) -> Int32 {
    var indexDirections: [Int32] = [Int32](repeating: 0, count: 4)
    var recursiveIndex: Int32 = -1
    var i: Int32 = 0
    var passWeight: Int32 = weight
    var givenXY: [Float] = [Float](repeating: 0, count: 2)
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Int32 in

        passWeight += 1
        nodetable[start].weight = Float(passWeight)

        givenXY[0] = nodetable[start].origin[0]
        givenXY[1] = nodetable[start].origin[1]
        givenXY[0] -= DEFAULT_GRID_SPACING
        indexDirections[0] = G_NodeMatchingXY(givenXY[0], givenXY[1])

        givenXY[0] = nodetable[start].origin[0]
        givenXY[1] = nodetable[start].origin[1]
        givenXY[0] += DEFAULT_GRID_SPACING
        indexDirections[1] = G_NodeMatchingXY(givenXY[0], givenXY[1])

        givenXY[0] = nodetable[start].origin[0]
        givenXY[1] = nodetable[start].origin[1]
        givenXY[1] -= DEFAULT_GRID_SPACING
        indexDirections[2] = G_NodeMatchingXY(givenXY[0], givenXY[1])

        givenXY[0] = nodetable[start].origin[0]
        givenXY[1] = nodetable[start].origin[1]
        givenXY[1] += DEFAULT_GRID_SPACING
        indexDirections[3] = G_NodeMatchingXY(givenXY[0], givenXY[1])

        i = 0
        while i < 4 {
            if indexDirections[i] == end {
                //we've connected all the way to the destination.
                return indexDirections[i]
            }

            if indexDirections[i] != -1 && nodetable[indexDirections[i]].flags != 0 {
                //this point is already used, so it's not valid.
                indexDirections[i] = -1
            } else if indexDirections[i] != -1 {
                //otherwise mark it as used.
                nodetable[indexDirections[i]].flags = 1
            }

            if indexDirections[i] != -1 && traceCheck {
                //if we care about trace visibility between nodes, perform the check and mark as not valid if the trace isn't clear.
                // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
                portMissing("G_RecursiveConnection", source: "oracle/codemp/game/ai_wpnav.c:2616")
                // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
                portMissing("G_RecursiveConnection", source: "oracle/codemp/game/ai_wpnav.c:2616")
                trap_Trace(tr, nodetable[start].origin, vec3_origin, vec3_origin, nodetable[indexDirections[i]].origin, ENTITYNUM_NONE, CONTENTS_SOLID)

                if tr.fraction != 1 {
                    indexDirections[i] = -1
                }
            }

            if indexDirections[i] != -1 {
                //it's still valid, so keep connecting via this point.
                recursiveIndex = G_RecursiveConnection(indexDirections[i], end, passWeight, traceCheck, baseHeight)
            }

            if recursiveIndex != -1 {
                //the result of the recursive check was valid, so return it.
                return recursiveIndex
            }

            i += 1
        }

        return recursiveIndex
    }
}

/// Source: oracle/codemp/game/ai_wpnav.c:2981
func G_BackwardAttachment(_ start: Int32, _ finalDestination: Int32, _ insertAfter: Int32) -> Bool {
    //After creating a node path between 2 points, this function links the 2 points with actual waypoint data.
    var indexDirections: [Int32] = [Int32](repeating: 0, count: 4)
    var i: Int32 = 0
    var lowestWeight: Int32 = 9999
    var desiredIndex: Int32 = -1
    var givenXY: [Float] = [Float](repeating: 0, count: 2)

    givenXY[0] = nodetable[start].origin[0]
    givenXY[1] = nodetable[start].origin[1]
    givenXY[0] -= DEFAULT_GRID_SPACING
    indexDirections[0] = G_NodeMatchingXY_BA(Int32(givenXY[0]), Int32(givenXY[1]), finalDestination)

    givenXY[0] = nodetable[start].origin[0]
    givenXY[1] = nodetable[start].origin[1]
    givenXY[0] += DEFAULT_GRID_SPACING
    indexDirections[1] = G_NodeMatchingXY_BA(Int32(givenXY[0]), Int32(givenXY[1]), finalDestination)

    givenXY[0] = nodetable[start].origin[0]
    givenXY[1] = nodetable[start].origin[1]
    givenXY[1] -= DEFAULT_GRID_SPACING
    indexDirections[2] = G_NodeMatchingXY_BA(Int32(givenXY[0]), Int32(givenXY[1]), finalDestination)

    givenXY[0] = nodetable[start].origin[0]
    givenXY[1] = nodetable[start].origin[1]
    givenXY[1] += DEFAULT_GRID_SPACING
    indexDirections[3] = G_NodeMatchingXY_BA(Int32(givenXY[0]), Int32(givenXY[1]), finalDestination)

    while i < 4 {
        if indexDirections[i] != -1 {
            if indexDirections[i] == finalDestination {
                //hooray, we've found the original point and linked all the way back to it.
                CreateNewWP_InsertUnder(nodetable[start].origin, 0, insertAfter)
                CreateNewWP_InsertUnder(nodetable[indexDirections[i]].origin, 0, insertAfter)
                return true
            }

            if nodetable[indexDirections[i]].weight < lowestWeight && nodetable[indexDirections[i]].weight != 0 && nodetable[indexDirections[i]].flags == 0 {
                desiredIndex = indexDirections[i]
                lowestWeight = Int32(nodetable[indexDirections[i]].weight)
            }
        }
        i += 1
    }

    if desiredIndex != -1 {
        //Create a waypoint here, and then recursively call this function for the next neighbor with the lowest weight.
        if gWPNum < 3900 {
            CreateNewWP_InsertUnder(nodetable[start].origin, 0, insertAfter)
        } else {
            return false
        }

        nodetable[start].flags = 1
        return G_BackwardAttachment(desiredIndex, finalDestination, insertAfter)
    }

    return false
}

/// Source: oracle/codemp/game/ai_wpnav.c:3055
func G_RMGPathing() {
    //Generate waypoint information on-the-fly for the random mission.
    var placeX: Float = 0
    var placeY: Float = 0
    var placeZ: Float = 0
    var i: Int32 = 0
    let gridSpacing: Int32 = DEFAULT_GRID_SPACING
    var nearestIndex: Int32 = 0
    var nearestIndexForNext: Int32 = 0
    var downVec = vec3_t()
    var trMins = vec3_t()
    var trMaxs = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in
        // Port-note: No operator beside the operand, the text there is ``.
        // Raven wrote: gentity_t *terrain = G_Find( NULL, FOFS(classname), "terrain" );
        portMissing("G_RMGPathing", source: "oracle/codemp/game/ai_wpnav.c:3055")

        // Port-note: A read of `terrain`, a local the draft left as a hole.
        // Raven wrote: if (!terrain || !terrain->inuse || terrain->s.eType != ET_TERRAIN) { G_Printf("Error: RMG with no terrain!\n"); return; }
        portMissing("G_RMGPathing", source: "oracle/codemp/game/ai_wpnav.c:3055")


        nodenum = 0
        nodetable.zero()

        trMins = vec3_t(-15, -15, Float(DEFAULT_MINS_2))
        trMaxs = vec3_t(15, 15, Float(DEFAULT_MAXS_2))

        // Port-note: A read of `terrain`, a local the draft left as a hole.
        // Raven wrote: placeX = terrain->r.absmin[0]
        portMissing("G_RMGPathing", source: "oracle/codemp/game/ai_wpnav.c:3055")
        // Port-note: A read of `terrain`, a local the draft left as a hole.
        // Raven wrote: placeY = terrain->r.absmin[1]
        portMissing("G_RMGPathing", source: "oracle/codemp/game/ai_wpnav.c:3055")
        // Port-note: A read of `terrain`, a local the draft left as a hole.
        // Raven wrote: placeZ = terrain->r.absmax[2]-400
        portMissing("G_RMGPathing", source: "oracle/codemp/game/ai_wpnav.c:3055")

        //skim through the entirety of the terrain limits and drop nodes, removing
        //nodes that start in solid or fall too high on the terrain.
        // Port-note: A read of `terrain`, a local the draft left as a hole.
        // Raven wrote: while (placeY < terrain->r.absmax[1]) { if (nodenum >= MAX_NODETABLE_SIZE) { break; } while (placeX < terrain->r.absmax[0]) { if (nodenum >= MAX_NODETABLE_SIZE) { break; } nodetable[nodenum].origin[0] = placeX; nodetable[nodenum].origin[1] = placeY; nodetable[nodenum].origin[2] = placeZ; VectorCopy(nodetable[nodenum].origin, downVec); downVec[2] -= 3000; trap_Trace(&tr, nodetable[nodenum].origin, trMins, trMaxs, downVec, ENTITYNUM_NONE, MASK_SOLID); if ((tr.entityNum >= ENTITYNUM_WORLD || g_entities[tr.entityNum].s.eType == ET_TERRAIN) && tr.endpos[2] < terrain->r.absmin[2]+750) { //only drop nodes on terrain directly VectorCopy(tr.endpos, nodetable[nodenum].origin); nodenum++; } else { VectorClear(nodetable[nodenum].origin); } placeX += gridSpacing; } placeX = terrain->r.absmin[0]; placeY += gridSpacing; }
        portMissing("G_RMGPathing", source: "oracle/codemp/game/ai_wpnav.c:3055")


        G_NodeClearForNext()

        //The grid has been placed down, now use it to connect the points in the level.
        while i < gSpawnPointNum - 1 {
            if gSpawnPoints[i] == nil || !gSpawnPoints[i]!.inuse || gSpawnPoints[i + 1] == nil || !gSpawnPoints[i + 1]!.inuse {
                i += 1
                continue
            }

            nearestIndex = G_NearestNodeToPoint(gSpawnPoints[i]!.s.origin)
            nearestIndexForNext = G_NearestNodeToPoint(gSpawnPoints[i + 1]!.s.origin)


            if nearestIndex == -1 || nearestIndexForNext == -1 {
                //Looks like there is no grid data near one of the points. Ideally, this will never happen.
                i += 1
                continue
            }

            if nearestIndex == nearestIndexForNext {
                //Two spawn points on top of each other? We don't need to do both points, keep going until the next differs.
                i += 1
                continue
            }

            //So, nearestIndex is now the node for the spawn point we're on, and nearestIndexForNext is the
            //node we want to get to from here.

            //For now I am going to branch out mindlessly, but I will probably want to use some sort of A* algorithm
            //here to lessen the time taken.
            // Port-note: A read of `terrain`, a local the draft left as a hole.
            // Raven wrote: if (G_RecursiveConnection(nearestIndex, nearestIndexForNext, 0, qtrue, terrain->r.absmin[2]) != nearestIndexForNext) { //failed to branch to where we want. Oh well, try it without trace checks. G_NodeClearForNext(); #ifdef PAINFULLY_DEBUGGING_THROUGH_VM Com_Printf("FAILED RECURSIVE WITH TRACES\n"); #endif if (G_RecursiveConnection(nearestIndex, nearestIndexForNext, 0, qfalse, terrain->r.absmin[2]) != nearestIndexForNext) { //still failed somehow. Just disregard this point. #ifdef PAINFULLY_DEBUGGING_THROUGH_VM Com_Printf("FAILED RECURSIVE -WITHOUT- TRACES (?!?!)\n"); #endif G_NodeClearForNext(); i++; continue; } }
            portMissing("G_RMGPathing", source: "oracle/codemp/game/ai_wpnav.c:3055")

            //Now our node array is set up so that highest reasonable weight is the destination node, and 2 is next to the original index,
            //so trace back to that point.
            G_NodeClearFlags()

            if G_BackwardAttachment(nearestIndexForNext, nearestIndex, gWPNum - 1) {
                //successfully connected the trail from nearestIndex to nearestIndexForNext
                if gSpawnPoints[i + 1]!.inuse && gSpawnPoints[i + 1]!.item != nil && gSpawnPoints[i + 1]!.item!.giType == IT_TEAM {
                    //This point is actually a CTF flag.
                    if gSpawnPoints[i + 1]!.item!.giTag == PW_REDFLAG || gSpawnPoints[i + 1]!.item!.giTag == PW_BLUEFLAG {
                        //Place a waypoint on the flag next in the trail, so the nearest grid point will link to it.
                        CreateNewWP_InsertUnder(gSpawnPoints[i + 1]!.s.origin, WPFLAG_NEVERONEWAY, gWPNum - 1)
                    }
                }
            } else {
                break
            }


            G_NodeClearForNext()
            i += 1
        }


        RepairPaths(true) //this has different behaviour for RMG and will just flag all points one way that don't trace to each other.
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/game/ai_wpnav.c:3254
func BeginAutoPathRoutine() {
    //Called for RMG levels.
    var i: Int32 = 0
    var ent: Entity? = nil
    var v = vec3_t()

    gSpawnPointNum = 0

    CreateNewWP(vec3_origin, 0) //create a dummy waypoint to insert under

    while i < level.num_entities {
        ent = g_entities[i]

        if ent != nil && ent!.inuse && ent!.classname != nil && !ent!.classname!.isEmpty && Q_stricmp(ent!.classname!, "info_player_deathmatch") == 0 {
            if ent!.s.origin[2] < 1280 {
                //h4x
                gSpawnPoints[gSpawnPointNum] = ent
                gSpawnPointNum += 1
            }
        } else if ent != nil && ent!.inuse && ent!.item != nil && ent!.item!.giType == IT_TEAM && (ent!.item!.giTag == PW_REDFLAG || ent!.item!.giTag == PW_BLUEFLAG) {
            //also make it path to flags in CTF.
            gSpawnPoints[gSpawnPointNum] = ent
            gSpawnPointNum += 1
        }

        i += 1
    }

    if gSpawnPointNum < 1 {
        return
    }

    G_RMGPathing()

    //rww - Using a faster in-engine version because we're having to wait for this stuff to get done as opposed to just saving it once.
    trap_Bot_UpdateWaypoints(gWPNum, gWPArray)
    trap_Bot_CalculatePaths(g_RMG.integer)
    //CalculatePaths(); //make everything nice and connected


    FlagObjects() //currently only used for flagging waypoints nearest CTF flags

    i = 0

    while i < gWPNum - 1 {
        //disttonext is normally set on save, and when a file is loaded. For RMG we must do it after calc'ing.
        v = gWPArray[i]!.origin - gWPArray[i + 1]!.origin
        gWPArray[i]!.disttonext = VectorLength(v)
        i += 1
    }

    RemoveWP() //remove the dummy point at the end of the trail
}

/// Source: oracle/codemp/game/ai_wpnav.c:3347
func LoadPath_ThisLevel() {
    // Raven's record lives to the end of his block, so the block is the closure.
    VmCvar.scratch { mapname in
        var i: Int32 = 0
        var ent: Entity? = nil

        trap_Cvar_Register(mapname, "mapname", "", CVAR_SERVERINFO | CVAR_ROM)

        if g_RMG.integer != 0 {
            //If RMG, generate the path on-the-fly
            trap_Cvar_Register(bot_normgpath, "bot_normgpath", "1", CVAR_CHEAT)
            //note: This is disabled for now as I'm using standard bot nav
            //on premade terrain levels.

            if bot_normgpath.integer == 0 {
                //autopath the random map
                BeginAutoPathRoutine()
            } else {
                //try loading standard nav data
                LoadPathData(mapname.string)
            }

            gLevelFlags |= LEVELFLAG_NOPOINTPREDICTION
        } else {
            if LoadPathData(mapname.string) == 2 {
                //enter "edit" mode if cheats enabled?
            }
        }

        trap_Cvar_Update(bot_wp_edit)

        if bot_wp_edit.value != 0 {
            gBotEdit = 1
        } else {
            gBotEdit = 0
        }

        //set the flag entities
        while i < level.num_entities {
            ent = g_entities[i]

            if ent != nil && ent!.inuse && ent!.classname != nil {
                if eFlagRed == nil && strcmp(ent!.classname!, "team_CTF_redflag") == 0 {
                    eFlagRed = ent
                } else if eFlagBlue == nil && strcmp(ent!.classname!, "team_CTF_blueflag") == 0 {
                    eFlagBlue = ent
                }

                if eFlagRed != nil && eFlagBlue != nil {
                    break
                }
            }

            i += 1
        }
    }
}

/// Source: oracle/codemp/game/ai_wpnav.c:3425
func GetClosestSpawn(_ ent: Entity) -> Entity? {
    var spawn: Entity?
    var closestSpawn: Entity? = nil
    var closestDist: Float = -1
    var i: Int32 = MAX_CLIENTS

    spawn = nil

    while i < level.num_entities {
        spawn = g_entities[i]

        if spawn != nil && spawn!.inuse && (Q_stricmp(spawn!.classname!, "info_player_start") == 0 || Q_stricmp(spawn!.classname!, "info_player_deathmatch") == 0) {
            var checkDist: Float
            var vSub = vec3_t()

            vSub = ent.client!.ps.origin - spawn!.r.currentOrigin
            checkDist = VectorLength(vSub)

            if closestDist == -1 || checkDist < closestDist {
                closestSpawn = spawn
                closestDist = checkDist
            }
        }

        i += 1
    }

    return closestSpawn
}

/// Source: oracle/codemp/game/ai_wpnav.c:3459
func GetNextSpawnInIndex(_ currentSpawn: Entity) -> Entity? {
    var spawn: Entity?
    var nextSpawn: Entity? = nil
    var i: Int32 = currentSpawn.s.number + 1

    spawn = nil

    while i < level.num_entities {
        spawn = g_entities[i]

        if spawn != nil && spawn!.inuse && (Q_stricmp(spawn!.classname!, "info_player_start") == 0 || Q_stricmp(spawn!.classname!, "info_player_deathmatch") == 0) {
            nextSpawn = spawn
            break
        }

        i += 1
    }

    if nextSpawn == nil {
        //loop back around to 0
        i = MAX_CLIENTS

        while i < level.num_entities {
            spawn = g_entities[i]

            if spawn != nil && spawn!.inuse && (Q_stricmp(spawn!.classname!, "info_player_start") == 0 || Q_stricmp(spawn!.classname!, "info_player_deathmatch") == 0) {
                nextSpawn = spawn
                break
            }

            i += 1
        }
    }

    return nextSpawn
}

/// Source: oracle/codemp/game/ai_wpnav.c:3501
func AcceptBotCommand(_ cmd: String, _ pl: Entity) -> Int32 {
    var OptionalArgument: Int32 = 0
    var i: Int32 = 0
    var FlagsFromArgument: Int32 = 0
    var OptionalSArgument: String? = nil
    var RequiredSArgument: String? = nil
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return VmCvar.scratch { mapname -> Int32 in

        if gBotEdit == 0 {
            return 0
        }

        OptionalArgument = 0
        i = 0
        FlagsFromArgument = 0
        OptionalSArgument = nil
        RequiredSArgument = nil

        //if a waypoint editing related command is issued, bots will deactivate.
        //once bot_wp_save is issued and the trail is recalculated, bots will activate again.

        if pl.client == nil {
            return 0
        }

        if Q_stricmp(cmd, "bot_wp_cmdlist") == 0 {
            G_Printf(S_COLOR_YELLOW + "bot_wp_add" + S_COLOR_WHITE + " - Add a waypoint (optional int parameter will insert the point after the specified waypoint index in a trail)\n\n")
            G_Printf(S_COLOR_YELLOW + "bot_wp_rem" + S_COLOR_WHITE + " - Remove a waypoint (removes last unless waypoint index is specified as a parameter)\n\n")
            G_Printf(S_COLOR_YELLOW + "bot_wp_addflagged" + S_COLOR_WHITE + " - Same as wp_add, but adds a flagged point (type bot_wp_addflagged for help)\n\n")
            G_Printf(S_COLOR_YELLOW + "bot_wp_switchflags" + S_COLOR_WHITE + " - Switches flags on an existing waypoint (type bot_wp_switchflags for help)\n\n")
            G_Printf(S_COLOR_YELLOW + "bot_wp_tele" + S_COLOR_WHITE + " - Teleport yourself to the specified waypoint's location\n")
            G_Printf(S_COLOR_YELLOW + "bot_wp_killoneways" + S_COLOR_WHITE + " - Removes oneway (backward and forward) flags on all waypoints in the level\n\n")
            G_Printf(S_COLOR_YELLOW + "bot_wp_save" + S_COLOR_WHITE + " - Saves all waypoint data into a file for later use\n")

            return 1
        }

        if Q_stricmp(cmd, "bot_wp_add") == 0 {
            gDeactivated = 1
            OptionalSArgument = ConcatArgs(1)

            if OptionalSArgument != nil {
                OptionalArgument = atoi(OptionalSArgument!)
            }

            if OptionalSArgument != nil && !OptionalSArgument!.isEmpty {
                CreateNewWP_InTrail(pl.client!.ps.origin, 0, OptionalArgument)
            } else {
                CreateNewWP(pl.client!.ps.origin, 0)
            }
            return 1
        }

        if Q_stricmp(cmd, "bot_wp_rem") == 0 {
            gDeactivated = 1

            OptionalSArgument = ConcatArgs(1)

            if OptionalSArgument != nil {
                OptionalArgument = atoi(OptionalSArgument!)
            }

            if OptionalSArgument != nil && !OptionalSArgument!.isEmpty {
                RemoveWP_InTrail(OptionalArgument)
            } else {
                RemoveWP()
            }

            return 1
        }

        if Q_stricmp(cmd, "bot_wp_tele") == 0 {
            gDeactivated = 1
            OptionalSArgument = ConcatArgs(1)

            if OptionalSArgument != nil {
                OptionalArgument = atoi(OptionalSArgument!)
            }

            if OptionalSArgument != nil && !OptionalSArgument!.isEmpty {
                TeleportToWP(pl, OptionalArgument)
            } else {
                G_Printf(S_COLOR_YELLOW + "You didn't specify an index. Assuming last.\n")
                TeleportToWP(pl, gWPNum - 1)
            }
            return 1
        }

        if Q_stricmp(cmd, "bot_wp_spawntele") == 0 {
            var closestSpawn: Entity? = GetClosestSpawn(pl)

            if closestSpawn == nil {
                //There should always be a spawn point..
                return 1
            }

            closestSpawn = GetNextSpawnInIndex(closestSpawn!)

            if closestSpawn != nil {
                pl.client!.ps.origin = closestSpawn!.r.currentOrigin
            }
            return 1
        }

        if Q_stricmp(cmd, "bot_wp_addflagged") == 0 {
            gDeactivated = 1

            RequiredSArgument = ConcatArgs(1)

            if RequiredSArgument == nil || RequiredSArgument!.isEmpty {
                G_Printf(S_COLOR_YELLOW + "Flag string needed for bot_wp_addflagged\nj - Jump point\nd - Duck point\nc - Snipe or camp standing\nf - Wait for func\nm - Do not move to when func is under\ns - Snipe or camp\nx - Oneway, forward\ny - Oneway, back\ng - Mission goal\nn - No visibility\nExample (for a point the bot would jump at, and reverse on when traveling a trail backwards):\nbot_wp_addflagged jx\n")
                return 1
            }

            // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '!=' cannot be applied to operands of type 'Character' and 'Int'".
            // Raven wrote: while (RequiredSArgument[i]) { if (RequiredSArgument[i] == 'j') { FlagsFromArgument |= WPFLAG_JUMP; } else if (RequiredSArgument[i] == 'd') { FlagsFromArgument |= WPFLAG_DUCK; } else if (RequiredSArgument[i] == 'c') { FlagsFromArgument |= WPFLAG_SNIPEORCAMPSTAND; } else if (RequiredSArgument[i] == 'f') { FlagsFromArgument |= WPFLAG_WAITFORFUNC; } else if (RequiredSArgument[i] == 's') { FlagsFromArgument |= WPFLAG_SNIPEORCAMP; } else if (RequiredSArgument[i] == 'x') { FlagsFromArgument |= WPFLAG_ONEWAY_FWD; } else if (RequiredSArgument[i] == 'y') { FlagsFromArgument |= WPFLAG_ONEWAY_BACK; } else if (RequiredSArgument[i] == 'g') { FlagsFromArgument |= WPFLAG_GOALPOINT; } else if (RequiredSArgument[i] == 'n') { FlagsFromArgument |= WPFLAG_NOVIS; } else if (RequiredSArgument[i] == 'm') { FlagsFromArgument |= WPFLAG_NOMOVEFUNC; } i++; }
            portMissing("AcceptBotCommand", source: "oracle/codemp/game/ai_wpnav.c:3501")

            OptionalSArgument = ConcatArgs(2)

            if OptionalSArgument != nil {
                OptionalArgument = atoi(OptionalSArgument!)
            }

            if OptionalSArgument != nil && !OptionalSArgument!.isEmpty {
                CreateNewWP_InTrail(pl.client!.ps.origin, FlagsFromArgument, OptionalArgument)
            } else {
                CreateNewWP(pl.client!.ps.origin, FlagsFromArgument)
            }
            return 1
        }

        if Q_stricmp(cmd, "bot_wp_switchflags") == 0 {
            gDeactivated = 1

            RequiredSArgument = ConcatArgs(1)

            if RequiredSArgument == nil || RequiredSArgument!.isEmpty {
                G_Printf(S_COLOR_YELLOW + "Flag string needed for bot_wp_switchflags\nType bot_wp_addflagged for a list of flags and their corresponding characters, or use 0 for no flags.\nSyntax: bot_wp_switchflags <flags> <n>\n")
                return 1
            }

            // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '!=' cannot be applied to operands of type 'Character' and 'Int'".
            // Raven wrote: while (RequiredSArgument[i]) { if (RequiredSArgument[i] == 'j') { FlagsFromArgument |= WPFLAG_JUMP; } else if (RequiredSArgument[i] == 'd') { FlagsFromArgument |= WPFLAG_DUCK; } else if (RequiredSArgument[i] == 'c') { FlagsFromArgument |= WPFLAG_SNIPEORCAMPSTAND; } else if (RequiredSArgument[i] == 'f') { FlagsFromArgument |= WPFLAG_WAITFORFUNC; } else if (RequiredSArgument[i] == 's') { FlagsFromArgument |= WPFLAG_SNIPEORCAMP; } else if (RequiredSArgument[i] == 'x') { FlagsFromArgument |= WPFLAG_ONEWAY_FWD; } else if (RequiredSArgument[i] == 'y') { FlagsFromArgument |= WPFLAG_ONEWAY_BACK; } else if (RequiredSArgument[i] == 'g') { FlagsFromArgument |= WPFLAG_GOALPOINT; } else if (RequiredSArgument[i] == 'n') { FlagsFromArgument |= WPFLAG_NOVIS; } else if (RequiredSArgument[i] == 'm') { FlagsFromArgument |= WPFLAG_NOMOVEFUNC; } i++; }
            portMissing("AcceptBotCommand", source: "oracle/codemp/game/ai_wpnav.c:3501")

            OptionalSArgument = ConcatArgs(2)

            if OptionalSArgument != nil {
                OptionalArgument = atoi(OptionalSArgument!)
            }

            if OptionalSArgument != nil && !OptionalSArgument!.isEmpty {
                WPFlagsModify(OptionalArgument, FlagsFromArgument)
            } else {
                G_Printf(S_COLOR_YELLOW + "Waypoint number (to modify) needed for bot_wp_switchflags\nSyntax: bot_wp_switchflags <flags> <n>\n")
            }
            return 1
        }

        if Q_stricmp(cmd, "bot_wp_killoneways") == 0 {
            i = 0

            while i < gWPNum {
                if gWPArray[i] != nil && gWPArray[i]!.inuse != 0 {
                    if (gWPArray[i]!.flags & WPFLAG_ONEWAY_FWD) != 0 {
                        gWPArray[i]!.flags -= WPFLAG_ONEWAY_FWD
                    }
                    if (gWPArray[i]!.flags & WPFLAG_ONEWAY_BACK) != 0 {
                        gWPArray[i]!.flags -= WPFLAG_ONEWAY_BACK
                    }
                }

                i += 1
            }

            return 1
        }

        if Q_stricmp(cmd, "bot_wp_save") == 0 {
            gDeactivated = 0
            trap_Cvar_Register(mapname, "mapname", "", CVAR_SERVERINFO | CVAR_ROM)
            SavePathData(mapname.string)
            return 1
        }

        return 0
    }
}
