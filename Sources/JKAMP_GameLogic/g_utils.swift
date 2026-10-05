import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_utils.c:15
let MAX_SHADER_REMAPS = 128 as Int32

/// Source: oracle/codemp/game/g_utils.c:17
var remapCount: Int32 {
    get { world.variables.remapCount }
    set { world.variables.remapCount = newValue }
}

/// Source: oracle/codemp/game/g_utils.c:18
var remappedShaders: Slots<ShaderRemap> { world.storage.remappedShaders }

/// Source: oracle/codemp/game/g_utils.c:384
let MAX_VEHICLES_AT_A_TIME = 128 as Int32

/// Source: oracle/codemp/game/g_utils.c:385
var g_vehiclePool: Slots<JKAMP.Vehicle> { world.storage.g_vehiclePool }

/// Source: oracle/codemp/game/g_utils.c:386
var g_vehiclePoolOccupied: [Bool] {
    get { world.variables.g_vehiclePoolOccupied }
    set { world.variables.g_vehiclePoolOccupied = newValue }
}

/// Source: oracle/codemp/game/g_utils.c:387
var g_vehiclePoolInit: Bool {
    get { world.variables.g_vehiclePoolInit }
    set { world.variables.g_vehiclePoolInit = newValue }
}

/// Source: oracle/codemp/game/g_utils.c:428
var gClPtrs: Slots<Client?> { world.storage.gClPtrs }

/// Source: oracle/codemp/game/g_utils.c:519
let MAXCHOICES = 32 as Int32

/// Source: oracle/codemp/game/g_utils.c:875
let MAX_G2_KILL_QUEUE = 256 as Int32

/// Source: oracle/codemp/game/g_utils.c:877
var gG2KillIndex: [Int32] {
    get { world.variables.gG2KillIndex }
    set { world.variables.gG2KillIndex = newValue }
}

/// Source: oracle/codemp/game/g_utils.c:878
var gG2KillNum: Int32 {
    get { world.variables.gG2KillNum }
    set { world.variables.gG2KillNum = newValue }
}

/// Source: oracle/codemp/game/g_utils.c:1612
let USE_DISTANCE = 64.0 as Float

/// Source: oracle/codemp/game/g_utils.c:1616
/// Raven's data table, a hand property of `GameWorld`.
private var playerMins: JKAShared.vec3_t {
    get { world.g_utils_playerMins }
    set { world.g_utils_playerMins = newValue }
}

/// Source: oracle/codemp/game/g_utils.c:1617
/// Raven's data table, a hand property of `GameWorld`.
private var playerMaxs: JKAShared.vec3_t {
    get { world.g_utils_playerMaxs }
    set { world.g_utils_playerMaxs = newValue }
}

/// Source: oracle/codemp/game/g_utils.c:20
func AddRemap(_ oldShader: String, _ newShader: String, _ timeOffset: Float) {
    var i: Int32

    i = 0
    while i < remapCount {
        if Q_stricmp(oldShader, remappedShaders[i].oldShader) == 0 {
            // found it, just update this one
            strcpy(&remappedShaders[i].newShaderBuffer, newShader)
            remappedShaders[i].timeOffset = timeOffset
            return
        }
        i += 1
    }
    if remapCount < MAX_SHADER_REMAPS {
        strcpy(&remappedShaders[remapCount].newShaderBuffer, newShader)
        strcpy(&remappedShaders[remapCount].oldShaderBuffer, oldShader)
        remappedShaders[remapCount].timeOffset = timeOffset
        remapCount += 1
    }
}

/// Source: oracle/codemp/game/g_utils.c:39
func BuildShaderStateConfig() -> String {
    // Port-note: A static local `buff` the function returns, storage that outlives the call.
    // Raven wrote: static char buff[MAX_STRING_CHARS*4];
    portMissing("BuildShaderStateConfig", source: "oracle/codemp/game/g_utils.c:39")
    var out = CharBuf(133)
    var i: Int32

    // Port-note: Raven's `memset(buff, 0, MAX_STRING_CHARS)` runs over bytes that are not one record with a view.
    // Raven wrote: memset(buff, 0, MAX_STRING_CHARS)
    portMissing("BuildShaderStateConfig", source: "oracle/codemp/game/g_utils.c:39")
    i = 0
    while i < remapCount {
        Com_sprintf(&out, (MAX_QPATH * 2) + 5, "%s=%s:%5.2f@", remappedShaders[i].oldShader, remappedShaders[i].newShader, remappedShaders[i].timeOffset)
        // Port-note: A read of `buff`, a local the draft left as a hole.
        // Raven wrote: Q_strcat( buff, sizeof( buff ), out)
        portMissing("BuildShaderStateConfig", source: "oracle/codemp/game/g_utils.c:39")
        i += 1
    }
    // Port-note: A read of `buff`, a local the draft left as a hole.
    // Raven wrote: return buff
    portMissing("BuildShaderStateConfig", source: "oracle/codemp/game/g_utils.c:39")
}

/**
```
================
G_FindConfigstringIndex

================
```
*/
/// Source: oracle/codemp/game/g_utils.c:66
private func G_FindConfigstringIndex(_ name: String, _ start: Int32, _ max: Int32, _ create: Bool) -> Int32 {
    var i: Int32
    var s = CharBuf(1024)

    if name.isEmpty {
        return 0
    }

    i = 1
    while i < max {
        strcpy(&s, trap_GetConfigstring(start + i, Int32((s).count)))
        if s[0] == 0 {
            break
        }
        if strcmp(s, name) == 0 {
            return i
        }
        i += 1
    }

    if !create {
        return 0
    }

    if i == max {
        G_Error("G_FindConfigstringIndex: overflow")
    }

    trap_SetConfigstring(start + i, name)

    return i
}

/// Source: oracle/codemp/game/g_utils.c:101
func G_BoneIndex(_ name: String) -> Int32 {
    return G_FindConfigstringIndex(name, CS_G2BONES, MAX_G2BONES, true)
}

/// Source: oracle/codemp/game/g_utils.c:108
func G_ModelIndex(_ name: String) -> Int32 {
    //debug to see if we are shoving data into configstrings for models that don't exist, and if
    //so, where we are doing it from -rww


    return G_FindConfigstringIndex(name, CS_MODELS, MAX_MODELS, true)
}

/// Source: oracle/codemp/game/g_utils.c:132
func G_IconIndex(_ name: String) -> Int32 {
    return G_FindConfigstringIndex(name, CS_ICONS, MAX_ICONS, true)
}

/// Source: oracle/codemp/game/g_utils.c:138
func G_SoundIndex(_ name: String) -> Int32 {
    return G_FindConfigstringIndex(name, CS_SOUNDS, MAX_SOUNDS, true)
}

/// Source: oracle/codemp/game/g_utils.c:143
func G_SoundSetIndex(_ name: String) -> Int32 {
    return G_FindConfigstringIndex(name, CS_AMBIENT_SET, MAX_AMBIENT_SETS, true)
}

/// Source: oracle/codemp/game/g_utils.c:148
func G_EffectIndex(_ name: String) -> Int32 {
    return G_FindConfigstringIndex(name, CS_EFFECTS, MAX_FX, true)
}

/// Source: oracle/codemp/game/g_utils.c:153
func G_BSPIndex(_ name: String) -> Int32 {
    return G_FindConfigstringIndex(name, CS_BSP_MODELS, MAX_SUB_BSP, true)
}

//see if we can or should allow this guy to use a custom skeleton -rww
/// Source: oracle/codemp/game/g_utils.c:162
func G_PlayerHasCustomSkeleton(_ ent: Entity) -> Bool {
    /*
    siegeClass_t *scl;

    if (g_gametype.integer != GT_SIEGE)
    { //only in siege
    return qfalse;
    }

    if (ent->s.number >= MAX_CLIENTS ||
    !ent->client ||
    ent->client->siegeClass == -1)
    { //invalid class
    return qfalse;
    }

    scl = &bgSiegeClasses[ent->client->siegeClass];
    if (!(scl->classflags & (1<<CFL_CUSTOMSKEL)))
    { //class is not flagged for this
    return qfalse;
    }

    return qtrue;
    */
    return false
}

/**
```
================
G_TeamCommand

Broadcasts a command to only a specific team
================
```
*/
/// Source: oracle/codemp/game/g_utils.c:197
func G_TeamCommand(_ team: JKAMP.team_t, _ cmd: String) {
    var i: Int32

    i = 0
    while i < level.maxclients {
        if level.clientsSlots[i].pers.connected == CON_CONNECTED {
            if level.clientsSlots[i].sess.sessionTeam == team {
                trap_SendServerCommand(i, va("%s", cmd))
            }
        }
        i += 1
    }
}

/**
```
=============
G_Find

Searches all active entities for the next one that holds
the matching string at fieldofs (use the FOFS() macro) in the structure.

Searches beginning at the entity after from, or the beginning if NULL
NULL will be returned if the end of the list is reached.

=============
```
*/
/// Source: oracle/codemp/game/g_utils.c:222
func G_Find(_ from: Entity?, _ fieldofs: Int32, _ match: String) -> Entity? {
    var s: UnsafeMutableRawPointer
    // Raven walks his own `from` parameter over `g_entities`, so the body walks the index of its slot, as for a walked local.
    var fromIndex: Int32 = 0

    if from == nil {
        fromIndex = 0
    } else {
        fromIndex = from!.s.number + 1
    }

    while fromIndex < level.num_entities {
        if !g_entities[fromIndex].inuse {
            fromIndex += 1
            continue
        }
        // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'UnsafeMutableRawPointer?' must be unwrapped to a value of type 'UnsafeMutableRawPointer'".
        // Raven wrote: s = *(char **) ((byte *)from + fieldofs)
        portMissing("G_Find", source: "oracle/codemp/game/g_utils.c:222")
        if s == nil {
            fromIndex += 1
            continue
        }
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutableRawPointer' to expected argument type 'String'".
        // Raven wrote: if (!Q_stricmp (s, match)) return from
        portMissing("G_Find", source: "oracle/codemp/game/g_utils.c:222")
        fromIndex += 1
    }

    return nil
}

/**
```
============
G_RadiusList - given an origin and a radius, return all entities that are in use that are within the list
============
```
*/
/// Source: oracle/codemp/game/g_utils.c:252
func G_RadiusList(_ origin: JKAShared.vec3_t, _ radius: Float, _ ignore: Entity, _ takeDamage: Bool, _ ent_list: inout [Entity?]) -> Int32 {
    var dist: Float
    var ent: Entity?
    var entityList: [Int32] = [Int32](repeating: 0, count: 1024)
    let numListedEntities: Int32
    var mins = vec3_t()
    var maxs = vec3_t()
    var v = vec3_t()
    var i: Int32
    var e: Int32
    var ent_count: Int32 = 0
    // Raven assigns his own `radius` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var radius = radius

    if radius < 1 {
        radius = 1
    }

    i = 0
    while i < 3 {
        mins[i] = origin[i] - radius
        maxs[i] = origin[i] + radius
        i += 1
    }

    numListedEntities = trap_EntitiesInBox(mins, maxs, &entityList, MAX_GENTITIES)

    e = 0
    while e < numListedEntities {
        ent = g_entities[entityList[e]]

        if (ent == ignore) || !(ent!.inuse) || ent!.takedamage != takeDamage {
            e += 1
            continue
        }

        // find the distance from the edge of the bounding box
        i = 0
        while i < 3 {
            if origin[i] < ent!.r.absmin[i] {
                v[i] = ent!.r.absmin[i] - origin[i]
            } else if origin[i] > ent!.r.absmax[i] {
                v[i] = origin[i] - ent!.r.absmax[i]
            } else {
                v[i] = 0
            }
            i += 1
        }

        dist = VectorLength(v)
        if dist >= radius {
            e += 1
            continue
        }

        // ok, we are within the radius, add us to the incoming list
        ent_list[ent_count] = ent
        ent_count += 1
        e += 1
    }
    // we are done, return how many we found
    return (ent_count)
}

//----------------------------------------------------------
/// Source: oracle/codemp/game/g_utils.c:315
func G_Throw(_ targ: Entity, _ newDir: JKAShared.vec3_t, _ push: Float) {
    var kvel = vec3_t()
    let mass: Float

    if targ.physicsBounce > 0 {
        mass = targ.physicsBounce
    } else {
        mass = 200
    }

    if g_gravity.value > 0 {
        kvel = newDir * (Float(Double(g_knockback.value * Float(push) / mass) * 0.8))
        kvel[2] = Float(Double(newDir[2] * g_knockback.value * Float(push) / mass) * 1.5)
    } else {
        kvel = newDir * (g_knockback.value * Float(push) / mass)
    }

    if targ.client != nil {
        targ.client!.ps.velocity = targ.client!.ps.velocity + kvel
    } else if targ.s.pos.trType != TR_STATIONARY && targ.s.pos.trType != TR_LINEAR_STOP && targ.s.pos.trType != TR_NONLINEAR_STOP {
        targ.s.pos.trDelta = targ.s.pos.trDelta + kvel
        targ.s.pos.trBase = targ.r.currentOrigin
        targ.s.pos.trTime = level.time
    }

    // set the timer so that the other client can't cancel
    // out the movement immediately
    if targ.client != nil && targ.client!.ps.pm_time == 0 {
        var t: Int32

        t = Int32(push * 2)

        if t < 50 {
            t = 50
        }
        if t > 200 {
            t = 200
        }
        targ.client!.ps.pm_time = t
        targ.client!.ps.pm_flags |= PMF_TIME_KNOCKBACK
    }
}

//methods of creating/freeing "fake" dynamically allocated client entity structures.
//You ABSOLUTELY MUST free this client after creating it before game shutdown. If
//it is left around you will have a memory leak, because true dynamic memory is
//allocated by the exe.
/// Source: oracle/codemp/game/g_utils.c:376
func G_FreeFakeClient(_ cl: inout Client?) {
    //or not, the dynamic stuff is busted somehow at the moment. Yet it still works in the test.
    //I think something is messed up in being able to cast the memory to stuff to modify it,
    //while modifying it directly seems to work fine.
    //trap_TrueFree((void **)cl);
}

/// Source: oracle/codemp/game/g_utils.c:388
func G_AllocateVehicleObject(_ pVeh: inout JKAMP.Vehicle?) {
    var i: Int32 = 0

    if !g_vehiclePoolInit {
        g_vehiclePoolInit = true
        // Port-note: Raven's `memset(g_vehiclePoolOccupied, 0, sizeof(g_vehiclePoolOccupied))` runs over bytes that are not one record with a view.
        // Raven wrote: memset(g_vehiclePoolOccupied, 0, sizeof(g_vehiclePoolOccupied))
        portMissing("G_AllocateVehicleObject", source: "oracle/codemp/game/g_utils.c:388")
    }

    while i < MAX_VEHICLES_AT_A_TIME {
        //iterate through and try to find a free one
        if !g_vehiclePoolOccupied[i] {
            g_vehiclePoolOccupied[i] = true
            g_vehiclePool[i].clear()
            pVeh = g_vehiclePool[i]
            return
        }
        i += 1
    }
    Com_Error(ERR_DROP, "Ran out of vehicle pool slots.")
}

//free the pointer, sort of a lame method
/// Source: oracle/codemp/game/g_utils.c:413
func G_FreeVehicleObject(_ pVeh: JKAMP.Vehicle) {
    var i: Int32 = 0
    while i < MAX_VEHICLES_AT_A_TIME {
        if g_vehiclePoolOccupied[i] && g_vehiclePool[i] == pVeh {
            //guess this is it
            g_vehiclePoolOccupied[i] = false
            break
        }
        i += 1
    }
}

/// Source: oracle/codemp/game/g_utils.c:430
func G_CreateFakeClient(_ entNum: Int32, _ cl: inout Client?) {
    //trap_TrueMalloc((void **)cl, sizeof(gclient_t));
    if gClPtrs[entNum] == nil {
        gClPtrs[entNum] = Client(BG_Alloc(Int32(Client.byteCount)))
    }
    // Port-note: Raven stores `*cl = gClPtrs[entNum]`, and the view holds the source as an optional where the target takes a value. A never-null ruling is due.
    // Raven wrote: *cl = gClPtrs[entNum]
    portMissing("G_CreateFakeClient", source: "oracle/codemp/game/g_utils.c:430")
}

//call this on game shutdown to run through and get rid of all the lingering client pointers.
/// Source: oracle/codemp/game/g_utils.c:450
func G_CleanAllFakeClients() {
    var i: Int32 = MAX_CLIENTS
    var ent: Entity?

    while i < MAX_GENTITIES {
        ent = g_entities[i]

        if ent!.inuse && ent!.s.eType == ET_NPC && ent!.client != nil {
            G_FreeFakeClient(&ent!.client)
        }
        i += 1
    }
}

/// Source: oracle/codemp/game/g_utils.c:479
func G_SetAnim(_ ent: Entity, _ ucmd: JKAMP.Usercmd?, _ setAnimParts: Int32, _ anim: Int32, _ setAnimFlags: Int32, _ blendTime: Int32) {
    //don't need to bother with ghoul2 stuff, it's not even used in PM_SetAnim.
    BG_SetAnim(ent.client!.ps, bgAllAnims[ent.localAnimIndex].animsSlots, setAnimParts, anim, setAnimFlags, blendTime)
}

/// Source: oracle/codemp/game/g_utils.c:521
func G_PickTarget(_ targetname: String) -> Entity? {
    var ent: Entity? = nil
    var num_choices: Int32 = 0
    // Port-note: A local `gentity_t *[32] choice` the table has no type for.
    // Raven wrote: gentity_t *choice[MAXCHOICES];
    portMissing("G_PickTarget", source: "oracle/codemp/game/g_utils.c:521")


    while 1 != 0 {
        // Port-note: No operator beside the operand, the text there is ``.
        // Raven wrote: ent = G_Find (ent, FOFS(targetname), targetname)
        portMissing("G_PickTarget", source: "oracle/codemp/game/g_utils.c:521")
        if ent == nil {
            break
        }
        // Port-note: A ++ inside an expression.
        // Raven wrote: choice[num_choices++] = ent
        portMissing("G_PickTarget", source: "oracle/codemp/game/g_utils.c:521")
        if num_choices == MAXCHOICES {
            break
        }
    }

    if num_choices == 0 {
        G_Printf("G_PickTarget: target %s not found\n", targetname)
        return nil
    }

    // Port-note: A read of `choice`, a local the draft left as a hole.
    // Raven wrote: return choice[rand() % num_choices]
    portMissing("G_PickTarget", source: "oracle/codemp/game/g_utils.c:521")
}

/// Source: oracle/codemp/game/g_utils.c:552
func GlobalUse(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    if (`self`.flags & FL_INACTIVE) != 0 {
        return
    }

    if `self`.use == nil {
        return
    }
    `self`.runUse(other, activator)
}

/// Source: oracle/codemp/game/g_utils.c:566
func G_UseTargets2(_ ent: Entity, _ activator: Entity, _ string: String) {
    var t: Entity?


    if ent.targetShaderName != nil && ent.targetShaderNewName != nil {
        let f: Float = Float(Double(level.time) * 0.001)
        AddRemap(ent.targetShaderName!, ent.targetShaderNewName!, f)
        trap_SetConfigstring(CS_SHADERSTATE, BuildShaderStateConfig())
    }

    if string.isEmpty {
        return
    }

    t = nil
    // Port-note: An assignment inside an expression.
    // Raven wrote: while ( (t = G_Find (t, FOFS(targetname), string)) != NULL ) { if ( t == ent ) { G_Printf ("WARNING: Entity used itself.\n"); } else { if ( t->use ) { GlobalUse(t, ent, activator); } } if ( !ent->inuse ) { G_Printf("entity was removed while using targets\n"); return; } }
    portMissing("G_UseTargets2", source: "oracle/codemp/game/g_utils.c:566")
}

/**
```
==============================
G_UseTargets

"activator" should be set to the entity that initiated the firing.

Search for (string)targetname in all entities that
match (string)self.target and call their .use function

==============================
```
*/
/// Source: oracle/codemp/game/g_utils.c:609
func G_UseTargets(_ ent: Entity, _ activator: Entity?) {
    // Port-note: Raven passes the optional `activator` to `G_UseTargets2`, whose `activator` parameter takes a value. A never-null ruling is due.
    // Raven wrote: G_UseTargets2(ent, activator, ent->target)
    portMissing("G_UseTargets", source: "oracle/codemp/game/g_utils.c:609")
}

/**
```
=============
TempVector

This is just a convenience function
for making temporary vectors for function calls
=============
```
*/
/// Source: oracle/codemp/game/g_utils.c:627
func tv(_ x: Float, _ y: Float, _ z: Float) -> JKAShared.vec3_t {
    // Port-note: A static local `index` a statement reads before it writes, storage that outlives the call.
    // Raven wrote: static int index;
    portMissing("tv", source: "oracle/codemp/game/g_utils.c:627")
    var vecs = [vec3_t](repeating: vec3_t(), count: 8)

    // use an array so that multiple tempvectors won't collide
    // for a while
    // Port-note: A store into `index`, a local the draft left as a hole.
    // Raven wrote: index = (index + 1)&7
    portMissing("tv", source: "oracle/codemp/game/g_utils.c:627")

    // Port-note: A read of `index`, a local the draft left as a hole.
    // Raven wrote: v[0] = x
    portMissing("tv", source: "oracle/codemp/game/g_utils.c:627")
    // Port-note: A read of `index`, a local the draft left as a hole.
    // Raven wrote: v[1] = y
    portMissing("tv", source: "oracle/codemp/game/g_utils.c:627")
    // Port-note: A read of `index`, a local the draft left as a hole.
    // Raven wrote: v[2] = z
    portMissing("tv", source: "oracle/codemp/game/g_utils.c:627")

    // Port-note: A read of `index`, a local the draft left as a hole.
    // Raven wrote: return v
    portMissing("tv", source: "oracle/codemp/game/g_utils.c:627")
}

/**
```
=============
VectorToString

This is just a convenience function
for printing vectors
=============
```
*/
/// Source: oracle/codemp/game/g_utils.c:653
func vtos(_ v: JKAShared.vec3_t) -> String {
    // Port-note: A static local `index` a statement reads before it writes, storage that outlives the call.
    // Raven wrote: static int index;
    portMissing("vtos", source: "oracle/codemp/game/g_utils.c:653")
    // Port-note: A local `char[8][32] str` the table has no type for.
    // Raven wrote: static char str[8][32];
    portMissing("vtos", source: "oracle/codemp/game/g_utils.c:653")
    // Port-note: A pointer local `char * s` with no view.
    // Raven wrote: char *s;
    portMissing("vtos", source: "oracle/codemp/game/g_utils.c:653")

    // use an array so that multiple vtos won't collide
    // Port-note: A store into `s`, a local the draft left as a hole.
    // Raven wrote: s = str[index]
    portMissing("vtos", source: "oracle/codemp/game/g_utils.c:653")
    // Port-note: A store into `index`, a local the draft left as a hole.
    // Raven wrote: index = (index + 1)&7
    portMissing("vtos", source: "oracle/codemp/game/g_utils.c:653")

    // Port-note: A read of `s`, a local the draft left as a hole.
    // Raven wrote: Com_sprintf (s, 32, "(%i %i %i)", (int)v[0], (int)v[1], (int)v[2])
    portMissing("vtos", source: "oracle/codemp/game/g_utils.c:653")

    // Port-note: A read of `s`, a local the draft left as a hole.
    // Raven wrote: return s
    portMissing("vtos", source: "oracle/codemp/game/g_utils.c:653")
}

/**
```
===============
G_SetMovedir

The editor only specifies a single value for angles (yaw),
but we have special constants to generate an up or down direction.
Angles will be cleared, because it is being used to represent a direction
instead of an orientation.
===============
```
*/
/// Source: oracle/codemp/game/g_utils.c:678
func G_SetMovedir(_ angles: inout JKAShared.vec3_t, _ movedir: inout JKAShared.vec3_t) {
    var VEC_UP = vec3_t(0, -1, 0)
    var MOVEDIR_UP = vec3_t(0, 0, 1)
    var VEC_DOWN = vec3_t(0, -2, 0)
    var MOVEDIR_DOWN = vec3_t(0, 0, -1)

    if VectorCompare(angles, VEC_UP) != 0 {
        movedir = MOVEDIR_UP
    } else if VectorCompare(angles, VEC_DOWN) != 0 {
        movedir = MOVEDIR_DOWN
    } else {
        // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("G_SetMovedir", source: "oracle/codemp/game/g_utils.c:678")
        var scratchRight = vec3_t()
        // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("G_SetMovedir", source: "oracle/codemp/game/g_utils.c:678")
        var scratchUp = vec3_t()
        AngleVectors(angles, &movedir, &scratchRight, &scratchUp)
    }
    angles = vec3_t()
}

/// Source: oracle/codemp/game/g_utils.c:694
func G_InitGentity(_ e: Entity) {
    e.inuse = true
    e.classname = "noclass"
    e.s.number = g_entities.slot(of: e)
    e.r.ownerNum = ENTITYNUM_NONE
    e.s.modelGhoul2 = 0 //assume not

    trap_ICARUS_FreeEnt(e) //ICARUS information must be added after this point
}

//give us some decent info on all the active ents -rww
/// Source: oracle/codemp/game/g_utils.c:705
private func G_SpewEntList() {
    var i: Int32 = 0
    var numNPC: Int32 = 0
    var numProjectile: Int32 = 0
    var numTempEnt: Int32 = 0
    var numTempEntST: Int32 = 0
    var className = CharBuf(1024)
    var ent: Entity?
    var str: String

    var fh: fileHandle_t = 0
    trap_FS_FOpenFile("entspew.txt", &fh, FS_WRITE)

    while i < ENTITYNUM_MAX_NORMAL {
        ent = g_entities[i]
        if ent!.inuse {
            if ent!.s.eType == ET_NPC {
                numNPC += 1
            } else if ent!.s.eType == ET_MISSILE {
                numProjectile += 1
            } else if ent!.freeAfterEvent {
                numTempEnt += 1
                if (ent!.s.eFlags & EF_SOUNDTRACKER) != 0 {
                    numTempEntST += 1
                }

                str = va("TEMPENT %4i: EV %i\n", ent!.s.number, ent!.s.eType - ET_EVENTS)
                Com_Printf(str)
                if fh != 0 {
                    trap_FS_Write(str, strlen(str), fh)
                }
            }

            if ent!.classname != nil && !ent!.classname!.isEmpty {
                strcpy(&className, ent!.classname!)
            } else {
                strcpy(&className, "Unknown")
            }
            str = va("ENT %4i: Classname %s\n", ent!.s.number, className)
            Com_Printf(str)
            if fh != 0 {
                trap_FS_Write(str, strlen(str), fh)
            }
        }

        i += 1
    }

    str = va("TempEnt count: %i\nTempEnt ST: %i\nNPC count: %i\nProjectile count: %i\n", numTempEnt, numTempEntST, numNPC, numProjectile)
    Com_Printf(str)
    if fh != 0 {
        trap_FS_Write(str, strlen(str), fh)
        trap_FS_FCloseFile(fh)
    }
}

/**
```
=================
G_Spawn

Either finds a free entity, or allocates a new one.

  The slots from 0 to MAX_CLIENTS-1 are always reserved for clients, and will
never be used by anything else.

Try to avoid reusing an entity that was recently freed, because it
can cause the client to think the entity morphed into something else
instead of being removed and recreated, which can cause interpolated
angles and bad trails.
=================
```
*/
/// Source: oracle/codemp/game/g_utils.c:804
func G_Spawn() -> Entity? {
    var i: Int32
    var force: Int32
    var e: Entity?

    e = nil // shut up warning
    i = 0 // shut up warning
    force = 0
    while force < 2 {
        // if we go through all entities and can't find one to free,
        // override the normal minimum times before use
        e = g_entities[MAX_CLIENTS]
        i = MAX_CLIENTS
        while i < level.num_entities {
            if e!.inuse {
                i += 1
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Entity?' to expected argument type 'Int'".
                // Raven wrote: e++
                portMissing("G_Spawn", source: "oracle/codemp/game/g_utils.c:804")
                continue
            }

            // the first couple seconds of server time can involve a lot of
            // freeing and allocating, so relax the replacement policy
            if force == 0 && e!.freetime > level.startTime + 2000 && level.time - e!.freetime < 1000 {
                i += 1
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Entity?' to expected argument type 'Int'".
                // Raven wrote: e++
                portMissing("G_Spawn", source: "oracle/codemp/game/g_utils.c:804")
                continue
            }

            // reuse this slot
            G_InitGentity(e!)
            return e
            i += 1
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Entity?' to expected argument type 'Int'".
            // Raven wrote: e++
            portMissing("G_Spawn", source: "oracle/codemp/game/g_utils.c:804")
        }
        if i != MAX_GENTITIES {
            break
        }
        force += 1
    }
    if i == ENTITYNUM_MAX_NORMAL {
        /*
        for (i = 0; i < MAX_GENTITIES; i++) {
        G_Printf("%4i: %s\n", i, g_entities[i].classname);
        }
        */
        G_SpewEntList()
        G_Error("G_Spawn: no free entities")
    }

    // open up a new slot
    level.num_entities += 1

    // let the server system know that there are more entities
    trap_LocateGameData(level.gentities!, level.num_entities, Int32(Entity.byteCount), level.clientsSlots[0].ps, Int32(Client.byteCount))

    G_InitGentity(e!)
    return e
}

/**
```
=================
G_EntitiesFree
=================
```
*/
/// Source: oracle/codemp/game/g_utils.c:860
func G_EntitiesFree() -> Bool {
    var i: Int32
    var eIndex: Int32 = 0

    eIndex = MAX_CLIENTS
    i = MAX_CLIENTS
    while i < level.num_entities {
        if g_entities[eIndex].inuse {
            i += 1
            eIndex += 1
            continue
        }
        // slot available
        return true
        i += 1
        eIndex += 1
    }
    return false
}

/// Source: oracle/codemp/game/g_utils.c:880
func G_SendG2KillQueue() {
    var g2KillString = CharBuf(1024)
    var i: Int32 = 0

    if gG2KillNum == 0 {
        return
    }

    Com_sprintf(&g2KillString, 1024, "kg2")

    while i < gG2KillNum && i < 64 {
        //send 64 at once, max...
        Q_strcat(&g2KillString, 1024, va(" %i", gG2KillIndex[i]))
        i += 1
    }

    trap_SendServerCommand(-1, String(g2KillString))

    //Clear the count because we just sent off the whole queue
    gG2KillNum -= i
    if gG2KillNum < 0 {
        //hmm, should be impossible, but I'm paranoid as we're far past beta.
        gG2KillNum = 0
    }
}

/// Source: oracle/codemp/game/g_utils.c:909
func G_KillG2Queue(_ entNum: Int32) {
    if gG2KillNum >= MAX_G2_KILL_QUEUE {
        //This would be considered a Bad Thing.
        //Since we're out of queue slots, just send it now as a seperate command (eats more bandwidth, but we have no choice)
        trap_SendServerCommand(-1, va("kg2 %i", entNum))
        return
    }

    gG2KillIndex[gG2KillNum] = entNum
    gG2KillNum += 1
}

/**
```
=================
G_FreeEntity

Marks the entity as free
=================
```
*/
/// Source: oracle/codemp/game/g_utils.c:932
func G_FreeEntity(_ ed: Entity) {
    //gentity_t *te;

    if ed.isSaberEntity {
        return
    }

    trap_UnlinkEntity(ed) // unlink from world

    trap_ICARUS_FreeEnt(ed) //ICARUS information must be added after this point

    if ed.neverFree {
        return
    }

    //rww - this may seem a bit hackish, but unfortunately we have no access
    //to anything ghoul2-related on the server and thus must send a message
    //to let the client know he needs to clean up all the g2 stuff for this
    //now-removed entity
    if ed.s.modelGhoul2 != 0 {
        //force all clients to accept an event to destroy this instance, right now
        /*
        te = G_TempEntity( vec3_origin, EV_DESTROY_GHOUL2_INSTANCE );
        te->r.svFlags |= SVF_BROADCAST;
        te->s.eventParm = ed->s.number;
        */
        //Or not. Events can be dropped, so that would be a bad thing.
        G_KillG2Queue(ed.s.number)
    }

    //And, free the server instance too, if there is one.
    if ed.ghoul2 != nil {
        trap_G2API_CleanGhoul2Models(&(ed.ghoul2))
    }

    if ed.s.eType == ET_NPC && ed.m_pVehicle != nil {
        //tell the "vehicle pool" that this one is now free
        G_FreeVehicleObject(ed.m_pVehicle!)
    }

    if ed.s.eType == ET_NPC && ed.client != nil {
        //this "client" structure is one of our dynamically allocated ones, so free the memory
        var saberEntNum: Int32 = -1
        var i: Int32 = 0
        if ed.client!.ps.saberEntityNum != 0 {
            saberEntNum = ed.client!.ps.saberEntityNum
        } else if ed.client!.saberStoredIndex != 0 {
            saberEntNum = ed.client!.saberStoredIndex
        }

        if saberEntNum > 0 && g_entities[saberEntNum].inuse {
            g_entities[saberEntNum].neverFree = false
            G_FreeEntity(g_entities[saberEntNum])
        }

        while i < MAX_SABERS {
            if ed.client!.weaponGhoul2[i] != nil && trap_G2_HaveWeGhoul2Models(ed.client!.weaponGhoul2[i]) {
                trap_G2API_CleanGhoul2Models(&ed.client!.weaponGhoul2[i])
            }
            i += 1
        }

        G_FreeFakeClient(&ed.client)
    }

    if (ed.s.eFlags & EF_SOUNDTRACKER) != 0 {
        var i: Int32 = 0
        var ent: Entity?

        while i < MAX_CLIENTS {
            ent = g_entities[i]

            if ent != nil && ent!.inuse && ent!.client != nil {
                var ch: Int32 = TRACK_CHANNEL_NONE - 50

                while ch < NUM_TRACK_CHANNELS - 50 {
                    if ent!.client!.ps.fd.killSoundEntIndex[ch] == ed.s.number {
                        ent!.client!.ps.fd.killSoundEntIndex[ch] = 0
                    }

                    ch += 1
                }
            }

            i += 1
        }

        //make sure clientside loop sounds are killed on the tracker and client
        trap_SendServerCommand(-1, va("kls %i %i", ed.s.trickedentindex, ed.s.number))
    }

    ed.clear()
    ed.classname = "freed"
    ed.freetime = level.time
    ed.inuse = false
}

/**
```
=================
G_TempEntity

Spawns an event entity that will be auto-removed
The origin will be snapped to save net bandwidth, so care
must be taken if the origin is right on a surface (snap towards start vector first)
=================
```
*/
/// Source: oracle/codemp/game/g_utils.c:1054
func G_TempEntity(_ origin: JKAShared.vec3_t, _ event: Int32) -> Entity? {
    var e: Entity?
    var snapped = vec3_t()

    e = G_Spawn()
    e!.s.eType = ET_EVENTS + event

    e!.classname = "tempEntity"
    e!.eventTime = level.time
    e!.freeAfterEvent = true

    snapped = origin
    SnapVector(&snapped) // save network bandwidth
    G_SetOrigin(e!, &snapped)
    //WTF?  Why aren't we setting the s.origin? (like below)
    //cg_events.c code checks origin all over the place!!!
    //Trying to save bandwidth...?
    //VectorCopy( snapped, e->s.origin );

    // find cluster for PVS
    trap_LinkEntity(e!)

    return e
}

/**
```
=================
G_SoundTempEntity

Special event entity that keeps sound trackers in mind
=================
```
*/
/// Source: oracle/codemp/game/g_utils.c:1087
func G_SoundTempEntity(_ origin: JKAShared.vec3_t, _ event: Int32, _ channel: Int32) -> Entity? {
    var e: Entity?
    var snapped = vec3_t()

    e = G_Spawn()

    e!.s.eType = ET_EVENTS + event
    e!.inuse = true

    e!.classname = "tempEntity"
    e!.eventTime = level.time
    e!.freeAfterEvent = true

    snapped = origin
    SnapVector(&snapped) // save network bandwidth
    G_SetOrigin(e!, &snapped)

    // find cluster for PVS
    trap_LinkEntity(e!)

    return e
}

//scale health down below 1024 to fit in health bits
/// Source: oracle/codemp/game/g_utils.c:1112
func G_ScaleNetHealth(_ `self`: Entity) {
    let maxHealth: Int32 = `self`.maxHealth

    if maxHealth < 1000 {
        //it's good then
        `self`.s.maxhealth = maxHealth
        `self`.s.health = `self`.health

        if `self`.s.health < 0 {
            //don't let it wrap around
            `self`.s.health = 0
        }
        return
    }

    //otherwise, scale it down
    `self`.s.maxhealth = (maxHealth / 100)
    `self`.s.health = (`self`.health / 100)

    if `self`.s.health < 0 {
        //don't let it wrap around
        `self`.s.health = 0
    }

    if `self`.health > 0 && `self`.s.health <= 0 {
        //don't let it scale to 0 if the thing is still not "dead"
        `self`.s.health = 1
    }
}

/**
```
=================
G_KillBox

Kills all entities that would touch the proposed new positioning
of ent.  Ent should be unlinked before calling this!
=================
```
*/
/// Source: oracle/codemp/game/g_utils.c:1162
func G_KillBox(_ ent: Entity) {
    var i: Int32
    let num: Int32
    var touch: [Int32] = [Int32](repeating: 0, count: 1024)
    var hit: Entity?
    var mins = vec3_t()
    var maxs = vec3_t()

    mins = ent.client!.ps.origin + ent.r.mins
    maxs = ent.client!.ps.origin + ent.r.maxs
    num = trap_EntitiesInBox(mins, maxs, &touch, MAX_GENTITIES)

    i = 0
    while i < num {
        hit = g_entities[touch[i]]
        if hit!.client == nil {
            i += 1
            continue
        }

        if hit!.s.number == ent.s.number {
            //don't telefrag yourself!
            i += 1
            continue
        }

        if ent.r.ownerNum == hit!.s.number {
            //don't telefrag your vehicle!
            i += 1
            continue
        }

        // nail it
        // Port-note: Raven passes NULL for the `dir` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("G_KillBox", source: "oracle/codemp/game/g_utils.c:1162")
        var scratchDir = vec3_t()
        G_Damage(hit!, ent, ent, &scratchDir, nil, 100000, DAMAGE_NO_PROTECTION, MOD_TELEFRAG)
        i += 1
    }
}

/**
```
===============
G_AddPredictableEvent

Use for non-pmove events that would also be predicted on the
client side: jumppads and item pickups
Adds an event+parm and twiddles the event counter
===============
```
*/
/// Source: oracle/codemp/game/g_utils.c:1206
func G_AddPredictableEvent(_ ent: Entity, _ event: Int32, _ eventParm: Int32) {
    if ent.client == nil {
        return
    }
    BG_AddPredictableEventToPlayerstate(event, eventParm, ent.client!.ps)
}

/**
```
===============
G_AddEvent

Adds an event+parm and twiddles the event counter
===============
```
*/
/// Source: oracle/codemp/game/g_utils.c:1221
func G_AddEvent(_ ent: Entity, _ event: Int32, _ eventParm: Int32) {
    var bits: Int32

    if event == 0 {
        G_Printf("G_AddEvent: zero event added for entity %i\n", ent.s.number)
        return
    }

    // clients need to add the event in playerState_t instead of entityState_t
    if ent.client != nil {
        bits = ent.client!.ps.externalEvent & EV_EVENT_BITS
        bits = (bits + EV_EVENT_BIT1) & EV_EVENT_BITS
        ent.client!.ps.externalEvent = event | bits
        ent.client!.ps.externalEventParm = eventParm
        ent.client!.ps.externalEventTime = level.time
    } else {
        bits = ent.s.event & EV_EVENT_BITS
        bits = (bits + EV_EVENT_BIT1) & EV_EVENT_BITS
        ent.s.event = event | bits
        ent.s.eventParm = eventParm
    }
    ent.eventTime = level.time
}

/**
```
=============
G_PlayEffect
=============
```
*/
/// Source: oracle/codemp/game/g_utils.c:1250
func G_PlayEffect(_ fxID: Int32, _ org: JKAShared.vec3_t, _ ang: JKAShared.vec3_t) -> Entity? {
    var te: Entity?

    te = G_TempEntity(org, EV_PLAY_EFFECT)
    te!.s.angles = ang
    te!.s.origin = org
    te!.s.eventParm = fxID

    return te
}

/**
```
=============
G_PlayEffectID
=============
```
*/
/// Source: oracle/codemp/game/g_utils.c:1267
func G_PlayEffectID(_ fxID: Int32, _ org: JKAShared.vec3_t, _ ang: JKAShared.vec3_t) -> Entity? {
    //play an effect by the G_EffectIndex'd ID instead of a predefined effect ID
    var te: Entity?

    te = G_TempEntity(org, EV_PLAY_EFFECT_ID)
    te!.s.angles = ang
    te!.s.origin = org
    te!.s.eventParm = fxID

    if te!.s.angles[0] == 0 && te!.s.angles[1] == 0 && te!.s.angles[2] == 0 {
        //play off this dir by default then.
        te!.s.angles[1] = 1
    }

    return te
}

/**
```
=============
G_ScreenShake
=============
```
*/
/// Source: oracle/codemp/game/g_utils.c:1291
func G_ScreenShake(_ org: JKAShared.vec3_t, _ target: Entity?, _ intensity: Float, _ duration: Int32, _ global: Bool) -> Entity? {
    var te: Entity?

    te = G_TempEntity(org, EV_SCREENSHAKE)
    te!.s.origin = org
    te!.s.angles[0] = intensity
    te!.s.time = duration

    if target != nil {
        te!.s.modelindex = target!.s.number + 1
    } else {
        te!.s.modelindex = 0
    }

    if global {
        te!.r.svFlags |= SVF_BROADCAST
    }

    return te
}

/**
```
=============
G_MuteSound
=============
```
*/
/// Source: oracle/codemp/game/g_utils.c:1322
func G_MuteSound(_ entnum: Int32, _ channel: Int32) {
    var te: Entity?
    var e: Entity?

    te = G_TempEntity(vec3_origin, EV_MUTE_SOUND)
    te!.r.svFlags = SVF_BROADCAST
    te!.s.trickedentindex2 = entnum
    te!.s.trickedentindex = channel

    e = g_entities[entnum]

    if e != nil && (e!.s.eFlags & EF_SOUNDTRACKER) != 0 {
        G_FreeEntity(e!)
        e!.s.eFlags = 0
    }
}

/**
```
=============
G_Sound
=============
```
*/
/// Source: oracle/codemp/game/g_utils.c:1345
func G_Sound(_ ent: Entity, _ channel: Int32, _ soundIndex: Int32) {
    var te: Entity?


    te = G_SoundTempEntity(ent.r.currentOrigin, EV_GENERAL_SOUND, channel)
    te!.s.eventParm = soundIndex
    te!.s.saberEntityNum = channel

    if ent.client != nil && channel > TRACK_CHANNEL_NONE {
        //let the client remember the index of the player entity so he can kill the most recent sound on request
        if g_entities[ent.client!.ps.fd.killSoundEntIndex[channel - 50]].inuse && ent.client!.ps.fd.killSoundEntIndex[channel - 50] > MAX_CLIENTS {
            G_MuteSound(ent.client!.ps.fd.killSoundEntIndex[channel - 50], CHAN_VOICE)
            if ent.client!.ps.fd.killSoundEntIndex[channel - 50] > MAX_CLIENTS && g_entities[ent.client!.ps.fd.killSoundEntIndex[channel - 50]].inuse {
                G_FreeEntity(g_entities[ent.client!.ps.fd.killSoundEntIndex[channel - 50]])
            }
            ent.client!.ps.fd.killSoundEntIndex[channel - 50] = 0
        }

        ent.client!.ps.fd.killSoundEntIndex[channel - 50] = te!.s.number
        te!.s.trickedentindex = ent.s.number
        te!.s.eFlags = EF_SOUNDTRACKER
        //te->freeAfterEvent = qfalse;
    }
}

/**
```
=============
G_SoundAtLoc
=============
```
*/
/// Source: oracle/codemp/game/g_utils.c:1379
func G_SoundAtLoc(_ loc: JKAShared.vec3_t, _ channel: Int32, _ soundIndex: Int32) {
    var te: Entity?

    te = G_TempEntity(loc, EV_GENERAL_SOUND)
    te!.s.eventParm = soundIndex
    te!.s.saberEntityNum = channel
}

/**
```
=============
G_EntitySound
=============
```
*/
/// Source: oracle/codemp/game/g_utils.c:1392
func G_EntitySound(_ ent: Entity, _ channel: Int32, _ soundIndex: Int32) {
    var te: Entity?

    te = G_TempEntity(ent.r.currentOrigin, EV_ENTITY_SOUND)
    te!.s.eventParm = soundIndex
    te!.s.clientNum = ent.s.number
    te!.s.trickedentindex = channel
}

//To make porting from SP easier.
/// Source: oracle/codemp/game/g_utils.c:1402
func G_SoundOnEnt(_ ent: Entity, _ channel: Int32, _ soundPath: String) {
    var te: Entity?

    te = G_TempEntity(ent.r.currentOrigin, EV_ENTITY_SOUND)
    te!.s.eventParm = G_SoundIndex(soundPath)
    te!.s.clientNum = ent.s.number
    te!.s.trickedentindex = channel
}

/**
```
==============
ValidUseTarget

Returns whether or not the targeted entity is useable
==============
```
*/
/// Source: oracle/codemp/game/g_utils.c:1453
func ValidUseTarget(_ ent: Entity) -> Bool {
    if ent.use == nil {
        return false
    }

    if (ent.flags & FL_INACTIVE) != 0 {
        //set by target_deactivate
        return false
    }

    if !((ent.r.svFlags & SVF_PLAYER_USABLE) != 0) {
        //Check for flag that denotes BUTTON_USE useability
        return false
    }

    return true
}

//use an ammo/health dispenser on another client
/// Source: oracle/codemp/game/g_utils.c:1474
func G_UseDispenserOn(_ ent: Entity, _ dispType: Int32, _ target: Entity) {
    if dispType == HI_HEALTHDISP {
        target.client!.ps.stats[STAT_HEALTH] += 4

        if target.client!.ps.stats[STAT_HEALTH] > target.client!.ps.stats[STAT_MAX_HEALTH] {
            target.client!.ps.stats[STAT_HEALTH] = target.client!.ps.stats[STAT_MAX_HEALTH]
        }

        target.client!.isMedHealed = level.time + 500
        target.health = target.client!.ps.stats[STAT_HEALTH]
    } else if dispType == HI_AMMODISP {
        if ent.client!.medSupplyDebounce < level.time {
            //do the next increment
            //increment based on the amount of ammo used per normal shot.
            target.client!.ps.ammo[weaponData[target.client!.ps.weapon].ammoIndex] += weaponData[target.client!.ps.weapon].energyPerShot

            if target.client!.ps.ammo[weaponData[target.client!.ps.weapon].ammoIndex] > ammoData[weaponData[target.client!.ps.weapon].ammoIndex].max {
                //cap it off
                target.client!.ps.ammo[weaponData[target.client!.ps.weapon].ammoIndex] = ammoData[weaponData[target.client!.ps.weapon].ammoIndex].max
            }

            //base the next supply time on how long the weapon takes to fire. Seems fair enough.
            ent.client!.medSupplyDebounce = level.time + weaponData[target.client!.ps.weapon].fireTime
        }
        target.client!.isMedSupplied = level.time + 500
    }
}

//see if this guy needs servicing from a specific type of dispenser
/// Source: oracle/codemp/game/g_utils.c:1508
func G_CanUseDispOn(_ ent: Entity, _ dispType: Int32) -> Int32 {
    if ent.client == nil || !ent.inuse || ent.health < 1 || ent.client!.ps.stats[STAT_HEALTH] < 1 {
        //dead or invalid
        return 0
    }

    if dispType == HI_HEALTHDISP {
        if ent.client!.ps.stats[STAT_HEALTH] < ent.client!.ps.stats[STAT_MAX_HEALTH] {
            //he's hurt
            return 1
        }

        //otherwise no
        return 0
    } else if dispType == HI_AMMODISP {
        if ent.client!.ps.weapon <= WP_NONE || ent.client!.ps.weapon > WP_BRYAR_OLD {
            //not a player-useable weapon
            return 0
        }

        if ent.client!.ps.ammo[weaponData[ent.client!.ps.weapon].ammoIndex] < ammoData[weaponData[ent.client!.ps.weapon].ammoIndex].max {
            //needs more ammo for current weapon
            return 1
        }

        //needs none
        return 0
    }

    //invalid type?
    return 0
}

/// Source: oracle/codemp/game/g_utils.c:1546
func TryHeal(_ ent: Entity, _ target: Entity) -> Bool {
    if g_gametype.integer == GT_SIEGE && ent.client!.siegeClass != -1 && target.inuse && target.maxHealth != 0 && target.healingclass != nil && !target.healingclass!.isEmpty && target.health > 0 && target.health < target.maxHealth {
        //it's not dead yet...
        let scl: SiegeClass? = bgSiegeClasses[ent.client!.siegeClass]

        if Q_stricmp(scl!.name, target.healingclass!) == 0 {
            //this thing can be healed by the class this player is using
            if target.healingDebounce < level.time {
                //do the actual heal
                target.health += 10
                if target.health > target.maxHealth {
                    //don't go too high
                    target.health = target.maxHealth
                }
                target.healingDebounce = level.time + target.healingrate
                if target.healingsound != nil && !target.healingsound!.isEmpty {
                    //play it
                    if target.s.solid == SOLID_BMODEL {
                        //ok, well, just play it on the client then.
                        G_Sound(ent, CHAN_AUTO, G_SoundIndex(target.healingsound!))
                    } else {
                        G_Sound(target, CHAN_AUTO, G_SoundIndex(target.healingsound!))
                    }
                }

                //update net health for bar
                G_ScaleNetHealth(target)
                if target.target_ent != nil && target.target_ent!.maxHealth != 0 {
                    target.target_ent!.health = target.health
                    G_ScaleNetHealth(target.target_ent!)
                }
            }

            //keep them in the healing anim even when the healing debounce is not yet expired
            if ent.client!.ps.torsoAnim == BOTH_BUTTON_HOLD || ent.client!.ps.torsoAnim == BOTH_CONSOLE1 {
                //extend the time
                ent.client!.ps.torsoTimer = 500
            } else {
                G_SetAnim(ent, nil, SETANIM_TORSO, BOTH_BUTTON_HOLD, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
            }

            return true
        }
    }

    return false
}

/// Source: oracle/codemp/game/g_utils.c:1618
func TryUse(_ ent: Entity) {
    var target: Entity?
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { trace -> Bool in
        var src = vec3_t()
        var dest = vec3_t()
        var vf = vec3_t()
        var viewspot = vec3_t()

        tryJetPack: do {
            if g_gametype.integer == GT_SIEGE && !gSiegeRoundBegun {
                //nothing can be used til the round starts.
                return true
            }

            if ent.client == nil || (ent.client!.ps.weaponTime > 0 && ent.client!.ps.torsoAnim != BOTH_BUTTON_HOLD && ent.client!.ps.torsoAnim != BOTH_CONSOLE1) || ent.health < 1 || (ent.client!.ps.pm_flags & PMF_FOLLOW) != 0 || ent.client!.sess.sessionTeam == TEAM_SPECTATOR || (ent.client!.ps.forceHandExtend != HANDEXTEND_NONE && ent.client!.ps.forceHandExtend != HANDEXTEND_DRAGGING) {
                return true
            }

            if ent.client!.ps.emplacedIndex != 0 {
                //on an emplaced gun or using a vehicle, don't do anything when hitting use key
                return true
            }

            if ent.s.number < MAX_CLIENTS && ent.client != nil && ent.client!.ps.m_iVehicleNum != 0 {
                let currentVeh: Entity? = g_entities[ent.client!.ps.m_iVehicleNum]
                if currentVeh!.inuse && currentVeh!.m_pVehicle != nil {
                    let pVeh: Vehicle? = currentVeh!.m_pVehicle
                    if pVeh!.m_iBoarding == 0 {
                        pVeh!.m_pVehicleInfo!.runEject(pVeh, BgEntity(ent), false)
                    }
                    return true
                }
            }

            if ent.client!.jetPackOn {
                //can't use anything else to jp is off
                break tryJetPack
            }

            if ent.client!.bodyGrabIndex != ENTITYNUM_NONE {
                //then hitting the use key just means let go
                if ent.client!.bodyGrabTime < level.time {
                    let grabbed: Entity? = g_entities[ent.client!.bodyGrabIndex]

                    if grabbed!.inuse {
                        if grabbed!.client != nil {
                            grabbed!.client!.ps.ragAttach = 0
                        } else {
                            grabbed!.s.ragAttach = 0
                        }
                    }
                    ent.client!.bodyGrabIndex = ENTITYNUM_NONE
                    ent.client!.bodyGrabTime = level.time + 1000
                }
                return true
            }

            viewspot = ent.client!.ps.origin
            viewspot[2] += ent.client!.ps.viewheight

            src = viewspot
            // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("TryUse", source: "oracle/codemp/game/g_utils.c:1618")
            var scratchRight = vec3_t()
            // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("TryUse", source: "oracle/codemp/game/g_utils.c:1618")
            var scratchUp = vec3_t()
            AngleVectors(ent.client!.ps.viewangles, &vf, &scratchRight, &scratchUp)

            _VectorMA(src, USE_DISTANCE, vf, &dest)

            //Trace ahead to find a valid target
            trap_Trace(trace, src, vec3_origin, vec3_origin, dest, ent.s.number, MASK_OPAQUE | CONTENTS_SOLID | CONTENTS_BODY | CONTENTS_ITEM | CONTENTS_CORPSE)

            if trace.fraction == 1.0 || trace.entityNum < 1 {
                break tryJetPack
            }

            target = g_entities[trace.entityNum]

            //Enable for corpse dragging

            if target != nil && target!.m_pVehicle != nil && target!.client != nil && target!.s.NPC_class == CLASS_VEHICLE && ent.client!.ps.zoomMode == 0 {
                //if target is a vehicle then perform appropriate checks
                let pVeh: Vehicle? = target!.m_pVehicle

                if pVeh!.m_pVehicleInfo != nil {
                    if ent.r.ownerNum == target!.s.number {
                        //user is already on this vehicle so eject him
                        pVeh!.m_pVehicleInfo!.runEject(pVeh, BgEntity(ent), false)
                    } else {
                        // Otherwise board this vehicle.
                        if g_gametype.integer < GT_TEAM || target!.alliedTeam == 0 || (target!.alliedTeam == ent.client!.sess.sessionTeam) {
                            //not belonging to a team, or client is on same team
                            pVeh!.m_pVehicleInfo!.runBoard(pVeh, BgEntity(ent))
                        }
                    }
                    //clear the damn button!
                    ent.client!.pers.cmd.buttons &= ~BUTTON_USE
                    return true
                }
            }


            //for now, we will use the standard use anim
            if ((ent.client!.ps.stats[STAT_HOLDABLE_ITEMS] & (1 << HI_HEALTHDISP)) != 0 || (ent.client!.ps.stats[STAT_HOLDABLE_ITEMS] & (1 << HI_AMMODISP)) != 0) && target != nil && target!.inuse && target!.client != nil && target!.health > 0 && OnSameTeam(ent, target!) && (G_CanUseDispOn(target!, HI_HEALTHDISP) != 0 || G_CanUseDispOn(target!, HI_AMMODISP) != 0) {
                //a live target that's on my team, we can use him
                if G_CanUseDispOn(target!, HI_HEALTHDISP) != 0 {
                    G_UseDispenserOn(ent, HI_HEALTHDISP, target!)
                }
                if G_CanUseDispOn(target!, HI_AMMODISP) != 0 {
                    G_UseDispenserOn(ent, HI_AMMODISP, target!)
                }

                //for now, we will use the standard use anim
                if ent.client!.ps.torsoAnim == BOTH_BUTTON_HOLD {
                    //extend the time
                    ent.client!.ps.torsoTimer = 500
                } else {
                    G_SetAnim(ent, nil, SETANIM_TORSO, BOTH_BUTTON_HOLD, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
                }
                ent.client!.ps.weaponTime = ent.client!.ps.torsoTimer
                return true
            }


            //Check for a use command
            if ValidUseTarget(target!) && (g_gametype.integer != GT_SIEGE || target!.alliedTeam == 0 || target!.alliedTeam != ent.client!.sess.sessionTeam || g_ff_objectives.integer != 0) {
                if ent.client!.ps.torsoAnim == BOTH_BUTTON_HOLD || ent.client!.ps.torsoAnim == BOTH_CONSOLE1 {
                    //extend the time
                    ent.client!.ps.torsoTimer = 500
                } else {
                    G_SetAnim(ent, nil, SETANIM_TORSO, BOTH_BUTTON_HOLD, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
                }
                ent.client!.ps.weaponTime = ent.client!.ps.torsoTimer
                /*
                NPC_SetAnim( ent, SETANIM_TORSO, BOTH_FORCEPUSH, SETANIM_FLAG_OVERRIDE|SETANIM_FLAG_HOLD );
                if ( !VectorLengthSquared( ent->client->ps.velocity ) )
                {
                NPC_SetAnim( ent, SETANIM_LEGS, BOTH_FORCEPUSH, SETANIM_FLAG_NORMAL|SETANIM_FLAG_HOLD );
                }
                */
                if target!.touch == Touch.Touch_Button {
                    //pretend we touched it
                    target!.runTouch(ent, nil)
                } else {
                    GlobalUse(target!, ent, ent)
                }
                return true
            }

            if TryHeal(ent, target!) {
                return true
            }

        }
        //if we got here, we didn't actually use anything else, so try to toggle jetpack if we are in the air, or if it is already on
        if (ent.client!.ps.stats[STAT_HOLDABLE_ITEMS] & (1 << HI_JETPACK)) != 0 {
            if ent.client!.jetPackOn || ent.client!.ps.groundEntityNum == ENTITYNUM_NONE {
                ItemUse_Jetpack(ent)
                return true
            }
        }

        if (ent.client!.ps.stats[STAT_HOLDABLE_ITEMS] & (1 << HI_AMMODISP)) != 0 {
            //if you used nothing, then try spewing out some ammo
            // Raven's record lives to the end of his block, so the block is the closure.
            // The closure gives true where Raven returns from the function.
            let earlyOut2 = Trace.scratch { trToss -> Bool in
                var fAng = vec3_t()
                var fwd = vec3_t()

                fAng = vec3_t(0.0, ent.client!.ps.viewangles[YAW], 0.0)
                // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("TryUse", source: "oracle/codemp/game/g_utils.c:1618")
                var scratchRight2 = vec3_t()
                // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("TryUse", source: "oracle/codemp/game/g_utils.c:1618")
                var scratchUp2 = vec3_t()
                AngleVectors(fAng, &fwd, &scratchRight2, &scratchUp2)

                _VectorMA(ent.client!.ps.origin, 64.0, fwd, &fwd)
                trap_Trace(trToss, ent.client!.ps.origin, playerMins, playerMaxs, fwd, ent.s.number, ent.clipmask)
                if trToss.fraction == 1.0 && trToss.allsolid == 0 && trToss.startsolid == 0 {
                    ItemUse_UseDisp(ent, HI_AMMODISP)
                    G_AddEvent(ent, EV_USE_ITEM0 + HI_AMMODISP, 0)
                    return true
                }
                return false
            }
            if earlyOut2 {
                return true
            }
        }
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/game/g_utils.c:1877
func G_PointInBounds(_ point: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t) -> Bool {
    var i: Int32

    i = 0
    while i < 3 {
        if point[i] < mins[i] {
            return false
        }
        if point[i] > maxs[i] {
            return false
        }
        i += 1
    }

    return true
}

/// Source: oracle/codemp/game/g_utils.c:1896
func G_BoxInBounds(_ point: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ boundsMins: JKAShared.vec3_t, _ boundsMaxs: JKAShared.vec3_t) -> Bool {
    var boxMins = vec3_t()
    var boxMaxs = vec3_t()

    boxMins = point + mins
    boxMaxs = point + maxs

    if boxMaxs[0] > boundsMaxs[0] {
        return false
    }

    if boxMaxs[1] > boundsMaxs[1] {
        return false
    }

    if boxMaxs[2] > boundsMaxs[2] {
        return false
    }

    if boxMins[0] < boundsMins[0] {
        return false
    }

    if boxMins[1] < boundsMins[1] {
        return false
    }

    if boxMins[2] < boundsMins[2] {
        return false
    }

    //box is completely contained within bounds
    return true
}

/// Source: oracle/codemp/game/g_utils.c:1927
func G_SetAngles(_ ent: Entity, _ angles: JKAShared.vec3_t) {
    ent.r.currentAngles = angles
    ent.s.angles = angles
    ent.s.apos.trBase = angles
}

/// Source: oracle/codemp/game/g_utils.c:1934
func G_ClearTrace(_ start: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ ignore: Int32, _ clipmask: Int32) -> Bool {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Bool in

        trap_Trace(tr, start, mins, maxs, end, ignore, clipmask)

        if tr.allsolid != 0 || tr.startsolid != 0 || Double(tr.fraction) < 1.0 {
            return false
        }

        return true
    }
}

/**
```
================
G_SetOrigin

Sets the pos trajectory for a fixed position
================
```
*/
/// Source: oracle/codemp/game/g_utils.c:1955
func G_SetOrigin(_ ent: Entity, _ origin: inout JKAShared.vec3_t) {
    ent.s.pos.trBase = origin
    ent.s.pos.trType = TR_STATIONARY
    ent.s.pos.trTime = 0
    ent.s.pos.trDuration = 0
    ent.s.pos.trDelta = vec3_t()

    ent.r.currentOrigin = origin
}

/// Source: oracle/codemp/game/g_utils.c:1965
func G_CheckInSolid(_ `self`: Entity, _ fix: Bool) -> Bool {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { trace -> Bool in
        var end = vec3_t()
        var mins = vec3_t()

        end = `self`.r.currentOrigin
        end[2] += `self`.r.mins[2]
        mins = `self`.r.mins
        mins[2] = 0

        trap_Trace(trace, `self`.r.currentOrigin, mins, `self`.r.maxs, end, `self`.s.number, `self`.clipmask)
        if trace.allsolid != 0 || trace.startsolid != 0 {
            return true
        }

        if Double(trace.fraction) < 1.0 {
            if fix {
                //Put them at end of trace and check again
                var neworg = vec3_t()

                neworg = trace.endpos
                neworg[2] -= `self`.r.mins[2]
                G_SetOrigin(`self`, &neworg)
                trap_LinkEntity(`self`)

                return G_CheckInSolid(`self`, false)
            } else {
                return true
            }
        }

        return false
    }
}

/**
```
================
DebugLine

  debug polygons only work when running a local game
  with r_debugSurface set to 2
================
```
*/
/// Source: oracle/codemp/game/g_utils.c:2011
func DebugLine(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ color: Int32) -> Int32 {
    var points = [vec3_t](repeating: vec3_t(), count: 4)
    var dir = vec3_t()
    var cross = vec3_t()
    var up = vec3_t(0, 0, 1)
    let dot: Float

    points[0] = start
    points[1] = start
    //points[1][2] -= 2;
    points[2] = end
    //points[2][2] -= 2;
    points[3] = end


    dir = end - start
    VectorNormalize(&dir)
    dot = _DotProduct(dir, up)
    if Double(dot) > 0.99 || Double(dot) < -0.99 {
        cross = vec3_t(1, 0, 0)
    } else {
        CrossProduct(dir, up, &cross)
    }

    VectorNormalize(&cross)

    _VectorMA(points[0], 2, cross, &points[0])
    _VectorMA(points[1], -2, cross, &points[1])
    _VectorMA(points[2], -2, cross, &points[2])
    _VectorMA(points[3], 2, cross, &points[3])

    return trap_DebugPolygonCreate(color, 4, points)
}

/// Source: oracle/codemp/game/g_utils.c:2039
func G_ROFF_NotetrackCallback(_ cent: Entity, _ notetrack: String) {
    var type = CharBuf(256)
    var i: Int32 = 0
    var addlArg: Int32 = 0


    // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '!=' cannot be applied to operands of type 'Character' and 'Int'".
    // Raven wrote: while (notetrack[i] && notetrack[i] != ' ') { type[i] = notetrack[i]; i++; }
    portMissing("G_ROFF_NotetrackCallback", source: "oracle/codemp/game/g_utils.c:2039")

    type[i] = 0

    if i == 0 || type[0] == 0 {
        return
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '==' cannot be applied to operands of type 'Character' and 'Int32'".
    // Raven wrote: if (notetrack[i] == ' ') { addlArg = 1; }
    portMissing("G_ROFF_NotetrackCallback", source: "oracle/codemp/game/g_utils.c:2039")

    if strcmp(type, "loop") == 0 {
        if addlArg != 0 {
            cent.s.pos.trBase = cent.s.origin2
            cent.r.currentOrigin = cent.s.origin2
            cent.s.apos.trBase = cent.s.angles2
            cent.r.currentAngles = cent.s.angles2
        }

        trap_ROFF_Play(cent.s.number, cent.roffid, false)
    }
}

/// Source: oracle/codemp/game/g_utils.c:2082
func G_SpeechEvent(_ `self`: Entity, _ event: Int32) {
    G_AddEvent(`self`, event, 0)
}

/// Source: oracle/codemp/game/g_utils.c:2087
func G_ExpandPointToBBox(_ point: inout JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ ignore: Int32, _ clipmask: Int32) -> Bool {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Bool in
        var start = vec3_t()
        var end = vec3_t()
        var i: Int32 = 0

        start = point

        i = 0
        while i < 3 {
            end = start
            end[i] += mins[i]
            trap_Trace(tr, start, vec3_origin, vec3_origin, end, ignore, clipmask)
            if tr.allsolid != 0 || tr.startsolid != 0 {
                return false
            }
            if Double(tr.fraction) < 1.0 {
                end = start
                end[i] += maxs[i] - (mins[i] * tr.fraction)
                trap_Trace(tr, start, vec3_origin, vec3_origin, end, ignore, clipmask)
                if tr.allsolid != 0 || tr.startsolid != 0 {
                    return false
                }
                if Double(tr.fraction) < 1.0 {
                    return false
                }
                start = end
            }
            i += 1
        }
        //expanded it, now see if it's all clear
        trap_Trace(tr, start, mins, maxs, start, ignore, clipmask)
        if tr.allsolid != 0 || tr.startsolid != 0 {
            return false
        }
        point = start
        return true
    }
}

/// Source: oracle/codemp/game/g_utils.c:2131
func ShortestLineSegBewteen2LineSegs(_ start1: JKAShared.vec3_t, _ end1: JKAShared.vec3_t, _ start2: JKAShared.vec3_t, _ end2: JKAShared.vec3_t, _ close_pnt1: inout JKAShared.vec3_t, _ close_pnt2: inout JKAShared.vec3_t) -> Float {
    var current_dist: Float
    var new_dist: Float
    var new_pnt = vec3_t()
    //start1, end1 : the first segment
    //start2, end2 : the second segment

    //output, one point on each segment, the closest two points on the segments.

    //compute some temporaries:
    //vec start_dif = start2 - start1
    var start_dif = vec3_t()
    var v1 = vec3_t()
    var v2 = vec3_t()
    let v1v1: Float
    let v2v2: Float
    let v1v2: Float
    let denom: Float

    start_dif = start2 - start1
    //vec v1 = end1 - start1
    v1 = end1 - start1
    //vec v2 = end2 - start2
    v2 = end2 - start2
    //
    v1v1 = _DotProduct(v1, v1)
    v2v2 = _DotProduct(v2, v2)
    v1v2 = _DotProduct(v1, v2)

    //the main computation

    denom = (v1v2 * v1v2) - (v1v1 * v2v2)

    //if denom is small, then skip all this and jump to the section marked below
    if abs(denom) > 0.001 {
        var s: Float = -((v2v2 * _DotProduct(v1, start_dif)) - (v1v2 * _DotProduct(v2, start_dif))) / denom
        var t: Float = ((v1v1 * _DotProduct(v2, start_dif)) - (v1v2 * _DotProduct(v1, start_dif))) / denom
        var done: Bool = true

        if s < 0 {
            done = false
            s = 0 // and see note below
        }

        if s > 1 {
            done = false
            s = 1 // and see note below
        }

        if t < 0 {
            done = false
            t = 0 // and see note below
        }

        if t > 1 {
            done = false
            t = 1 // and see note below
        }

        //vec close_pnt1 = start1 + s * v1
        _VectorMA(start1, s, v1, &close_pnt1)
        //vec close_pnt2 = start2 + t * v2
        _VectorMA(start2, t, v2, &close_pnt2)

        current_dist = Distance(close_pnt1, close_pnt2)
        //now, if none of those if's fired, you are done.
        if done {
            return current_dist
        }
        //If they did fire, then we need to do some additional tests.

        //What we are gonna do is see if we can find a shorter distance than the above
        //involving the endpoints.
    } else {
        //******start here for paralell lines with current_dist = infinity****
        current_dist = Float(Q3_INFINITE)
    }

    //test 2 close_pnts first
    /*
    G_FindClosestPointOnLineSegment( start1, end1, close_pnt2, new_pnt );
    new_dist = Distance( close_pnt2, new_pnt );
    if ( new_dist < current_dist )
    {//then update close_pnt1 close_pnt2 and current_dist
    VectorCopy( new_pnt, close_pnt1 );
    VectorCopy( close_pnt2, close_pnt2 );
    current_dist = new_dist;
    }

    G_FindClosestPointOnLineSegment( start2, end2, close_pnt1, new_pnt );
    new_dist = Distance( close_pnt1, new_pnt );
    if ( new_dist < current_dist )
    {//then update close_pnt1 close_pnt2 and current_dist
    VectorCopy( close_pnt1, close_pnt1 );
    VectorCopy( new_pnt, close_pnt2 );
    current_dist = new_dist;
    }
    */
    //test all the endpoints
    new_dist = Distance(start1, start2)
    if new_dist < current_dist {
        //then update close_pnt1 close_pnt2 and current_dist
        close_pnt1 = start1
        close_pnt2 = start2
        current_dist = new_dist
    }

    new_dist = Distance(start1, end2)
    if new_dist < current_dist {
        //then update close_pnt1 close_pnt2 and current_dist
        close_pnt1 = start1
        close_pnt2 = end2
        current_dist = new_dist
    }

    new_dist = Distance(end1, start2)
    if new_dist < current_dist {
        //then update close_pnt1 close_pnt2 and current_dist
        close_pnt1 = end1
        close_pnt2 = start2
        current_dist = new_dist
    }

    new_dist = Distance(end1, end2)
    if new_dist < current_dist {
        //then update close_pnt1 close_pnt2 and current_dist
        close_pnt1 = end1
        close_pnt2 = end2
        current_dist = new_dist
    }

    //Then we have 4 more point / segment tests

    G_FindClosestPointOnLineSegment(start2, end2, start1, &new_pnt)
    new_dist = Distance(start1, new_pnt)
    if new_dist < current_dist {
        //then update close_pnt1 close_pnt2 and current_dist
        close_pnt1 = start1
        close_pnt2 = new_pnt
        current_dist = new_dist
    }

    G_FindClosestPointOnLineSegment(start2, end2, end1, &new_pnt)
    new_dist = Distance(end1, new_pnt)
    if new_dist < current_dist {
        //then update close_pnt1 close_pnt2 and current_dist
        close_pnt1 = end1
        close_pnt2 = new_pnt
        current_dist = new_dist
    }

    G_FindClosestPointOnLineSegment(start1, end1, start2, &new_pnt)
    new_dist = Distance(start2, new_pnt)
    if new_dist < current_dist {
        //then update close_pnt1 close_pnt2 and current_dist
        close_pnt1 = new_pnt
        close_pnt2 = start2
        current_dist = new_dist
    }

    G_FindClosestPointOnLineSegment(start1, end1, end2, &new_pnt)
    new_dist = Distance(end2, new_pnt)
    if new_dist < current_dist {
        //then update close_pnt1 close_pnt2 and current_dist
        close_pnt1 = new_pnt
        close_pnt2 = end2
        current_dist = new_dist
    }

    return current_dist
}

/// Source: oracle/codemp/game/g_utils.c:2309
func GetAnglesForDirection(_ p1: JKAShared.vec3_t, _ p2: JKAShared.vec3_t, _ out: inout JKAShared.vec3_t) {
    var v = vec3_t()

    v = p2 - p1
    vectoangles(v, &out)
}
