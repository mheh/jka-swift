import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

// sv_referee.cpp -- deterministic "referee" instrumentation layer.
//
// Provides:
//   sv_stepper       (0/1)    gate SV_Frame; frames only advance when granted via ref_step
//   sv_recordInputs  (string) record all client inputs/lifecycle to a file at map load
//   sv_replayInputs  (string) replay a recorded input file through fake clients
//   sv_refSeed       (int)    substitute randomSeed passed to GAME_INIT
//   sv_refTrace      (0/1)    per-frame ring buffer of all engine<->game boundary crossings
//
// Console commands: ref_step [n], ref_dump, ref_trace  (all output prefixed "REF ")
//
// When any referee feature is active the game module is bound through the
// legacy vmMain/syscall ABI (see SVRef_ForceLegacy) so that every boundary
// crossing funnels through VM_Call / SV_GameSystemCalls.

// This file is the port of the OpenJK fork's sv_referee.cpp at commit f6d2875e, not a Raven file.
// Its functions keep the fork's names and lines, and the hook sites in Raven's files carry the AI lines.

/// Source: openjk/codemp/server/sv_referee.cpp:22
var sv_stepper: JKAMP.Cvar? {
    get { world.sv_stepper }
    set { world.sv_stepper = newValue }
}

/// Source: openjk/codemp/server/sv_referee.cpp:23
var sv_recordInputs: JKAMP.Cvar? {
    get { world.sv_recordInputs }
    set { world.sv_recordInputs = newValue }
}

/// Source: openjk/codemp/server/sv_referee.cpp:24
var sv_replayInputs: JKAMP.Cvar? {
    get { world.sv_replayInputs }
    set { world.sv_replayInputs = newValue }
}

/// Source: openjk/codemp/server/sv_referee.cpp:25
var sv_refSeed: JKAMP.Cvar? {
    get { world.sv_refSeed }
    set { world.sv_refSeed = newValue }
}

/// Source: openjk/codemp/server/sv_referee.cpp:26
var sv_refTrace: JKAMP.Cvar? {
    get { world.sv_refTrace }
    set { world.sv_refTrace = newValue }
}

/// Source: openjk/codemp/server/sv_referee.cpp:28
var ref_pendingSteps: Int32 {
    get { world.ref_pendingSteps }
    set { world.ref_pendingSteps = newValue }
}

// completed game frames since map load
/// Source: openjk/codemp/server/sv_referee.cpp:29
var ref_frameIndex: Int32 {
    get { world.ref_frameIndex }
    set { world.ref_frameIndex = newValue }
}

// seed actually passed to GAME_INIT
/// Source: openjk/codemp/server/sv_referee.cpp:30
var ref_lastSeed: Int32 {
    get { world.ref_lastSeed }
    set { world.ref_lastSeed = newValue }
}

/*
================================================================================
FNV-1a 32-bit state checksum
================================================================================
*/

/// Source: openjk/codemp/server/sv_referee.cpp:38
// AI: The fork's function is file-scope. It is internal, so the unit test of the referee reaches it.
func Ref_Fnv1a(_ data: Slots<byte>, _ len: Int32, _ hash: UInt32) -> UInt32 {
    // The fork assigns his own `hash` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var hash = hash
    var i: Int32

    i = 0
    while i < len {
        hash ^= UInt32(data[i])
        hash = hash &* 16777619
        i += 1
    }
    return hash
}

/// Source: openjk/codemp/server/sv_referee.cpp:47
private func Ref_AllZero(_ data: Slots<byte>, _ len: Int32) -> Bool {
    var i: Int32

    i = 0
    while i < len {
        if data[i] != 0 {
            return false
        }
        i += 1
    }
    return true
}

// FNV-1a over: each entity's entityState_t + entityShared_t (skipping entities
// where both are all-zero), then each connected client's playerState_t.
/// Source: openjk/codemp/server/sv_referee.cpp:58
private func Ref_Checksum() -> UInt32 {
    var hash: UInt32 = 2166136261
    var i: Int32

    if sv.gentities != nil {
        i = 0
        while i < sv.num_entities {
            let ent = SV_GentityNum(i)!
            let s = Slots(record: ent.s).bytes
            let r = Slots(record: ent.r).bytes
            if Ref_AllZero(s, Int32(EntityState.byteCount)) && Ref_AllZero(r, Int32(EntityShared.byteCount)) {
                i += 1
                continue
            }
            hash = Ref_Fnv1a(s, Int32(EntityState.byteCount), hash)
            hash = Ref_Fnv1a(r, Int32(EntityShared.byteCount), hash)
            i += 1
        }
    }
    if svs.clients != nil && sv.gameClients != nil {
        i = 0
        while i < sv_maxclients!.integer {
            if svs.clientsSlots[i].state < CS_CONNECTED {
                i += 1
                continue
            }
            hash = Ref_Fnv1a(Slots(record: SV_GameClientNum(i)!).bytes, Int32(PlayerState.byteCount), hash)
            i += 1
        }
    }
    return hash
}

/*
================================================================================
Boundary trace ring buffer
================================================================================
*/

/// Source: openjk/codemp/server/sv_referee.cpp:89
let REF_TRACE_MAX: Int32 = 65536

/// The fork's `refTraceEnt_t`, one boundary call in the trace ring.
/// Source: openjk/codemp/server/sv_referee.cpp:91
// AI: The fork keeps the ring in one calloc block of C records. The ring is an Array of these rows, held by the world, rule 9.
final class refTraceEnt_t {
    var dir: byte = 0  // 0 = IN (engine->game), 1 = OUT (game->engine)
    var cmd: Int32 = 0  // game command / trap number
    var args = [Int](repeating: 0, count: 8)
    var ret: Int = 0
}

/// Source: openjk/codemp/server/sv_referee.cpp:98
var ref_traceBuf: [refTraceEnt_t]? {
    get { world.ref_traceBuf }
    set { world.ref_traceBuf = newValue }
}

/// Source: openjk/codemp/server/sv_referee.cpp:99
var ref_traceCount: Int32 {
    get { world.ref_traceCount }
    set { world.ref_traceCount = newValue }
}

/// Source: openjk/codemp/server/sv_referee.cpp:100
var ref_traceOverflow: Bool {
    get { world.ref_traceOverflow }
    set { world.ref_traceOverflow = newValue }
}

/// Source: openjk/codemp/server/sv_referee.cpp:102
private func Ref_TraceActive() -> Bool {
    if sv_refTrace == nil || sv_refTrace!.integer == 0 {
        return false
    }
    if ref_traceBuf == nil {
        // The fork tests the result of calloc for NULL, and an Array is never NULL, so the test and its failure arm drop.
        ref_traceBuf = (0..<REF_TRACE_MAX).map { _ in refTraceEnt_t() }
    }
    return true
}

/// Source: openjk/codemp/server/sv_referee.cpp:113
private func Ref_TraceReserve() -> Int32 {
    if ref_traceCount >= REF_TRACE_MAX {
        ref_traceOverflow = true
        return -1
    }
    ref_traceCount += 1
    return ref_traceCount - 1
}

// engine -> game (VM_Call on the game VM); hooked from qcommon/vm.cpp
/// Source: openjk/codemp/server/sv_referee.cpp:122
func SVRef_TraceVmCall(_ callnum: Int32, _ a0: Int, _ a1: Int, _ a2: Int, _ a3: Int) {
    let idx: Int32
    if !Ref_TraceActive() {
        return
    }
    idx = Ref_TraceReserve()
    if idx < 0 {
        return
    }
    ref_traceBuf![idx].dir = 0
    ref_traceBuf![idx].cmd = callnum
    ref_traceBuf![idx].args[0] = a0
    ref_traceBuf![idx].args[1] = a1
    ref_traceBuf![idx].args[2] = a2
    ref_traceBuf![idx].args[3] = a3
    ref_traceBuf![idx].args[4] = 0
    ref_traceBuf![idx].args[5] = 0
    ref_traceBuf![idx].args[6] = 0
    ref_traceBuf![idx].args[7] = 0
    ref_traceBuf![idx].ret = 0
}

// game -> engine: tracing wrapper around the real syscall dispatcher
/// Source: openjk/codemp/server/sv_referee.cpp:140
// AI: The fork's wrapper is public in C. It is public, because the shell installs it as `GameSystemCalls` of the view target.
public func SV_GameSystemCalls(_ args: Slots<Int32>) -> Int {
    let idx: Int32
    var i: Int32
    let ret: Int

    if !Ref_TraceActive() {
        return SV_GameSystemCalls_Real(args)
    }

    idx = Ref_TraceReserve()
    if idx >= 0 {
        ref_traceBuf![idx].dir = 1
        ref_traceBuf![idx].cmd = args[0]
        i = 0
        while i < 8 {
            // AI: The fork stores the `intptr_t` word. The arm reads the whole word through VMA, because `args[i]` gives its low `int`.
            ref_traceBuf![idx].args[i] = args.VMA(i + 1) as Int
            i += 1
        }
        ref_traceBuf![idx].ret = 0
    }
    ret = SV_GameSystemCalls_Real(args)
    if idx >= 0 {
        ref_traceBuf![idx].ret = ret
    }
    return ret
}

/*
================================================================================
Recorder

File format: one text header line
    REFREC v1 map=<mapname> seed=<seed> fps=<sv_fps>\n
followed by little-endian binary records:
    { u32 frameIndex, u8 type, u8 clientNum, u16 lenOrPad, payload }
    type 1: payload = usercmd_t (engine sizeof), lenOrPad = 0
    type 2: payload = userinfo string bytes (not NUL terminated), lenOrPad = length
    type 3: no payload, lenOrPad = 0
================================================================================
*/

/// Source: openjk/codemp/server/sv_referee.cpp:175
var ref_recFile: fileHandle_t {
    get { world.ref_recFile }
    set { world.ref_recFile = newValue }
}

/// Source: openjk/codemp/server/sv_referee.cpp:176
var ref_inReplayExec: Bool {
    get { world.ref_inReplayExec }
    set { world.ref_inReplayExec = newValue }
}

// type=2 already written for this client this recording
/// Source: openjk/codemp/server/sv_referee.cpp:177
var ref_recSeen: [Bool] {
    get { world.ref_recSeen }
    set { world.ref_recSeen = newValue }
}

/// Source: openjk/codemp/server/sv_referee.cpp:179
private func Ref_RecHeaderBytes(_ frame: UInt32, _ type: byte, _ clientNum: byte, _ len: UInt16) {
    // AI: The fork declares `byte hdr[8]` on his stack. The bytes are a CharBuf, which the CharBuf form of FS_Write takes.
    var hdr = CharBuf(8)
    hdr[0] = frame & 0xff
    hdr[1] = (frame >> 8) & 0xff
    hdr[2] = (frame >> 16) & 0xff
    hdr[3] = (frame >> 24) & 0xff
    hdr[4] = type
    hdr[5] = clientNum
    hdr[6] = len & 0xff
    hdr[7] = (len >> 8) & 0xff
    FS_Write(hdr, Int32(hdr.count), ref_recFile)
}

/// Source: openjk/codemp/server/sv_referee.cpp:192
private func Ref_RecordStop() {
    if ref_recFile != 0 {
        FS_FCloseFile(ref_recFile)
        ref_recFile = 0
        Com_Printf("REF RECORD END\n")
    }
}

// NOTE: bot (NA_BOT) clients ARE recorded -- the input corpus is generated by
// botlib bots. The record/replay double-drive hazard only exists if both run
// simultaneously, which is hard-disabled in SVRef_MapSpawned.
/// Source: openjk/codemp/server/sv_referee.cpp:203
func SVRef_RecordEnterWorld(_ cl: Client) {
    let len: UInt16
    if ref_recFile == 0 {
        return
    }
    len = UInt16(truncatingIfNeeded: strlen(cl.userinfo))
    Ref_RecHeaderBytes(UInt32(bitPattern: ref_frameIndex), 2, byte(truncatingIfNeeded: svs.clientsSlots.index(of: cl)), len)
    FS_Write(cl.userinfoBuffer, Int32(len), ref_recFile)
    ref_recSeen[svs.clientsSlots.index(of: cl)] = true
}

/// Source: openjk/codemp/server/sv_referee.cpp:213
func SVRef_OnClientThink(_ cl: Client, _ cmd: JKAMP.Usercmd) {
    if ref_recFile == 0 || ref_inReplayExec {
        return
    }
    // bots never pass through SV_ClientEnterWorld (they enter game-side via
    // G_AddBot), so synthesize their type=2 record on their first cmd
    if !ref_recSeen[svs.clientsSlots.index(of: cl)] {
        SVRef_RecordEnterWorld(cl)
    }
    Ref_RecHeaderBytes(UInt32(bitPattern: ref_frameIndex), 1, byte(truncatingIfNeeded: svs.clientsSlots.index(of: cl)), 0)
    FS_Write(Slots(record: cmd).bytes, Int32(Usercmd.byteCount), ref_recFile)
}

/// Source: openjk/codemp/server/sv_referee.cpp:224
func SVRef_RecordDisconnect(_ cl: Client) {
    if ref_recFile == 0 {
        return
    }
    if cl.state < CS_CONNECTED {
        return
    }
    Ref_RecHeaderBytes(UInt32(bitPattern: ref_frameIndex), 3, byte(truncatingIfNeeded: svs.clientsSlots.index(of: cl)), 0)
    ref_recSeen[svs.clientsSlots.index(of: cl)] = false  // a later reconnect re-emits type=2
}

/*
================================================================================
Replayer
================================================================================
*/

// FS_ReadFile buffer
/// Source: openjk/codemp/server/sv_referee.cpp:239
var ref_rpBuf: Slots<byte>? {
    get { world.ref_rpBuf }
    set { world.ref_rpBuf = newValue }
}

/// Source: openjk/codemp/server/sv_referee.cpp:240
var ref_rpLen: Int32 {
    get { world.ref_rpLen }
    set { world.ref_rpLen = newValue }
}

// offset of first binary record
/// Source: openjk/codemp/server/sv_referee.cpp:241
var ref_rpBodyOfs: Int32 {
    get { world.ref_rpBodyOfs }
    set { world.ref_rpBodyOfs = newValue }
}

/// Source: openjk/codemp/server/sv_referee.cpp:242
var ref_rpCursor: Int32 {
    get { world.ref_rpCursor }
    set { world.ref_rpCursor = newValue }
}

/// Source: openjk/codemp/server/sv_referee.cpp:243
var ref_rpSeed: Int32 {
    get { world.ref_rpSeed }
    set { world.ref_rpSeed = newValue }
}

/// Source: openjk/codemp/server/sv_referee.cpp:244
var ref_rpLoaded: Bool {
    get { world.ref_rpLoaded }
    set { world.ref_rpLoaded = newValue }
}

/// Source: openjk/codemp/server/sv_referee.cpp:245
var ref_rpActive: Bool {
    get { world.ref_rpActive }
    set { world.ref_rpActive = newValue }
}

/// Source: openjk/codemp/server/sv_referee.cpp:246
var ref_fake: [Bool] {
    get { world.ref_fake }
    set { world.ref_fake = newValue }
}

/// Source: openjk/codemp/server/sv_referee.cpp:248
private func Ref_ReplayFree() {
    if ref_rpBuf != nil {
        FS_FreeFile(ref_rpBuf!)
        ref_rpBuf = nil
    }
    ref_rpLen = 0
    ref_rpBodyOfs = 0
    ref_rpCursor = 0
    ref_rpSeed = 0
    ref_rpLoaded = false
    ref_rpActive = false
}

// called (lazily) from SVRef_GameSeed so the recorded seed is available for GAME_INIT
/// Source: openjk/codemp/server/sv_referee.cpp:258
private func Ref_ReplayLoad() {
    let len: Int32
    var i: Int32
    var block: OpaquePointer? = nil

    if ref_rpLoaded {
        return
    }

    len = FS_ReadFile(sv_replayInputs!.string!, &block)
    // AI: The fork reads the file into the `byte *` ref_rpBuf. The buffer is a Slots over the `len` bytes and the NUL that FS_ReadFile puts after them.
    ref_rpBuf = len > 0 ? ZipBackend.bytes(block, count: len + 1) : nil
    if len <= 0 || ref_rpBuf == nil {
        Com_Printf("REF WARN cannot read replay file '%s'\n", sv_replayInputs!.string!)
        ref_rpBuf = nil
        return
    }
    ref_rpLen = len

    // parse the text header line
    i = 0
    while i < ref_rpLen && ref_rpBuf![i] != byte(ascii: "\n") {
        i += 1
    }
    // AI: The fork compares the buffer cast to `char *` with Q_strncmp. The call is the strncmp form over a Slots of bytes.
    if i >= ref_rpLen || strncmp(ref_rpBuf!, "REFREC v1 ", 10) != 0 {
        Com_Printf("REF WARN replay file '%s' has bad header\n", sv_replayInputs!.string!)
        Ref_ReplayFree()
        return
    }
    do {
        var hdr = CharBuf(256)
        // AI: The fork copies the line with Q_strncpyz from the buffer cast to `char *`. The copy takes the bytes before the bound, and the zeroed CharBuf ends the text.
        Com_Memcpy(&hdr, ref_rpBuf!, (i + 1 < Int32(hdr.count) ? i + 1 : Int32(hdr.count)) - 1)
        if let p = strstr(hdr, "seed=") {
            ref_rpSeed = atoi(hdr[(p + 5)...])
        }
    }
    ref_rpBodyOfs = i + 1
    ref_rpCursor = ref_rpBodyOfs
    ref_rpLoaded = true
    Com_Printf("REF REPLAY LOADED file=%s bytes=%d seed=%d\n", sv_replayInputs!.string!, ref_rpLen, ref_rpSeed)
}

/// Source: openjk/codemp/server/sv_referee.cpp:295
private func Ref_SpawnFake(_ num: Int32, _ userinfo: String) {
    let cl: Client
    let denied: String?

    if num < 0 || num >= sv_maxclients!.integer {
        Com_Printf("REF WARN replay client %d out of range\n", num)
        return
    }
    cl = svs.clientsSlots[num]
    if cl.state != CS_FREE {
        Com_Printf("REF WARN replay client slot %d not free\n", num)
        return
    }

    cl.clear()
    Q_strncpyz(&cl.userinfoBuffer, userinfo, Int32(cl.userinfoBuffer.count))
    // NA_BOT: all network sends to this client become no-ops and it can never
    // be matched by real inbound traffic
    cl.netchan.remoteAddress.type = NA_BOT
    cl.state = CS_CONNECTED
    cl.lastConnectTime = svs.time
    cl.lastPacketTime = cl.lastConnectTime

    // CRITICAL: isBot = qfalse so the game runs the human code path
    // AI: The fork calls GVM_ClientConnect, which OpenJK adds. The call is Raven's VM_Call of GAME_CLIENT_CONNECT in the form of SV_DirectConnect.
    let deniedWord = VM_Call(gvm!, GAME_CLIENT_CONNECT, num, true, false)
    if deniedWord != 0 {
        denied = VM_ExplicitArgPtr(gvm!, deniedWord)
        Com_Printf("REF WARN replay client %d denied: %s\n", num, denied ?? "(null)")
        cl.state = CS_FREE
        return
    }

    Q_strncpyz(&cl.nameBuffer, Info_ValueForKey(cl.userinfo, "name"), Int32(cl.nameBuffer.count))
    cl.rate = 100000
    cl.snapshotMsec = 1000 / (sv_fps!.integer > 0 ? sv_fps!.integer : 20)
    // AI: The fork sets `cl->wishSnaps`, which Raven's client_t does not have, so the line drops.
    cl.gentity = SV_GentityNum(num)
    cl.gentity!.s.number = num
    cl.state = CS_ACTIVE
    cl.deltaMessage = -1
    cl.nextSnapshotTime = svs.time

    // AI: The fork calls GVM_ClientBegin, which OpenJK adds. The call is Raven's VM_Call of GAME_CLIENT_BEGIN.
    VM_Call(gvm!, GAME_CLIENT_BEGIN, num)
    ref_fake[num] = true
    Com_Printf("REF REPLAY CONNECT %d %s\n", num, cl.name)
}

/// Source: openjk/codemp/server/sv_referee.cpp:340
private func Ref_DropFake(_ num: Int32) {
    let cl: Client
    if num < 0 || num >= sv_maxclients!.integer || !ref_fake[num] {
        return
    }
    // AI: The fork calls GVM_ClientDisconnect, which OpenJK adds. The call is Raven's VM_Call of GAME_CLIENT_DISCONNECT.
    VM_Call(gvm!, GAME_CLIENT_DISCONNECT, num)
    SV_SetUserinfo(num, "")
    cl = svs.clientsSlots[num]
    cl.state = CS_FREE
    cl.name = ""
    cl.gentity = nil
    ref_fake[num] = false
    Com_Printf("REF REPLAY DISCONNECT %d\n", num)
}

// execute all recorded records whose frameIndex <= the frame about to run
/// Source: openjk/codemp/server/sv_referee.cpp:355
// AI: The fork's function is file-scope. It is internal, so the unit test of the referee reaches it.
func Ref_ReplayAdvance() {
    var i: Int32

    if !ref_rpActive {
        return
    }

    while ref_rpCursor + 8 <= ref_rpLen {
        // AI: The fork reads the header bytes through a `byte *` and shifts them into the words. The word subscripts read the little-endian fields.
        let p = ref_rpBuf!.suffix(from: ref_rpCursor)
        let frame = UInt32(bitPattern: p[int: 0])
        let type = p[4]
        let clientNum = Int32(p[5])
        let len = UInt16(truncatingIfNeeded: p[ushort: 6])
        let payloadLen: Int32 = (type == 1) ? Int32(Usercmd.byteCount) : (type == 2) ? Int32(len) : 0

        if frame > UInt32(bitPattern: ref_frameIndex) {
            break
        }
        if ref_rpCursor + 8 + payloadLen > ref_rpLen {
            Com_Printf("REF WARN truncated replay record, stopping replay\n")
            ref_rpCursor = ref_rpLen
            break
        }
        ref_rpCursor += 8 + payloadLen

        switch type {
        case 1:
            if ref_fake[clientNum] && svs.clientsSlots[clientNum].state == CS_ACTIVE {
                // The fork's record lives to the end of his block, so the block is the closure.
                Usercmd.scratch { cmd in
                    Com_Memcpy(Slots(record: cmd).bytes, p.suffix(from: 8), Usercmd.byteCount)
                    ref_inReplayExec = true
                    SV_ClientThink(svs.clientsSlots[clientNum], cmd)
                    ref_inReplayExec = false
                }
            }

        case 2:
            var userinfo = CharBuf(MAX_INFO_STRING)
            let n: Int32 = (Int32(len) < MAX_INFO_STRING - 1) ? Int32(len) : MAX_INFO_STRING - 1
            Com_Memcpy(&userinfo, p.suffix(from: 8), n)
            userinfo[n] = 0
            Ref_SpawnFake(clientNum, String(userinfo))

        case 3:
            Ref_DropFake(clientNum)

        default:
            Com_Printf("REF WARN unknown replay record type %d, stopping replay\n", type)
            ref_rpCursor = ref_rpLen
        }
    }

    if ref_rpCursor >= ref_rpLen {
        // recording exhausted: disconnect any remaining fake clients
        i = 0
        while i < sv_maxclients!.integer {
            Ref_DropFake(i)
            i += 1
        }
        ref_rpActive = false
        Com_Printf("REF REPLAY END\n")
    }

    // keep fake clients from ever timing out
    i = 0
    while i < sv_maxclients!.integer {
        if ref_fake[i] {
            svs.clientsSlots[i].lastPacketTime = svs.time
        }
        i += 1
    }
}

/*
================================================================================
Frame gate / per-frame hooks
================================================================================
*/

// Called at the top of SV_Frame. Returns qfalse when the sim must not advance.
// When a step is granted, substitutes a forced fixed msec (n * 1000/sv_fps),
// decoupling the sim from the wall clock.
/// Source: openjk/codemp/server/sv_referee.cpp:430
func SVRef_FrameGate(_ msec: inout Int32) -> Bool {
    let fixed: Int32

    if sv_stepper == nil || sv_stepper!.integer == 0 {
        return true
    }

    if ref_pendingSteps <= 0 {
        return false
    }

    fixed = 1000 / (sv_fps!.integer > 0 ? sv_fps!.integer : 20)
    msec = fixed * ref_pendingSteps
    ref_pendingSteps = 0
    sv.timeResidual = 0  // exact chunking: the sim loop runs exactly n fixed frames
    return true
}

// inside the sim loop, immediately before GVM_RunFrame
/// Source: openjk/codemp/server/sv_referee.cpp:447
func SVRef_PreGameFrame() {
    if Ref_TraceActive() {
        ref_traceCount = 0
        ref_traceOverflow = false
    }
    Ref_ReplayAdvance()
}

// inside the sim loop, immediately after GVM_RunFrame
/// Source: openjk/codemp/server/sv_referee.cpp:456
func SVRef_PostGameFrame() {
    ref_frameIndex += 1
    if sv_stepper != nil && sv_stepper!.integer != 0 {
        // AI: The fork prints `sv.time`, which Raven does not have. The line prints `svs.time`, the time Raven passes to GAME_RUN_FRAME.
        Com_Printf("REF STEP n=%d t=%d ck=%08x\n", ref_frameIndex, svs.time, Ref_Checksum())
    }
}

/*
================================================================================
Console commands
================================================================================
*/

/// Source: openjk/codemp/server/sv_referee.cpp:468
private func SVRef_Step_f() {
    var n: Int32 = (Cmd_Argc() > 1) ? atoi(Cmd_Argv(1)) : 1
    if n < 1 {
        n = 1
    }
    if sv_stepper == nil || sv_stepper!.integer == 0 {
        Com_Printf("REF WARN ref_step while sv_stepper is 0\n")
    }
    ref_pendingSteps += n
}

/// Source: openjk/codemp/server/sv_referee.cpp:477
private func Ref_PrintHex(_ data: Slots<byte>, _ len: Int32) {
    // The fork assigns his own `data` and `len` parameters. A Swift parameter is immutable, so the body takes a mutable copy of each.
    var data = data
    var len = len
    let hexdig = CharBuf("0123456789abcdef")
    var buf = CharBuf(2048 + 1)
    var i: Int32
    var n: Int32

    while len > 0 {
        n = (len > 1024) ? 1024 : len
        i = 0
        while i < n {
            buf[i * 2] = hexdig[data[i] >> 4] as Int8
            buf[i * 2 + 1] = hexdig[data[i] & 0xf] as Int8
            i += 1
        }
        buf[n * 2] = 0 as Int8
        Com_Printf("%s", buf)
        data = data.suffix(from: n)
        len -= n
    }
}

/// Source: openjk/codemp/server/sv_referee.cpp:495
private func SVRef_Dump_f() {
    var i: Int32

    Com_Printf("REF DUMP BEGIN n=%d\n", ref_frameIndex)
    if sv.gentities != nil {
        i = 0
        while i < sv.num_entities {
            let ent = SV_GentityNum(i)!
            if !ent.r.linked && Ref_AllZero(Slots(record: ent.s).bytes, Int32(EntityState.byteCount)) {
                i += 1
                continue
            }
            Com_Printf("REF E %d ", i)
            Ref_PrintHex(Slots(record: ent.s).bytes, Int32(EntityState.byteCount))
            Ref_PrintHex(Slots(record: ent.r).bytes, Int32(EntityShared.byteCount))
            Com_Printf("\n")
            i += 1
        }
    }
    if svs.clients != nil && sv.gameClients != nil {
        i = 0
        while i < sv_maxclients!.integer {
            if svs.clientsSlots[i].state < CS_CONNECTED {
                i += 1
                continue
            }
            Com_Printf("REF P %d ", i)
            Ref_PrintHex(Slots(record: SV_GameClientNum(i)!).bytes, Int32(PlayerState.byteCount))
            Com_Printf("\n")
            i += 1
        }
    }
    Com_Printf("REF DUMP END\n")
}

/// Source: openjk/codemp/server/sv_referee.cpp:522
private func SVRef_Trace_f() {
    var i: Int32

    i = 0
    while i < ref_traceCount {
        let e = ref_traceBuf![i]
        if e.dir == 0 {
            Com_Printf("REF T %d IN %d %lld %lld %lld %lld\n", i, e.cmd, e.args[0], e.args[1], e.args[2], e.args[3])
        } else {
            Com_Printf(
                "REF T %d OUT %d %lld %lld %lld %lld %lld %lld %lld %lld ret=%lld\n",
                i,
                e.cmd,
                e.args[0],
                e.args[1],
                e.args[2],
                e.args[3],
                e.args[4],
                e.args[5],
                e.args[6],
                e.args[7],
                e.ret
            )
        }
        i += 1
    }
    if ref_traceOverflow {
        Com_Printf("REF T OVERFLOW\n")
    }
    Com_Printf("REF TRACE END\n")
}

/*
================================================================================
Lifecycle
================================================================================
*/

// AI: The fork binds the game through the legacy ABI when this is true. Raven binds only through dllEntry and vmMain, so only the REF READY test reads it.
/// Source: openjk/codemp/server/sv_referee.cpp:548
func SVRef_ForceLegacy() -> Bool {
    if sv_refTrace == nil {
        return false  // not initialised yet
    }
    return sv_refTrace!.integer != 0 || sv_stepper!.integer != 0 || !sv_recordInputs!.string!.isEmpty || !sv_replayInputs!.string!.isEmpty
}

/// Source: openjk/codemp/server/sv_referee.cpp:555
func SVRef_GameSeed(_ normalSeed: Int32) -> Int32 {
    var seed = normalSeed

    if sv_replayInputs != nil && !sv_replayInputs!.string!.isEmpty {
        Ref_ReplayLoad()
        if ref_rpLoaded && ref_rpSeed != 0 {
            seed = ref_rpSeed
        }
    }
    if sv_refSeed != nil && sv_refSeed!.integer != 0 {
        seed = sv_refSeed!.integer
    }

    ref_lastSeed = seed
    return seed
}

/// Source: openjk/codemp/server/sv_referee.cpp:570
func SVRef_MapSpawned(_ mapname: String) {
    if sv_refTrace == nil {
        return  // SVRef_Init never ran
    }

    ref_frameIndex = 0
    ref_pendingSteps = 0
    ref_fake.fill(false)

    // recorder
    Ref_RecordStop()
    ref_recSeen.fill(false)
    if !sv_recordInputs!.string!.isEmpty && !sv_replayInputs!.string!.isEmpty {
        // recording while replaying would double-drive: replayed cmds would be
        // re-recorded. We never run both at once, so hard-disable the recorder.
        Com_Printf("REF WARN sv_recordInputs ignored because sv_replayInputs is set\n")
    } else if !sv_recordInputs!.string!.isEmpty {
        ref_recFile = FS_FOpenFileWrite(sv_recordInputs!.string!)
        if ref_recFile == 0 {
            Com_Printf("REF WARN cannot open record file '%s'\n", sv_recordInputs!.string!)
        } else {
            let hdr = va("REFREC v1 map=%s seed=%d fps=%d\n", mapname, ref_lastSeed, sv_fps!.integer)
            FS_Write(CharBuf(hdr), strlen(hdr), ref_recFile)
            Com_Printf("REF RECORD BEGIN file=%s seed=%d\n", sv_recordInputs!.string!, ref_lastSeed)
        }
    }

    // replayer
    if !sv_replayInputs!.string!.isEmpty {
        Ref_ReplayLoad()  // normally already loaded by SVRef_GameSeed
        if ref_rpLoaded {
            ref_rpCursor = ref_rpBodyOfs
            ref_rpActive = true
        }
    }

    if SVRef_ForceLegacy() {
        Com_Printf(
            "REF READY map=%s seed=%d fps=%d es=%d er=%d ps=%d cmd=%d\n",
            mapname,
            ref_lastSeed,
            sv_fps!.integer,
            Int32(EntityState.byteCount),
            Int32(EntityShared.byteCount),
            Int32(PlayerState.byteCount),
            Int32(Usercmd.byteCount)
        )
    }
}

/// Source: openjk/codemp/server/sv_referee.cpp:613
func SVRef_ServerShutdown() {
    Ref_RecordStop()
    Ref_ReplayFree()
    ref_fake.fill(false)
    ref_pendingSteps = 0
}

/// Source: openjk/codemp/server/sv_referee.cpp:620
func SVRef_Init() {
    // AI: The fork passes a help string to Cvar_Get and Cmd_AddCommand. Raven's functions take none, so the strings drop.
    sv_stepper = Cvar_Get("sv_stepper", "0", 0)
    sv_recordInputs = Cvar_Get("sv_recordInputs", "", 0)
    sv_replayInputs = Cvar_Get("sv_replayInputs", "", 0)
    sv_refSeed = Cvar_Get("sv_refSeed", "0", 0)
    sv_refTrace = Cvar_Get("sv_refTrace", "0", 0)

    Cmd_AddCommand("ref_step", SVRef_Step_f)
    Cmd_AddCommand("ref_dump", SVRef_Dump_f)
    Cmd_AddCommand("ref_trace", SVRef_Trace_f)
}
