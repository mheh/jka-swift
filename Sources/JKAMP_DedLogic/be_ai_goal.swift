import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/botlib/be_ai_goal.cpp:75
private let GT_FFA: Int32 = 0
private let GT_HOLOCRON: Int32 = 1
private let GT_JEDIMASTER: Int32 = 2
private let GT_DUEL: Int32 = 3
private let GT_POWERDUEL: Int32 = 4
private let GT_SINGLE_PLAYER: Int32 = 5
private let GT_TEAM: Int32 = 6
private let GT_SIEGE: Int32 = 7
private let GT_CTF: Int32 = 8
private let GT_CTY: Int32 = 9
private let GT_MAX_GAME_TYPE: Int32 = 10

/// Source: oracle/codemp/botlib/be_ai_goal.cpp:38
let AVOID_MINIMUM_TIME = 10 as Int32

/// Source: oracle/codemp/botlib/be_ai_goal.cpp:40
let AVOID_DEFAULT_TIME = 30 as Int32

/// Source: oracle/codemp/botlib/be_ai_goal.cpp:42
let AVOID_DROPPED_TIME = 10 as Int32

/// Source: oracle/codemp/botlib/be_ai_goal.cpp:44
let TRAVELTIME_SCALE = 0.01 as Double

/// Source: oracle/codemp/botlib/be_ai_goal.cpp:46
let IFL_NOTFREE = 1 as Int32

/// Source: oracle/codemp/botlib/be_ai_goal.cpp:47
let IFL_NOTTEAM = 2 as Int32

/// Source: oracle/codemp/botlib/be_ai_goal.cpp:48
let IFL_NOTSINGLE = 4 as Int32

/// Source: oracle/codemp/botlib/be_ai_goal.cpp:49
let IFL_NOTBOT = 8 as Int32

/// Source: oracle/codemp/botlib/be_ai_goal.cpp:50
let IFL_ROAM = 16 as Int32

/// Source: oracle/codemp/botlib/be_ai_goal.cpp:123
// Raven wrote: fielddef_t iteminfo_fields[]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/botlib/be_ai_goal.cpp:136
// Raven wrote: structdef_t iteminfo_struct
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/botlib/be_ai_goal.cpp:163
public var botgoalstates: Slots<BotGoalstate?> { world.storage.botgoalstates }

/// Source: oracle/codemp/botlib/be_ai_goal.cpp:165
public var itemconfig: Itemconfig? {
    get { world.variables.itemconfig }
    set { world.variables.itemconfig = newValue }
}

/// Source: oracle/codemp/botlib/be_ai_goal.cpp:167
public var levelitemheap: Slots<Levelitem>? {
    get { world.variables.levelitemheap }
    set { world.variables.levelitemheap = newValue }
}

/// Source: oracle/codemp/botlib/be_ai_goal.cpp:168
public var freelevelitems: Levelitem? {
    get { world.variables.freelevelitems }
    set { world.variables.freelevelitems = newValue }
}

/// Source: oracle/codemp/botlib/be_ai_goal.cpp:169
public var levelitems: Levelitem? {
    get { world.variables.levelitems }
    set { world.variables.levelitems = newValue }
}

/// Source: oracle/codemp/botlib/be_ai_goal.cpp:170
public var numlevelitems: Int32 {
    get { world.variables.numlevelitems }
    set { world.variables.numlevelitems = newValue }
}

/// Source: oracle/codemp/botlib/be_ai_goal.cpp:172
public var maplocations: Maplocation? {
    get { world.variables.maplocations }
    set { world.variables.maplocations = newValue }
}

/// Source: oracle/codemp/botlib/be_ai_goal.cpp:174
public var campspots: Campspot? {
    get { world.variables.campspots }
    set { world.variables.campspots = newValue }
}

/// Source: oracle/codemp/botlib/be_ai_goal.cpp:176
public var g_gametype: Int32 {
    get { world.variables.g_gametype }
    set { world.variables.g_gametype = newValue }
}

/// Source: oracle/codemp/botlib/be_ai_goal.cpp:178
public var droppedweight: Libvar? {
    get { world.variables.droppedweight }
    set { world.variables.droppedweight = newValue }
}

/// Source: oracle/codemp/botlib/be_ai_goal.cpp:991
private let ET_ITEM = 2 as Int32

//========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:186
public func BotGoalStateFromHandle(_ handle: Int32) -> BotGoalstate? {
    if handle <= 0 || handle > MAX_CLIENTS {
        botimport.runPrint(PRT_FATAL, "goal state handle %d out of range\n", handle)
        return nil
    }
    if botgoalstates[handle] == nil {
        botimport.runPrint(PRT_FATAL, "invalid goal state %d\n", handle)
        return nil
    }
    return botgoalstates[handle]
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:206
public func BotInterbreedGoalFuzzyLogic(_ parent1: Int32, _ parent2: Int32, _ child: Int32) {
    var p1: BotGoalstate?, p2: BotGoalstate?, c: BotGoalstate?

    p1 = BotGoalStateFromHandle(parent1)
    p2 = BotGoalStateFromHandle(parent2)
    c = BotGoalStateFromHandle(child)

    InterbreedWeightConfigs(p1!.itemweightconfig!, p2!.itemweightconfig!, c!.itemweightconfig!)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:223
public func BotSaveGoalFuzzyLogic(_ goalstate: Int32, _ filename: String) {
    var gs: BotGoalstate?

    gs = BotGoalStateFromHandle(goalstate)

    //WriteWeightConfig(filename, gs->itemweightconfig);
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:237
public func BotMutateGoalFuzzyLogic(_ goalstate: Int32, _ range: Float) {
    var gs: BotGoalstate?

    gs = BotGoalStateFromHandle(goalstate)

    EvolveWeightConfig(gs!.itemweightconfig!)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:251
public func LoadItemConfig(_ filename: String) -> Itemconfig? {
    // Raven's record lives to the end of his block, so the block is the closure.
    return Token.scratch { token -> Itemconfig? in
        var max_iteminfo: Int32
        var path = CharBuf(MAX_PATH)
        var ic: Itemconfig
        var ii: Iteminfo

        max_iteminfo = Int32(LibVarValue("max_iteminfo", "256"))
        if max_iteminfo < 0 {
            botimport.runPrint(PRT_ERROR, "max_iteminfo = %d\n", max_iteminfo)
            max_iteminfo = 256
            LibVarSet("max_iteminfo", "256")
        }

        strncpy(&path, filename, MAX_PATH)
        PC_SetBaseFolder(BOTFILESBASEFOLDER)
        guard let source = LoadSourceFile(String(path)) else {
            botimport.runPrint(PRT_ERROR, "counldn't load %s\n", String(path))
            return nil
        }
        //initialize item config
        // The table of `max_iteminfo` records follows the record in the block.
        let icBlock = GetClearedHunkMemory(UInt32(Int32(Itemconfig.byteCount) + max_iteminfo * Int32(Iteminfo.byteCount)))
        ic = Itemconfig(icBlock)
        ic.iteminfoSlots = Slots(views: icBlock + Itemconfig.byteCount, count: Int(max_iteminfo), stride: Iteminfo.stride)
        ic.numiteminfo = 0
        //parse the item config file
        while PC_ReadToken(source, token) != 0 {
            if strcmp(token.string, "iteminfo") == 0 {
                if ic.numiteminfo >= max_iteminfo {
                    SourceError(source, "more than %d item info defined\n", max_iteminfo)
                    FreeMemory(ic.handle)
                    FreeSource(source)
                    return nil
                }
                ii = ic.iteminfoSlots[ic.numiteminfo]
                ii.clear()
                if PC_ExpectTokenType(source, TT_STRING, 0, token) == 0 {
                    FreeMemory(ic.handle)
                    FreeMemory(source.handle)
                    return nil
                }
                StripDoubleQuotes(&token.stringBuffer)
                strncpy(&ii.classnameBuffer, token.string, Int32(ii.classnameBuffer.count) - 1)
                // Raven casts the record to `char *`, and the raw pointer over the record's slot is that cast, under rule 11.
                if ReadStructure(source, iteminfo_struct, UnsafeMutableRawPointer(ii.handle)) == 0 {
                    FreeMemory(ic.handle)
                    FreeSource(source)
                    return nil
                }
                ii.number = ic.numiteminfo
                ic.numiteminfo += 1
            } else {
                SourceError(source, "unknown definition %s\n", token.string)
                FreeMemory(ic.handle)
                FreeSource(source)
                return nil
            }
        }
        FreeSource(source)
        //
        if ic.numiteminfo == 0 {
            botimport.runPrint(PRT_WARNING, "no item info loaded\n")
        }
        botimport.runPrint(PRT_MESSAGE, "loaded %s\n", String(path))
        return ic
    }
}

//===========================================================================
// index to find the weight function of an iteminfo
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:332
public func ItemWeightIndex(_ iwc: Weightconfig, _ ic: Itemconfig) -> Slots<Int32> {
    var index: Slots<Int32>, i: Int32

    //initialize item weight index
    index = Slots<Int32>(scalars: GetClearedMemory(Int32(Int32.byteCount) * ic.numiteminfo), count: Int(ic.numiteminfo))

    i = 0
    while i < ic.numiteminfo {
        index[i] = FindFuzzyWeight(iwc, ic.iteminfoSlots[i].classname)
        if index[i] < 0 {
            Log_Write("item info %d \"%s\" has no fuzzy weight\r\n", i, ic.iteminfoSlots[i].classname)
        } //end if
        i += 1
    } //end for
    return index
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:355
public func InitLevelItemHeap() {
    var i: Int32, max_levelitems: Int32

    if levelitemheap != nil { FreeMemory(OpaquePointer(levelitemheap!.base)) }

    max_levelitems = Int32(LibVarValue("max_levelitems", "256"))
    levelitemheap = Slots<Levelitem>(GetClearedMemory(UInt32(max_levelitems * Int32(Levelitem.byteCount))), count: max_levelitems)

    i = 0
    while i < max_levelitems - 1 {
        levelitemheap![i].next = levelitemheap![i + 1]
        i += 1
    }
    levelitemheap![max_levelitems - 1].next = nil
    //
    freelevelitems = levelitemheap![0]
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:378
public func AllocLevelItem() -> Levelitem? {
    guard let li = freelevelitems else {
        botimport.runPrint(PRT_FATAL, "out of level items\n")
        return nil
    }
    //
    freelevelitems = freelevelitems!.next
    li.clear()
    return li
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:399
public func FreeLevelItem(_ li: Levelitem) {
    li.next = freelevelitems
    freelevelitems = li
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:410
public func AddLevelItemToList(_ li: Levelitem) {
    if levelitems != nil { levelitems!.prev = li }
    li.prev = nil
    li.next = levelitems
    levelitems = li
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:423
public func RemoveLevelItemFromList(_ li: Levelitem) {
    if li.prev != nil {
        li.prev!.next = li.next
    } else {
        levelitems = li.next
    }
    if li.next != nil { li.next!.prev = li.prev }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:435
public func BotFreeInfoEntities() {
    var ml: Maplocation?, nextml: Maplocation?
    var cs: Campspot?, nextcs: Campspot?

    ml = maplocations
    while ml != nil {
        nextml = ml!.next
        FreeMemory(ml!.handle)
        ml = nextml
    }
    maplocations = nil
    cs = campspots
    while cs != nil {
        nextcs = cs!.next
        FreeMemory(cs!.handle)
        cs = nextcs
    }
    campspots = nil
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:459
public func BotInitInfoEntities() {
    var classname = CharBuf(MAX_EPAIRKEY)
    var ml: Maplocation
    var cs: Campspot
    var ent: Int32, numlocations: Int32, numcampspots: Int32

    BotFreeInfoEntities()
    //
    numlocations = 0
    numcampspots = 0
    ent = AAS_NextBSPEntity(0)
    while ent != 0 {
        if AAS_ValueForBSPEpairKey(ent, "classname", &classname, MAX_EPAIRKEY) == 0 {
            ent = AAS_NextBSPEntity(ent)
            continue
        }

        //map locations
        if strcmp(classname, "target_location") == 0 {
            ml = Maplocation(GetClearedMemory(UInt32(Maplocation.byteCount)))
            AAS_VectorForBSPEpairKey(ent, "origin", &ml.origin)
            AAS_ValueForBSPEpairKey(ent, "message", &ml.nameBuffer, Int32(ml.nameBuffer.count))
            ml.areanum = AAS_PointAreaNum(ml.origin)
            ml.next = maplocations
            maplocations = ml
            numlocations += 1
        }
        //camp spots
        else if strcmp(classname, "info_camp") == 0 {
            cs = Campspot(GetClearedMemory(UInt32(Campspot.byteCount)))
            AAS_VectorForBSPEpairKey(ent, "origin", &cs.origin)
            //cs->origin[2] += 16;
            AAS_ValueForBSPEpairKey(ent, "message", &cs.nameBuffer, Int32(cs.nameBuffer.count))
            AAS_FloatForBSPEpairKey(ent, "range", &cs.range)
            AAS_FloatForBSPEpairKey(ent, "weight", &cs.weight)
            AAS_FloatForBSPEpairKey(ent, "wait", &cs.wait)
            AAS_FloatForBSPEpairKey(ent, "random", &cs.random)
            cs.areanum = AAS_PointAreaNum(cs.origin)
            if cs.areanum == 0 {
                botimport.runPrint(PRT_MESSAGE, "camp spot at %1.1f %1.1f %1.1f in solid\n", cs.origin[0], cs.origin[1], cs.origin[2])
                FreeMemory(cs.handle)
                ent = AAS_NextBSPEntity(ent)
                continue
            }
            cs.next = campspots
            campspots = cs
            //AAS_DrawPermanentCross(cs->origin, 4, LINECOLOR_YELLOW);
            numcampspots += 1
        }
        ent = AAS_NextBSPEntity(ent)
    }
    if bot_developer != 0 {
        botimport.runPrint(PRT_MESSAGE, "%d map locations\n", numlocations)
        botimport.runPrint(PRT_MESSAGE, "%d camp spots\n", numcampspots)
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:521
public func BotInitLevelItems() {
    // Raven's record lives to the end of his block, so the block is the closure.
    BspTrace.scratch { trace in
        var i: Int32, spawnflags: Int32, value: Int32 = 0
        var classname = CharBuf(MAX_EPAIRKEY)
        var origin = vec3_t(), end = vec3_t()
        var ent: Int32, goalareanum: Int32

        //initialize the map locations and camp spots
        BotInitInfoEntities()

        //initialize the level item heap
        InitLevelItemHeap()
        levelitems = nil
        numlevelitems = 0
        //
        guard let ic = itemconfig else { return }

        //if there's no AAS file loaded
        if AAS_Loaded() == 0 { return }

        //update the modelindexes of the item info
        i = 0
        while i < ic.numiteminfo {
            //ic->iteminfo[i].modelindex = AAS_IndexFromModel(ic->iteminfo[i].model);
            if ic.iteminfoSlots[i].modelindex == 0 {
                Log_Write("item %s has modelindex 0", ic.iteminfoSlots[i].classname)
            }
            i += 1
        }

        ent = AAS_NextBSPEntity(0)
        while ent != 0 {
            if AAS_ValueForBSPEpairKey(ent, "classname", &classname, MAX_EPAIRKEY) == 0 {
                ent = AAS_NextBSPEntity(ent)
                continue
            }
            //
            spawnflags = 0
            AAS_IntForBSPEpairKey(ent, "spawnflags", &spawnflags)
            //
            i = 0
            while i < ic.numiteminfo {
                if strcmp(classname, ic.iteminfoSlots[i].classname) == 0 { break }
                i += 1
            }
            if i >= ic.numiteminfo {
                Log_Write("entity %s unknown item\r\n", classname)
                ent = AAS_NextBSPEntity(ent)
                continue
            }
            //get the origin of the item
            if AAS_VectorForBSPEpairKey(ent, "origin", &origin) == 0 {
                botimport.runPrint(PRT_ERROR, "item %s without origin\n", String(classname))
                ent = AAS_NextBSPEntity(ent)
                continue
            }
            //
            goalareanum = 0
            //if it is a floating item
            if (spawnflags & 1) != 0 {
                //if the item is not floating in water
                if (AAS_PointContents(origin) & CONTENTS_WATER) == 0 {
                    end = origin
                    end[2] -= 32
                    trace.copy(from: AAS_Trace(origin, ic.iteminfoSlots[i].mins, ic.iteminfoSlots[i].maxs, end, -1, CONTENTS_SOLID | CONTENTS_PLAYERCLIP))
                    //if the item not near the ground
                    if trace.fraction >= 1 {
                        //if the item is not reachable from a jumppad
                        goalareanum = AAS_BestReachableFromJumpPadArea(origin, ic.iteminfoSlots[i].mins, ic.iteminfoSlots[i].maxs)
                        Log_Write("item %s reachable from jumppad area %d\r\n", ic.iteminfoSlots[i].classname, goalareanum)
                        //botimport.Print(PRT_MESSAGE, "item %s reachable from jumppad area %d\r\n", ic->iteminfo[i].classname, goalareanum);
                        if goalareanum == 0 {
                            ent = AAS_NextBSPEntity(ent)
                            continue
                        }
                    }
                }
            }

            guard let li = AllocLevelItem() else { return }
            //
            numlevelitems += 1
            li.number = numlevelitems
            li.timeout = 0
            li.entitynum = 0
            //
            li.flags = 0
            AAS_IntForBSPEpairKey(ent, "notfree", &value)
            if value != 0 { li.flags |= IFL_NOTFREE }
            AAS_IntForBSPEpairKey(ent, "notteam", &value)
            if value != 0 { li.flags |= IFL_NOTTEAM }
            AAS_IntForBSPEpairKey(ent, "notsingle", &value)
            if value != 0 { li.flags |= IFL_NOTSINGLE }
            AAS_IntForBSPEpairKey(ent, "notbot", &value)
            if value != 0 { li.flags |= IFL_NOTBOT }
            if strcmp(classname, "item_botroam") == 0 {
                li.flags |= IFL_ROAM
                AAS_FloatForBSPEpairKey(ent, "weight", &li.weight)
            }
            //if not a stationary item
            if (spawnflags & 1) == 0 {
                if AAS_DropToFloor(&origin, ic.iteminfoSlots[i].mins, ic.iteminfoSlots[i].maxs) == 0 {
                    botimport.runPrint(PRT_MESSAGE, "%s in solid at (%1.1f %1.1f %1.1f)\n", String(classname), origin[0], origin[1], origin[2])
                }
            }
            //item info of the level item
            li.iteminfo = i
            //origin of the item
            li.origin = origin
            //
            if goalareanum != 0 {
                li.goalareanum = goalareanum
                li.goalorigin = origin
            } else {
                //get the item goal area and goal origin
                li.goalareanum = AAS_BestReachableArea(origin, ic.iteminfoSlots[i].mins, ic.iteminfoSlots[i].maxs, &li.goalorigin)
                if li.goalareanum == 0 {
                    botimport.runPrint(PRT_MESSAGE, "%s not reachable for bots at (%1.1f %1.1f %1.1f)\n", String(classname), origin[0], origin[1], origin[2])
                }
            }
            //
            AddLevelItemToList(li)
            ent = AAS_NextBSPEntity(ent)
        }
        botimport.runPrint(PRT_MESSAGE, "found %d level items\n", numlevelitems)
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:663
public func BotGoalName(_ number: Int32, _ name: inout JKAShared.CharBuf, _ size: Int32) {
    var li: Levelitem?

    if itemconfig == nil { return }
    //
    li = levelitems
    while li != nil {
        if li!.number == number {
            strncpy(&name, itemconfig!.iteminfoSlots[li!.iteminfo].name, size - 1)
            name[size - 1] = 0
            return
        }
        li = li!.next
    }
    strcpy(&name, "")
    return
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:687
public func BotResetAvoidGoals(_ goalstate: Int32) {
    guard let gs = BotGoalStateFromHandle(goalstate) else { return }
    gs.avoidgoals.fill(0)
    gs.avoidgoaltimes.fill(0)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:702
public func BotDumpAvoidGoals(_ goalstate: Int32) {
    var i: Int32
    var name = CharBuf(32)

    guard let gs = BotGoalStateFromHandle(goalstate) else { return }
    i = 0
    while i < MAX_AVOIDGOALS {
        if gs.avoidgoaltimes[i] >= AAS_Time() {
            BotGoalName(gs.avoidgoals[i], &name, 32)
            Log_Write("avoid goal %s, number %d for %f seconds", name, gs.avoidgoals[i], gs.avoidgoaltimes[i] - AAS_Time())
        }
        i += 1
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:726
public func BotAddToAvoidGoals(_ gs: BotGoalstate, _ number: Int32, _ avoidtime: Float) {
    var i: Int32

    i = 0
    while i < MAX_AVOIDGOALS {
        //if the avoid goal is already stored
        if gs.avoidgoals[i] == number {
            gs.avoidgoals[i] = number
            gs.avoidgoaltimes[i] = AAS_Time() + avoidtime
            return
        }
        i += 1
    }

    i = 0
    while i < MAX_AVOIDGOALS {
        //if this avoid goal has expired
        if gs.avoidgoaltimes[i] < AAS_Time() {
            gs.avoidgoals[i] = number
            gs.avoidgoaltimes[i] = AAS_Time() + avoidtime
            return
        }
        i += 1
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:758
public func BotRemoveFromAvoidGoals(_ goalstate: Int32, _ number: Int32) {
    var i: Int32

    guard let gs = BotGoalStateFromHandle(goalstate) else { return }
    //don't use the goals the bot wants to avoid
    i = 0
    while i < MAX_AVOIDGOALS {
        if gs.avoidgoals[i] == number && gs.avoidgoaltimes[i] >= AAS_Time() {
            gs.avoidgoaltimes[i] = 0
            return
        }
        i += 1
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:781
public func BotAvoidGoalTime(_ goalstate: Int32, _ number: Int32) -> Float {
    var i: Int32

    guard let gs = BotGoalStateFromHandle(goalstate) else { return 0 }
    //don't use the goals the bot wants to avoid
    i = 0
    while i < MAX_AVOIDGOALS {
        if gs.avoidgoals[i] == number && gs.avoidgoaltimes[i] >= AAS_Time() {
            return gs.avoidgoaltimes[i] - AAS_Time()
        }
        i += 1
    }
    return 0
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:804
public func BotSetAvoidGoalTime(_ goalstate: Int32, _ number: Int32, _ avoidtime: Float) {
    var avoidtime = avoidtime
    var li: Levelitem?

    guard let gs = BotGoalStateFromHandle(goalstate) else { return }
    if avoidtime < 0 {
        if itemconfig == nil {
            return
        }
        //
        li = levelitems
        while li != nil {
            if li!.number == number {
                avoidtime = itemconfig!.iteminfoSlots[li!.iteminfo].respawntime
                if avoidtime == 0 {
                    avoidtime = Float(AVOID_DEFAULT_TIME)
                }
                if avoidtime < AVOID_MINIMUM_TIME {
                    avoidtime = Float(AVOID_MINIMUM_TIME)
                }
                BotAddToAvoidGoals(gs, number, avoidtime)
                return
            }
            li = li!.next
        }
        return
    } else {
        BotAddToAvoidGoals(gs, number, avoidtime)
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:843
public func BotGetLevelItemGoal(_ index: Int32, _ name: String, _ goal: BotGoal) -> Int32 {
    var li: Levelitem?

    if itemconfig == nil { return -1 }
    li = levelitems
    if index >= 0 {
        while li != nil {
            if li!.number == index {
                li = li!.next
                break
            }
            li = li!.next
        }
    }
    while li != nil {
        //
        if g_gametype == GT_SINGLE_PLAYER {
            if (li!.flags & IFL_NOTSINGLE) != 0 {
                li = li!.next
                continue
            }
        } else if g_gametype >= GT_TEAM {
            if (li!.flags & IFL_NOTTEAM) != 0 {
                li = li!.next
                continue
            }
        } else {
            if (li!.flags & IFL_NOTFREE) != 0 {
                li = li!.next
                continue
            }
        }
        if (li!.flags & IFL_NOTBOT) != 0 {
            li = li!.next
            continue
        }
        //
        if Q_stricmp(name, itemconfig!.iteminfoSlots[li!.iteminfo].name) == 0 {
            goal.areanum = li!.goalareanum
            goal.origin = li!.goalorigin
            goal.entitynum = li!.entitynum
            goal.mins = itemconfig!.iteminfoSlots[li!.iteminfo].mins
            goal.maxs = itemconfig!.iteminfoSlots[li!.iteminfo].maxs
            goal.number = li!.number
            goal.flags = GFL_ITEM
            if li!.timeout != 0 { goal.flags |= GFL_DROPPED }
            //botimport.Print(PRT_MESSAGE, "found li %s\n", itemconfig->iteminfo[li->iteminfo].name);
            return li!.number
        }
        li = li!.next
    }
    return -1
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:896
public func BotGetMapLocationGoal(_ name: String, _ goal: BotGoal) -> Int32 {
    var ml: Maplocation?
    let mins = vec3_t(-8, -8, -8), maxs = vec3_t(8, 8, 8)

    ml = maplocations
    while ml != nil {
        if Q_stricmp(ml!.name, name) == 0 {
            goal.areanum = ml!.areanum
            goal.origin = ml!.origin
            goal.entitynum = 0
            goal.mins = mins
            goal.maxs = maxs
            return 1
        }
        ml = ml!.next
    }
    return 0
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:921
public func BotGetNextCampSpotGoal(_ num: Int32, _ goal: BotGoal) -> Int32 {
    var num = num
    var i: Int32
    var cs: Campspot?
    let mins = vec3_t(-8, -8, -8), maxs = vec3_t(8, 8, 8)

    if num < 0 { num = 0 }
    i = num
    cs = campspots
    while cs != nil {
        i -= 1
        if i < 0 {
            goal.areanum = cs!.areanum
            goal.origin = cs!.origin
            goal.entitynum = 0
            goal.mins = mins
            goal.maxs = maxs
            return num + 1
        }
        cs = cs!.next
    }
    return 0
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:949
// Port-note: Dead under rule 20. The one call, at be_ai_goal.cpp:1156, is inside a comment block of BotUpdateEntityItems.
public func BotFindEntityForLevelItem(_ li: Levelitem) {
    // Raven's record lives to the end of his block, so the block is the closure.
    AasEntityinfo.scratch { entinfo in
        var ent: Int32, modelindex: Int32
        var ic: Itemconfig?
        var dir = vec3_t()

        ic = itemconfig
        if itemconfig == nil { return }
        ent = AAS_NextEntity(0)
        while ent != 0 {
            //get the model index of the entity
            modelindex = AAS_EntityModelindex(ent)
            //
            if modelindex == 0 {
                ent = AAS_NextEntity(ent)
                continue
            }
            //get info about the entity
            AAS_EntityInfo(ent, entinfo)
            //if the entity is still moving
            if entinfo.origin[0] != entinfo.lastvisorigin[0] ||
                    entinfo.origin[1] != entinfo.lastvisorigin[1] ||
                    entinfo.origin[2] != entinfo.lastvisorigin[2] {
                ent = AAS_NextEntity(ent)
                continue
            }
            //
            if ic!.iteminfoSlots[li.iteminfo].modelindex == modelindex {
                //check if the entity is very close
                dir = li.origin - entinfo.origin
                if VectorLength(dir) < 30 {
                    //found an entity for this level item
                    li.entitynum = ent
                } //end if
            } //end if
            ent = AAS_NextEntity(ent)
        } //end for
    }
}

/// Source: oracle/codemp/botlib/be_ai_goal.cpp:993
public func BotUpdateEntityItems() {
    // Raven's record lives to the end of his block, so the block is the closure.
    AasEntityinfo.scratch { entinfo in
        var ent: Int32, i: Int32, modelindex: Int32
        var dir = vec3_t()
        var li: Levelitem?, nextli: Levelitem?

        //timeout current entity items if necessary
        li = levelitems
        while li != nil {
            nextli = li!.next
            //if it is a item that will time out
            if li!.timeout != 0 {
                //timeout the item
                if li!.timeout < AAS_Time() {
                    RemoveLevelItemFromList(li!)
                    FreeLevelItem(li!)
                }
            }
            li = nextli
        }
        //find new entity items
        guard let ic = itemconfig else { return }
        //
        ent = AAS_NextEntity(0)
        while ent != 0 {
            if AAS_EntityType(ent) != ET_ITEM {
                ent = AAS_NextEntity(ent)
                continue
            }
            //get the model index of the entity
            modelindex = AAS_EntityModelindex(ent)
            //
            if modelindex == 0 {
                ent = AAS_NextEntity(ent)
                continue
            }
            //get info about the entity
            AAS_EntityInfo(ent, entinfo)
            //FIXME: don't do this
            //skip all floating items for now
            //if (entinfo.groundent != ENTITYNUM_WORLD) continue;
            //if the entity is still moving
            if entinfo.origin[0] != entinfo.lastvisorigin[0] ||
                entinfo.origin[1] != entinfo.lastvisorigin[1] ||
                entinfo.origin[2] != entinfo.lastvisorigin[2] {
                ent = AAS_NextEntity(ent)
                continue
            }
            //check if the entity is already stored as a level item
            li = levelitems
            while li != nil {
                //if the level item is linked to an entity
                if li!.entitynum != 0 && li!.entitynum == ent {
                    //the entity is re-used if the models are different
                    if ic.iteminfoSlots[li!.iteminfo].modelindex != modelindex {
                        //remove this level item
                        RemoveLevelItemFromList(li!)
                        FreeLevelItem(li!)
                        li = nil
                        break
                    } else {
                        if entinfo.origin[0] != li!.origin[0] ||
                            entinfo.origin[1] != li!.origin[1] ||
                            entinfo.origin[2] != li!.origin[2] {
                            li!.origin = entinfo.origin
                            //also update the goal area number
                            li!.goalareanum = AAS_BestReachableArea(li!.origin, ic.iteminfoSlots[li!.iteminfo].mins, ic.iteminfoSlots[li!.iteminfo].maxs, &li!.goalorigin)
                        }
                        break
                    }
                }
                li = li!.next
            }
            if li != nil {
                ent = AAS_NextEntity(ent)
                continue
            }
            //try to link the entity to a level item
            li = levelitems
            while li != nil {
                //if this level item is already linked
                if li!.entitynum != 0 {
                    li = li!.next
                    continue
                }
                //
                if g_gametype == GT_SINGLE_PLAYER {
                    if (li!.flags & IFL_NOTSINGLE) != 0 {
                        li = li!.next
                        continue
                    }
                } else if g_gametype >= GT_TEAM {
                    if (li!.flags & IFL_NOTTEAM) != 0 {
                        li = li!.next
                        continue
                    }
                } else {
                    if (li!.flags & IFL_NOTFREE) != 0 {
                        li = li!.next
                        continue
                    }
                }
                //if the model of the level item and the entity are the same
                if ic.iteminfoSlots[li!.iteminfo].modelindex == modelindex {
                    //check if the entity is very close
                    dir = li!.origin - entinfo.origin
                    if VectorLength(dir) < 30 {
                        //found an entity for this level item
                        li!.entitynum = ent
                        //if the origin is different
                        if entinfo.origin[0] != li!.origin[0] ||
                            entinfo.origin[1] != li!.origin[1] ||
                            entinfo.origin[2] != li!.origin[2] {
                            //update the level item origin
                            li!.origin = entinfo.origin
                            //also update the goal area number
                            li!.goalareanum = AAS_BestReachableArea(li!.origin, ic.iteminfoSlots[li!.iteminfo].mins, ic.iteminfoSlots[li!.iteminfo].maxs, &li!.goalorigin)
                        }
                        break
                    }
                }
                li = li!.next
            }
            if li != nil {
                ent = AAS_NextEntity(ent)
                continue
            }
            //check if the model is from a known item
            i = 0
            while i < ic.numiteminfo {
                if ic.iteminfoSlots[i].modelindex == modelindex {
                    break
                }
                i += 1
            }
            //if the model is not from a known item
            if i >= ic.numiteminfo {
                ent = AAS_NextEntity(ent)
                continue
            }
            //allocate a new level item
            li = AllocLevelItem()
            //
            if li == nil {
                ent = AAS_NextEntity(ent)
                continue
            }
            //entity number of the level item
            li!.entitynum = ent
            //number for the level item
            li!.number = numlevelitems + ent
            //set the item info index for the level item
            li!.iteminfo = i
            //origin of the item
            li!.origin = entinfo.origin
            //get the item goal area and goal origin
            li!.goalareanum = AAS_BestReachableArea(li!.origin, ic.iteminfoSlots[i].mins, ic.iteminfoSlots[i].maxs, &li!.goalorigin)
            //never go for items dropped into jumppads
            if AAS_AreaJumpPad(li!.goalareanum) != 0 {
                FreeLevelItem(li!)
                ent = AAS_NextEntity(ent)
                continue
            }
            //time this item out after 30 seconds
            //dropped items disappear after 30 seconds
            li!.timeout = AAS_Time() + 30
            //add the level item to the list
            AddLevelItemToList(li!)
            //botimport.Print(PRT_MESSAGE, "found new level item %s\n", ic->iteminfo[i].classname);
            ent = AAS_NextEntity(ent)
        }
        /*
        for (li = levelitems; li; li = li->next)
        {
            if (!li->entitynum)
            {
                BotFindEntityForLevelItem(li);
            } //end if
        } //end for*/
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:1166
public func BotDumpGoalStack(_ goalstate: Int32) {
    var i: Int32
    var name = CharBuf(32)

    guard let gs = BotGoalStateFromHandle(goalstate) else { return }
    i = 1
    while i <= gs.goalstacktop {
        BotGoalName(gs.goalstack[i].number, &name, 32)
        Log_Write("%d: %s", i, name)
        i += 1
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:1186
public func BotPushGoal(_ goalstate: Int32, _ goal: BotGoal) {
    guard let gs = BotGoalStateFromHandle(goalstate) else { return }
    if gs.goalstacktop >= MAX_GOALSTACK - 1 {
        botimport.runPrint(PRT_ERROR, "goal heap overflow\n")
        BotDumpGoalStack(goalstate)
        return
    }
    gs.goalstacktop += 1
    gs.goalstack[gs.goalstacktop].copy(from: goal)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:1207
public func BotPopGoal(_ goalstate: Int32) {
    guard let gs = BotGoalStateFromHandle(goalstate) else { return }
    if gs.goalstacktop > 0 { gs.goalstacktop -= 1 }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:1221
public func BotEmptyGoalStack(_ goalstate: Int32) {
    guard let gs = BotGoalStateFromHandle(goalstate) else { return }
    gs.goalstacktop = 0
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:1235
public func BotGetTopGoal(_ goalstate: Int32, _ goal: BotGoal) -> Int32 {
    guard let gs = BotGoalStateFromHandle(goalstate) else { return 0 }
    if gs.goalstacktop == 0 { return 0 }
    goal.copy(from: gs.goalstack[gs.goalstacktop])
    return 1
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:1251
public func BotGetSecondGoal(_ goalstate: Int32, _ goal: BotGoal) -> Int32 {
    guard let gs = BotGoalStateFromHandle(goalstate) else { return 0 }
    if gs.goalstacktop <= 1 { return 0 }
    goal.copy(from: gs.goalstack[gs.goalstacktop - 1])
    return 1
}

//===========================================================================
// pops a new long term goal on the goal stack in the goalstate
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:1268
public func BotChooseLTGItem(_ goalstate: Int32, _ origin: JKAShared.vec3_t, _ inventory: Slots<Int32>, _ travelflags: Int32) -> Int32 {
    // Raven's record lives to the end of his block, so the block is the closure.
    return BotGoal.scratch { goal -> Int32 in
        var areanum: Int32, t: Int32, weightnum: Int32
        var weight: Float, bestweight: Float, avoidtime: Float
        var iteminfo: Iteminfo
        var li: Levelitem?, bestitem: Levelitem?

        guard let gs = BotGoalStateFromHandle(goalstate) else {
            return 0
        }
        if gs.itemweightconfig == nil {
            return 0
        }
        //get the area the bot is in
        areanum = BotReachabilityArea(origin, gs.client)
        //if the bot is in solid or if the area the bot is in has no reachability links
        if areanum == 0 || AAS_AreaReachability(areanum) == 0 {
            //use the last valid area the bot was in
            areanum = gs.lastreachabilityarea
        }
        //remember the last area with reachabilities the bot was in
        gs.lastreachabilityarea = areanum
        //if still in solid
        if areanum == 0 {
            return 0
        }
        //the item configuration
        guard let ic = itemconfig else {
            return 0
        }
        //best weight and item so far
        bestweight = 0
        bestitem = nil
        //go through the items in the level
        li = levelitems
        while li != nil {
            if g_gametype == GT_SINGLE_PLAYER {
                if (li!.flags & IFL_NOTSINGLE) != 0 {
                    li = li!.next
                    continue
                }
            } else if g_gametype >= GT_TEAM {
                if (li!.flags & IFL_NOTTEAM) != 0 {
                    li = li!.next
                    continue
                }
            } else {
                if (li!.flags & IFL_NOTFREE) != 0 {
                    li = li!.next
                    continue
                }
            }
            if (li!.flags & IFL_NOTBOT) != 0 {
                li = li!.next
                continue
            }
            //if the item is not in a possible goal area
            if li!.goalareanum == 0 {
                li = li!.next
                continue
            }
            //FIXME: is this a good thing? added this for items that never spawned into the game (f.i. CTF flags in obelisk)
            if li!.entitynum == 0 && (li!.flags & IFL_ROAM) == 0 {
                li = li!.next
                continue
            }
            //get the fuzzy weight function for this item
            iteminfo = ic.iteminfoSlots[li!.iteminfo]
            weightnum = gs.itemweightindex![iteminfo.number]
            if weightnum < 0 {
                li = li!.next
                continue
            }

            weight = FuzzyWeightUndecided(inventory, gs.itemweightconfig!, weightnum)
            //HACK: to make dropped items more attractive
            if li!.timeout != 0 {
                weight += droppedweight!.value
            }
            //use weight scale for item_botroam
            if (li!.flags & IFL_ROAM) != 0 { weight *= li!.weight }
            //
            if weight > 0 {
                //get the travel time towards the goal area
                t = AAS_AreaTravelTimeToGoalArea(areanum, origin, li!.goalareanum, travelflags)
                //if the goal is reachable
                if t > 0 {
                    //if this item won't respawn before we get there
                    avoidtime = BotAvoidGoalTime(goalstate, li!.number)
                    if Double(avoidtime) - Double(t) * 0.009 > 0 {
                        li = li!.next
                        continue
                    }
                    //
                    weight = Float(Double(weight) / (Double(Float(t)) * TRAVELTIME_SCALE))
                    //
                    if weight > bestweight {
                        bestweight = weight
                        bestitem = li
                    }
                }
            }
            li = li!.next
        }
        //if no goal item found
        if bestitem == nil {
            /*
            //if not in lava or slime
            if (!AAS_AreaLava(areanum) && !AAS_AreaSlime(areanum))
            {
                if (AAS_RandomGoalArea(areanum, travelflags, &goal.areanum, goal.origin))
                {
                    VectorSet(goal.mins, -15, -15, -15);
                    VectorSet(goal.maxs, 15, 15, 15);
                    goal.entitynum = 0;
                    goal.number = 0;
                    goal.flags = GFL_ROAM;
                    goal.iteminfo = 0;
                    //push the goal on the stack
                    BotPushGoal(goalstate, &goal);
                    //
    #ifdef DEBUG
                    botimport.Print(PRT_MESSAGE, "chosen roam goal area %d\n", goal.areanum);
    #endif //DEBUG
                    return qtrue;
                } //end if
            } //end if
            */
            return 0
        }
        //create a bot goal for this item
        iteminfo = ic.iteminfoSlots[bestitem!.iteminfo]
        goal.origin = bestitem!.goalorigin
        goal.mins = iteminfo.mins
        goal.maxs = iteminfo.maxs
        goal.areanum = bestitem!.goalareanum
        goal.entitynum = bestitem!.entitynum
        goal.number = bestitem!.number
        goal.flags = GFL_ITEM
        if bestitem!.timeout != 0 {
            goal.flags |= GFL_DROPPED
        }
        if (bestitem!.flags & IFL_ROAM) != 0 {
            goal.flags |= GFL_ROAM
        }
        goal.iteminfo = bestitem!.iteminfo
        //if it's a dropped item
        if bestitem!.timeout != 0 {
            avoidtime = Float(AVOID_DROPPED_TIME)
        } else {
            avoidtime = iteminfo.respawntime
            if avoidtime == 0 {
                avoidtime = Float(AVOID_DEFAULT_TIME)
            }
            if avoidtime < AVOID_MINIMUM_TIME {
                avoidtime = Float(AVOID_MINIMUM_TIME)
            }
        }
        //add the chosen goal to the goals to avoid for a while
        BotAddToAvoidGoals(gs, bestitem!.number, avoidtime)
        //push the goal on the stack
        BotPushGoal(goalstate, goal)
        //
        return 1
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:1435
public func BotChooseNBGItem(_ goalstate: Int32, _ origin: JKAShared.vec3_t, _ inventory: Slots<Int32>, _ travelflags: Int32, _ ltg: BotGoal, _ maxtime: Float) -> Int32 {
    // Raven's record lives to the end of his block, so the block is the closure.
    return BotGoal.scratch { goal -> Int32 in
        var areanum: Int32, t: Int32, weightnum: Int32, ltg_time: Int32
        var weight: Float, bestweight: Float, avoidtime: Float
        var iteminfo: Iteminfo
        var li: Levelitem?, bestitem: Levelitem?

        guard let gs = BotGoalStateFromHandle(goalstate) else {
            return 0
        }
        if gs.itemweightconfig == nil {
            return 0
        }
        //get the area the bot is in
        areanum = BotReachabilityArea(origin, gs.client)
        //if the bot is in solid or if the area the bot is in has no reachability links
        if areanum == 0 || AAS_AreaReachability(areanum) == 0 {
            //use the last valid area the bot was in
            areanum = gs.lastreachabilityarea
        }
        //remember the last area with reachabilities the bot was in
        gs.lastreachabilityarea = areanum
        //if still in solid
        if areanum == 0 {
            return 0
        }
        //
        ltg_time = AAS_AreaTravelTimeToGoalArea(areanum, origin, ltg.areanum, travelflags)
        //the item configuration
        guard let ic = itemconfig else {
            return 0
        }
        //best weight and item so far
        bestweight = 0
        bestitem = nil
        //go through the items in the level
        li = levelitems
        while li != nil {
            if g_gametype == GT_SINGLE_PLAYER {
                if (li!.flags & IFL_NOTSINGLE) != 0 {
                    li = li!.next
                    continue
                }
            } else if g_gametype >= GT_TEAM {
                if (li!.flags & IFL_NOTTEAM) != 0 {
                    li = li!.next
                    continue
                }
            } else {
                if (li!.flags & IFL_NOTFREE) != 0 {
                    li = li!.next
                    continue
                }
            }
            if (li!.flags & IFL_NOTBOT) != 0 {
                li = li!.next
                continue
            }
            //if the item is in a possible goal area
            if li!.goalareanum == 0 {
                li = li!.next
                continue
            }
            //FIXME: is this a good thing? added this for items that never spawned into the game (f.i. CTF flags in obelisk)
            if li!.entitynum == 0 && (li!.flags & IFL_ROAM) == 0 {
                li = li!.next
                continue
            }
            //get the fuzzy weight function for this item
            iteminfo = ic.iteminfoSlots[li!.iteminfo]
            weightnum = gs.itemweightindex![iteminfo.number]
            if weightnum < 0 {
                li = li!.next
                continue
            }
            //
            weight = FuzzyWeightUndecided(inventory, gs.itemweightconfig!, weightnum)
            //HACK: to make dropped items more attractive
            if li!.timeout != 0 {
                weight += droppedweight!.value
            }
            //use weight scale for item_botroam
            if (li!.flags & IFL_ROAM) != 0 { weight *= li!.weight }
            //
            if weight > 0 {
                //get the travel time towards the goal area
                t = AAS_AreaTravelTimeToGoalArea(areanum, origin, li!.goalareanum, travelflags)
                //if the goal is reachable
                if t > 0 && t < maxtime {
                    //if this item won't respawn before we get there
                    avoidtime = BotAvoidGoalTime(goalstate, li!.number)
                    if Double(avoidtime) - Double(t) * 0.009 > 0 {
                        li = li!.next
                        continue
                    }
                    //
                    weight = Float(Double(weight) / (Double(Float(t)) * TRAVELTIME_SCALE))
                    //
                    if weight > bestweight {
                        t = 0
                        if li!.timeout == 0 {
                            //get the travel time from the goal to the long term goal
                            t = AAS_AreaTravelTimeToGoalArea(li!.goalareanum, li!.goalorigin, ltg.areanum, travelflags)
                        }
                        //if the travel back is possible and doesn't take too long
                        if t <= ltg_time {
                            bestweight = weight
                            bestitem = li
                        }
                    }
                }
            }
            li = li!.next
        }
        //if no goal item found
        if bestitem == nil {
            return 0
        }
        //create a bot goal for this item
        iteminfo = ic.iteminfoSlots[bestitem!.iteminfo]
        goal.origin = bestitem!.goalorigin
        goal.mins = iteminfo.mins
        goal.maxs = iteminfo.maxs
        goal.areanum = bestitem!.goalareanum
        goal.entitynum = bestitem!.entitynum
        goal.number = bestitem!.number
        goal.flags = GFL_ITEM
        if bestitem!.timeout != 0 {
            goal.flags |= GFL_DROPPED
        }
        if (bestitem!.flags & IFL_ROAM) != 0 {
            goal.flags |= GFL_ROAM
        }
        goal.iteminfo = bestitem!.iteminfo
        //if it's a dropped item
        if bestitem!.timeout != 0 {
            avoidtime = Float(AVOID_DROPPED_TIME)
        } else {
            avoidtime = iteminfo.respawntime
            if avoidtime == 0 {
                avoidtime = Float(AVOID_DEFAULT_TIME)
            }
            if avoidtime < AVOID_MINIMUM_TIME {
                avoidtime = Float(AVOID_MINIMUM_TIME)
            }
        }
        //add the chosen goal to the goals to avoid for a while
        BotAddToAvoidGoals(gs, bestitem!.number, avoidtime)
        //push the goal on the stack
        BotPushGoal(goalstate, goal)
        //
        return 1
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:1592
public func BotTouchingGoal(_ origin: JKAShared.vec3_t, _ goal: BotGoal) -> Int32 {
    var i: Int32
    var boxmins = vec3_t(), boxmaxs = vec3_t()
    var absmins = vec3_t(), absmaxs = vec3_t()
    let safety_maxs = vec3_t(0, 0, 0) //{4, 4, 10};
    let safety_mins = vec3_t(0, 0, 0) //{-4, -4, 0};

    AAS_PresenceTypeBoundingBox(PRESENCE_NORMAL, &boxmins, &boxmaxs)
    absmins = goal.mins - boxmaxs
    absmaxs = goal.maxs - boxmins
    absmins = absmins + goal.origin
    absmaxs = absmaxs + goal.origin
    //make the box a little smaller for safety
    absmaxs = absmaxs - safety_maxs
    absmins = absmins - safety_mins

    i = 0
    while i < 3 {
        if origin[i] < absmins[i] || origin[i] > absmaxs[i] { return 0 }
        i += 1
    }
    return 1
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:1621
public func BotItemGoalInVisButNotVisible(_ viewer: Int32, _ eye: JKAShared.vec3_t, _ viewangles: JKAShared.vec3_t, _ goal: BotGoal) -> Int32 {
    var middle = vec3_t()

    // Raven's records live to the end of his block, so the block is the closure.
    return AasEntityinfo.scratch { entinfo -> Int32 in
        BspTrace.scratch { trace -> Int32 in
            if (goal.flags & GFL_ITEM) == 0 { return 0 }
            //
            middle = goal.mins + goal.mins
            middle = middle * 0.5
            middle = goal.origin + middle
            //
            trace.copy(from: AAS_Trace(eye, nil, nil, middle, viewer, CONTENTS_SOLID))
            //if the goal middle point is visible
            if trace.fraction >= 1 {
                //the goal entity number doesn't have to be valid
                //just assume it's valid
                if goal.entitynum <= 0 {
                    return 0
                }
                //
                //if the entity data isn't valid
                AAS_EntityInfo(goal.entitynum, entinfo)
                //NOTE: for some wacko reason entities are sometimes
                // not updated
                //if (!entinfo.valid) return qtrue;
                if Double(entinfo.ltime) < Double(AAS_Time()) - 0.5 {
                    return 1
                }
            }
            return 0
        }
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:1658
public func BotResetGoalState(_ goalstate: Int32) {
    guard let gs = BotGoalStateFromHandle(goalstate) else { return }
    gs.goalstack.zero()
    gs.goalstacktop = 0
    BotResetAvoidGoals(goalstate)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:1674
public func BotLoadItemWeights(_ goalstate: Int32, _ filename: inout JKAShared.CharBuf) -> Int32 {
    guard let gs = BotGoalStateFromHandle(goalstate) else { return BLERR_CANNOTLOADITEMWEIGHTS }
    //load the weight configuration
    gs.itemweightconfig = ReadWeightConfig(&filename)
    if gs.itemweightconfig == nil {
        botimport.runPrint(PRT_FATAL, "couldn't load weights\n")
        return BLERR_CANNOTLOADITEMWEIGHTS
    }
    //if there's no item configuration
    if itemconfig == nil { return BLERR_CANNOTLOADITEMWEIGHTS }
    //create the item weight index
    gs.itemweightindex = ItemWeightIndex(gs.itemweightconfig!, itemconfig!)
    //everything went ok
    return BLERR_NOERROR
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:1700
public func BotFreeItemWeights(_ goalstate: Int32) {
    guard let gs = BotGoalStateFromHandle(goalstate) else { return }
    if gs.itemweightconfig != nil { FreeWeightConfig(gs.itemweightconfig!) }
    if gs.itemweightindex != nil { FreeMemory(OpaquePointer(gs.itemweightindex!.base)) }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:1715
public func BotAllocGoalState(_ client: Int32) -> Int32 {
    var i: Int32

    i = 1
    while i <= MAX_CLIENTS {
        if botgoalstates[i] == nil {
            botgoalstates[i] = BotGoalstate(GetClearedMemory(UInt32(BotGoalstate.byteCount)))
            botgoalstates[i]!.client = client
            return i
        }
        i += 1
    }
    return 0
}

//========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:1736
public func BotFreeGoalState(_ handle: Int32) {
    if handle <= 0 || handle > MAX_CLIENTS {
        botimport.runPrint(PRT_FATAL, "goal state handle %d out of range\n", handle)
        return
    }
    if botgoalstates[handle] == nil {
        botimport.runPrint(PRT_FATAL, "invalid goal state handle %d\n", handle)
        return
    }
    BotFreeItemWeights(handle)
    FreeMemory(botgoalstates[handle]!.handle)
    botgoalstates[handle] = nil
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:1758
public func BotSetupGoalAI() -> Int32 {
    var filename: String

    //check if teamplay is on
    g_gametype = Int32(LibVarValue("g_gametype", "0"))
    //item configuration file
    filename = LibVarString("itemconfig", "items.c")
    //load the item configuration
    itemconfig = LoadItemConfig(filename)
    if itemconfig == nil {
        botimport.runPrint(PRT_FATAL, "couldn't load item config\n")
        return BLERR_CANNOTLOADITEMCONFIG
    }
    //
    droppedweight = LibVar("droppedweight", "1000")
    //everything went ok
    return BLERR_NOERROR
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_goal.cpp:1784
public func BotShutdownGoalAI() {
    var i: Int32

    if itemconfig != nil { FreeMemory(itemconfig!.handle) }
    itemconfig = nil
    if levelitemheap != nil { FreeMemory(OpaquePointer(levelitemheap!.base)) }
    levelitemheap = nil
    freelevelitems = nil
    levelitems = nil
    numlevelitems = 0

    BotFreeInfoEntities()

    i = 1
    while i <= MAX_CLIENTS {
        if botgoalstates[i] != nil {
            BotFreeGoalState(i)
        }
        i += 1
    }
}
