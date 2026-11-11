import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:30
private let ON_EPSILON = 0.005 as Double

/// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:33
private let MAX_BSPENTITIES = 2048 as Int32

/// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:70
public var bspworld: Bsp { world.storage.bspworld }

//===========================================================================
// traces axial boxes of any size through the world
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:132
// AI: Raven declares `bsptrace` on the stack of AAS_Trace. The function uses one zeroed allocation on the storage class.
var bsptrace_AAS_Trace: BspTrace { world.storage.bsptrace_AAS_Trace }

/// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:130
public func AAS_Trace(_ start: JKAShared.vec3_t, _ mins: JKAShared.vec3_t?, _ maxs: JKAShared.vec3_t?, _ end: JKAShared.vec3_t, _ passent: Int32, _ contentmask: Int32) -> BspTrace {
    let bsptrace = bsptrace_AAS_Trace
    // The engine only reads the four vectors, at sv_bot.cpp:312, so the copies are behavior-equal.
    // SV_Trace reads a NULL `mins` or `maxs` as the zero vector, so a scratch zero vector stands for NULL.
    var start = start, mins = mins ?? vec3_t(), maxs = maxs ?? vec3_t(), end = end
    botimport.runTrace(bsptrace, &start, &mins, &maxs, &end, passent, contentmask)
    return bsptrace
}

//===========================================================================
// returns the contents at the given point
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:143
public func AAS_PointContents(_ point: JKAShared.vec3_t) -> Int32 {
    // The engine only reads the point, at sv_bot.cpp:360, so the copy is behavior-equal.
    var point = point
    return botimport.runPointContents(&point)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:153
public func AAS_EntityCollision(_ entnum: Int32, _ start: JKAShared.vec3_t, _ boxmins: JKAShared.vec3_t, _ boxmaxs: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ contentmask: Int32, _ trace: BspTrace) -> Bool {
    return BspTrace.scratch { enttrace -> Bool in
        // The engine only reads the four vectors, at sv_bot.cpp:334, so the copies are behavior-equal.
        var start = start, boxmins = boxmins, boxmaxs = boxmaxs, end = end
        botimport.runEntityTrace(enttrace, &start, &boxmins, &boxmaxs, &end, entnum, contentmask)
        if enttrace.fraction < trace.fraction {
            trace.copy(from: enttrace)
            return true
        } //end if
        return false
    }
}

//===========================================================================
// returns true if in Potentially Hearable Set
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:174
public func AAS_inPVS(_ p1: JKAShared.vec3_t, _ p2: JKAShared.vec3_t) -> Bool {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // The engine only reads the two points, at sv_bot.cpp:370, so the copies are behavior-equal.
    var p1 = p1, p2 = p2
    return botimport.runInPVS(&p1, &p2) != 0
}

//===========================================================================
// returns true if in Potentially Visible Set
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:185
public func AAS_inPHS(_ p1: JKAShared.vec3_t, _ p2: JKAShared.vec3_t) -> Bool {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    return true
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:195
public func AAS_BSPModelMinsMaxsOrigin(_ modelnum: Int32, _ angles: JKAShared.vec3_t, _ mins: inout JKAShared.vec3_t, _ maxs: inout JKAShared.vec3_t, _ origin: inout JKAShared.vec3_t) {
    // The engine only reads the angles, at sv_bot.cpp:396, so the copy is behavior-equal.
    var angles = angles
    botimport.runBSPModelMinsMaxsOrigin(modelnum, &angles, &mins, &maxs, &origin)
}

//===========================================================================
// unlinks the entity from all leaves
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:206
public func AAS_UnlinkFromBSPLeaves(_ leaves: BspLink?) {
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:215
public func AAS_BSPLinkEntity(_ absmins: JKAShared.vec3_t, _ absmaxs: JKAShared.vec3_t, _ entnum: Int32, _ modelnum: Int32) -> BspLink? {
    return nil
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:225
public func AAS_BoxEntities(_ absmins: JKAShared.vec3_t, _ absmaxs: JKAShared.vec3_t, _ list: Slots<Int32>, _ maxcount: Int32) -> Int32 {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    return 0
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:235
public func AAS_NextBSPEntity(_ ent: Int32) -> Int32 {
    var ent = ent
    ent += 1
    if ent >= 1 && ent < bspworld.numentities { return ent }
    return 0
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:247
public func AAS_BSPEntityInRange(_ ent: Int32) -> Int32 {
    if ent <= 0 || ent >= bspworld.numentities {
        botimport.runPrint(PRT_MESSAGE, "bsp entity out of range\n")
        return 0
    } //end if
    return 1
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:262
public func AAS_ValueForBSPEpairKey(_ ent: Int32, _ key: String, _ value: inout JKAShared.CharBuf, _ size: Int32) -> Int32 {
    var epair: BspEpair?

    value[0] = 0
    if AAS_BSPEntityInRange(ent) == 0 { return 0 }
    epair = bspworld.entities[ent].epairs
    while epair != nil {
        if strcmp(epair!.key!, key) == 0 {
            strncpy(&value, epair!.value!, size - 1)
            value[size - 1] = 0
            return 1
        } //end if
        epair = epair!.next
    } //end for
    return 0
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:285
public func AAS_VectorForBSPEpairKey(_ ent: Int32, _ key: String, _ v: inout JKAShared.vec3_t) -> Int32 {
    var buf = CharBuf(MAX_EPAIRKEY)
    var v1: Double, v2: Double, v3: Double

    v = vec3_t()
    if AAS_ValueForBSPEpairKey(ent, key, &buf, MAX_EPAIRKEY) == 0 { return 0 }
    //scanf into doubles, then assign, so it is vec_t size independent
    v1 = 0
    v2 = 0
    v3 = 0
    sscanf(buf, "%lf %lf %lf", &v1, &v2, &v3)
    v[0] = Float(v1)
    v[1] = Float(v2)
    v[2] = Float(v3)
    return 1
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:306
public func AAS_FloatForBSPEpairKey(_ ent: Int32, _ key: String, _ value: inout Float) -> Int32 {
    var buf = CharBuf(MAX_EPAIRKEY)

    value = 0
    if AAS_ValueForBSPEpairKey(ent, key, &buf, MAX_EPAIRKEY) == 0 { return 0 }
    value = Float(atof(buf))
    return 1
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:321
public func AAS_IntForBSPEpairKey(_ ent: Int32, _ key: String, _ value: inout Int32) -> Int32 {
    var buf = CharBuf(MAX_EPAIRKEY)

    value = 0
    if AAS_ValueForBSPEpairKey(ent, key, &buf, MAX_EPAIRKEY) == 0 { return 0 }
    value = atoi(buf)
    return 1
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:336
public func AAS_FreeBSPEntities() {
    var i: Int32
    var ent: BspEntity
    var epair: BspEpair?, nextepair: BspEpair?

    i = 1
    while i < bspworld.numentities {
        ent = bspworld.entities[i]
        epair = ent.epairs
        while epair != nil {
            nextepair = epair!.next
            //
            // AI: Raven frees the key and the value text here. The view pools every string, so the two frees go.
            FreeMemory(epair!.handle)
            epair = nextepair
        } //end for
        i += 1
    } //end for
    bspworld.numentities = 0
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:362
public func AAS_ParseBSPEntities() {
    let script: Script

    script = LoadScriptMemory(bspworld.dentdata!, bspworld.entdatasize, "entdata")!
    SetScriptFlags(script, SCFL_NOSTRINGWHITESPACES | SCFL_NOSTRINGESCAPECHARS)//SCFL_PRIMITIVE);

    bspworld.numentities = 1

    Token.scratch { token in
        var ent: BspEntity
        var epair: BspEpair

        while PS_ReadToken(script, token) != 0 {
            if strcmp(token.string, "{") != 0 {
                ScriptError(script, "invalid %s\n", token.string)
                AAS_FreeBSPEntities()
                FreeScript(script)
                return
            } //end if
            if bspworld.numentities >= MAX_BSPENTITIES {
                botimport.runPrint(PRT_MESSAGE, "too many entities in BSP file\n")
                break
            } //end if
            ent = bspworld.entities[bspworld.numentities]
            bspworld.numentities += 1
            ent.epairs = nil
            while PS_ReadToken(script, token) != 0 {
                if strcmp(token.string, "}") == 0 { break }
                epair = BspEpair(GetClearedHunkMemory(Int32(BspEpair.byteCount)))
                epair.next = ent.epairs
                ent.epairs = epair
                if token.type != TT_STRING {
                    ScriptError(script, "invalid %s\n", token.string)
                    AAS_FreeBSPEntities()
                    FreeScript(script)
                    return
                } //end if
                StripDoubleQuotes(&token.stringBuffer)
                // AI: Raven copies the text into the GetHunkMemory block. The call stays for the hunk count, and the field takes the text.
                _ = GetHunkMemory(strlen(token.string) + 1)
                epair.key = token.string
                if PS_ExpectTokenType(script, TT_STRING, 0, token) == 0 {
                    AAS_FreeBSPEntities()
                    FreeScript(script)
                    return
                } //end if
                StripDoubleQuotes(&token.stringBuffer)
                // AI: Raven copies the text into the GetHunkMemory block. The call stays for the hunk count, and the field takes the text.
                _ = GetHunkMemory(strlen(token.string) + 1)
                epair.value = token.string
            } //end while
            if strcmp(token.string, "}") != 0 {
                ScriptError(script, "missing }\n")
                AAS_FreeBSPEntities()
                FreeScript(script)
                return
            } //end if
        } //end while
        FreeScript(script)
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:433
public func AAS_BSPTraceLight(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ endpos: JKAShared.vec3_t, _ red: inout Int32, _ green: inout Int32, _ blue: inout Int32) -> Int32 {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    return 0
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:443
public func AAS_DumpBSPData() {
    AAS_FreeBSPEntities()

    // AI: Raven frees the entity text here. The view pools every string, so the free goes.
    bspworld.dentdata = nil
    bspworld.entdatasize = 0
    //
    bspworld.loaded = 0
    bspworld.clear()
}

//===========================================================================
// load an bsp file
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:461
public func AAS_LoadBSPFile() -> Int32 {
    AAS_DumpBSPData()
    bspworld.entdatasize = strlen(botimport.runBSPEntityData()!) + 1
    // AI: Raven copies the entity text into the GetClearedHunkMemory block. The call stays for the hunk count, and the field takes the text.
    _ = GetClearedHunkMemory(bspworld.entdatasize)
    bspworld.dentdata = botimport.runBSPEntityData()
    AAS_ParseBSPEntities()
    bspworld.loaded = 1
    return BLERR_NOERROR
}
