import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/net_chan.cpp:33
let MAX_PACKETLEN = 1400 as Int32

/// Source: oracle/codemp/qcommon/net_chan.cpp:34
let FRAGMENT_SIZE = (MAX_PACKETLEN - 100)

/// Source: oracle/codemp/qcommon/net_chan.cpp:35
let PACKET_HEADER = 10 as Int32

/// Source: oracle/codemp/qcommon/net_chan.cpp:38
let FRAGMENT_BIT = (1 << 31) as Int32

/// Source: oracle/codemp/qcommon/net_chan.cpp:40
var showpackets: JKAMP.Cvar? {
    get { world.variables.showpackets }
    set { world.variables.showpackets = newValue }
}

/// Source: oracle/codemp/qcommon/net_chan.cpp:41
var showdrop: JKAMP.Cvar? {
    get { world.variables.showdrop }
    set { world.variables.showdrop = newValue }
}

/// Source: oracle/codemp/qcommon/net_chan.cpp:42
var qport: JKAMP.Cvar? {
    get { world.variables.qport }
    set { world.variables.qport = newValue }
}

/// Source: oracle/codemp/qcommon/net_chan.cpp:43
var net_killdroppedfragments: JKAMP.Cvar? {
    get { world.variables.net_killdroppedfragments }
    set { world.variables.net_killdroppedfragments = newValue }
}

/// Source: oracle/codemp/qcommon/net_chan.cpp:45
/// Raven's data table, a hand property of `EngineWorld`.
var netsrcString: [String] {
    get { world.netsrcString }
    set { world.netsrcString = newValue }
}

/// Source: oracle/codemp/qcommon/net_chan.cpp:474
let MAX_LOOPBACK = 16 as Int32

/// Source: oracle/codemp/qcommon/net_chan.cpp:486
// TODO: Port global loopbacks
// Raven wrote: loopback_t loopbacks[2]
// No view for `loopback_t`, a struct Raven defines inside a .c file.

/**
```
===============
Netchan_Init

===============
```
*/
/// Source: oracle/codemp/qcommon/net_chan.cpp:56
func Netchan_Init(_ port: Int32) {
    port &= 0xffff
    showpackets = Cvar_Get("showpackets", "0", CVAR_TEMP)
    showdrop = Cvar_Get("showdrop", "0", CVAR_TEMP)
    qport = Cvar_Get("net_qport", va("%i", port), CVAR_INIT)
    net_killdroppedfragments = Cvar_Get("net_killdroppedfragments", "0", CVAR_TEMP)
}

/**
```
==============
Netchan_Setup

called to open a channel to a remote system
==============
```
*/
/// Source: oracle/codemp/qcommon/net_chan.cpp:71
// TODO: Port signature
// Raven wrote: void Netchan_Setup( netsrc_t sock, netchan_t *chan, netadr_t adr, int qport )
// No table row for `netadr_t adr`.
func Netchan_Setup() -> Never {
    chan.clear()
    chan.sock = sock
    chan.remoteAddress = adr
    chan.qport = qport
    chan.incomingSequence = 0
    chan.outgoingSequence = 1
}

/**
```
=================
Netchan_TransmitNextFragment

Send one fragment of the current message
=================
```
*/
/// Source: oracle/codemp/qcommon/net_chan.cpp:88
func Netchan_TransmitNextFragment(_ chan: Netchan) {
    let send_buf = UnsafeMutableRawPointer.allocate(byteCount: Int(MAX_PACKETLEN), alignment: 8)
    defer { send_buf.deallocate() }
    var fragmentLength: Int32 = 0

    Msg.scratch { send in
        // write the packet header
        MSG_InitOOB(send, OpaquePointer(send_buf), MAX_PACKETLEN)                // <-- only do the oob here

        MSG_WriteLong(send, chan.outgoingSequence | FRAGMENT_BIT)

        // send the qport if we are a client
        if chan.sock == NS_CLIENT {
            MSG_WriteShort(send, qport!.integer)
        }

        // copy the reliable message to the packet first
        fragmentLength = FRAGMENT_SIZE
        if chan.unsentFragmentStart + fragmentLength > chan.unsentLength {
            fragmentLength = chan.unsentLength - chan.unsentFragmentStart
        }

        MSG_WriteShort(send, chan.unsentFragmentStart)
        MSG_WriteShort(send, fragmentLength)
        // AI: Raven added the start to the buffer pointer. The Swift buffer is a Slots, so the sum is taken on its base address.
        MSG_WriteData(send, OpaquePointer(chan.unsentBuffer.base + chan.unsentFragmentStart), fragmentLength)

        // send the datagram
        NET_SendPacket(chan.sock, send.cursize, send.data, chan.remoteAddress)

        if showpackets!.integer != 0 {
            Com_Printf("%s send %4i : s=%i fragment=%i,%i\n"
                , netsrcString[chan.sock]
                , send.cursize
                , chan.outgoingSequence - 1
                , chan.unsentFragmentStart, fragmentLength)
        }
    }

    chan.unsentFragmentStart += fragmentLength

    // this exit condition is a little tricky, because a packet
    // that is exactly the fragment length still needs to send
    // a second packet of zero length so that the other side
    // can tell there aren't more to follow
    if chan.unsentFragmentStart == chan.unsentLength && fragmentLength != FRAGMENT_SIZE {
        chan.outgoingSequence += 1
        chan.unsentFragments = false
    }
}

/**
```
===============
Netchan_Transmit

Sends a message to a connection, fragmenting if necessary
A 0 length will still generate a packet.
================
```
*/
/// Source: oracle/codemp/qcommon/net_chan.cpp:145
// TODO: Port signature
// Raven wrote: void Netchan_Transmit( netchan_t *chan, int length, const byte *data )
// No table row for `const byte * data`.
func Netchan_Transmit() -> Never {
    let send_buf = UnsafeMutableRawPointer.allocate(byteCount: Int(MAX_PACKETLEN), alignment: 8)
    defer { send_buf.deallocate() }

    if length > MAX_MSGLEN {
        Com_Error(ERR_DROP, "Netchan_Transmit: length = %i", length)
    }
    chan.unsentFragmentStart = 0
    if chan.unsentFragments {
        Com_Printf("[ISM] Stomping Unsent Fragments %s\n", netsrcString[chan.sock])
    }

    // fragment large reliable messages
    if length >= FRAGMENT_SIZE {
        chan.unsentFragments = true
        chan.unsentLength = length
        Com_Memcpy(OpaquePointer(chan.unsentBuffer.base), data, CUnsignedLong(length))

        // only send the first fragment now
        Netchan_TransmitNextFragment(chan)

        return
    }

    Msg.scratch { send in
        // write the packet header
        MSG_InitOOB(send, OpaquePointer(send_buf), MAX_PACKETLEN)

        MSG_WriteLong(send, chan.outgoingSequence)
        chan.outgoingSequence += 1

        // send the qport if we are a client
        if chan.sock == NS_CLIENT {
            MSG_WriteShort(send, qport!.integer)
        }

        MSG_WriteData(send, data, length)

        // send the datagram
        NET_SendPacket(chan.sock, send.cursize, send.data, chan.remoteAddress)

        if showpackets!.integer != 0 {
            Com_Printf("%s send %4i : s=%i ack=%i\n"
                , netsrcString[chan.sock]
                , send.cursize
                , chan.outgoingSequence - 1
                , chan.incomingSequence)
        }
    }
}

/**
```
=================
Netchan_Process

Returns qfalse if the message should not be processed due to being
out of order or a fragment.

Msg must be large enough to hold MAX_MSGLEN, because if this is the
final fragment of a multi-part message, the entire thing will be
copied out.
=================
```
*/
/// Source: oracle/codemp/qcommon/net_chan.cpp:208
func Netchan_Process(_ chan: Netchan, _ msg: Msg) -> Bool {
    var sequence: Int32
    var qport: Int32
    var fragmentStart: Int32
    var fragmentLength: Int32 = 0
    let fragmented: Bool

    // get sequence numbers
    MSG_BeginReadingOOB(msg)
    sequence = MSG_ReadLong(msg)

    // check for fragment information
    if (sequence & FRAGMENT_BIT) != 0 {
        sequence &= ~FRAGMENT_BIT
        fragmented = true
    } else {
        fragmented = false
    }

    // read the qport if we are a server
    if chan.sock == NS_SERVER {
        qport = MSG_ReadShort(msg)
    }

    // read the fragment information
    if fragmented {
        fragmentStart = MSG_ReadShort(msg) & 0xffff
        fragmentLength = MSG_ReadShort(msg) & 0xffff
    } else {
        fragmentStart = 0        // stop warning message
        fragmentLength = 0
    }

    if showpackets!.integer != 0 {
        if fragmented {
            Com_Printf("%s recv %4i : s=%i fragment=%i,%i\n"
                , netsrcString[chan.sock]
                , msg.cursize
                , sequence
                , fragmentStart, fragmentLength)
        } else {
            Com_Printf("%s recv %4i : s=%i\n"
                , netsrcString[chan.sock]
                , msg.cursize
                , sequence)
        }
    }

    //
    // discard out of order or duplicated packets
    //
    if sequence <= chan.incomingSequence {
        if showdrop!.integer != 0 || showpackets!.integer != 0 {
            Com_Printf("%s:Out of order packet %i at %i\n"
                , NET_AdrToString(chan.remoteAddress)
                ,  sequence
                , chan.incomingSequence)
        }
        return false
    }

    //
    // dropped packets don't keep the message from being used
    //
    chan.dropped = sequence - (chan.incomingSequence + 1)
    if chan.dropped > 0 {
        if showdrop!.integer != 0 || showpackets!.integer != 0 {
            Com_Printf("%s:Dropped %i packets at %i\n"
            , NET_AdrToString(chan.remoteAddress)
            , chan.dropped
            , sequence)
        }
    }

    //
    // if this is the final framgent of a reliable message,
    // bump incoming_reliable_sequence
    //
    if fragmented {
        // make sure we
        if sequence != chan.fragmentSequence {
            chan.fragmentSequence = sequence
            chan.fragmentLength = 0
        }

        // if we missed a fragment, dump the message
        if fragmentStart != chan.fragmentLength {
            if showdrop!.integer != 0 || showpackets!.integer != 0 {
                Com_Printf("%s:Dropped a message fragment\n"
                , NET_AdrToString(chan.remoteAddress)
                , sequence)
            }
            // we can still keep the part that we have so far,
            // so we don't need to clear chan->fragmentLength

            //rww - not clearing this will allow us to piece together fragments belonging to other packets
            //that happen to have the same sequence (or so it seems). I am just going to clear it and force
            //the packet to be dropped.
            // hell yeah we have to dump the whole thing -gil
            // but I am scared - mw
            /*
            chan->fragmentLength = 0;
            chan->incomingSequence = sequence;
            chan->fragmentSequence = 0;
            */
            return false
        }

        // copy the fragment to the fragment buffer
        if fragmentLength < 0 || msg.readcount + fragmentLength > msg.cursize ||
            chan.fragmentLength + fragmentLength > Int32(chan.fragmentBuffer.count) {
            if showdrop!.integer != 0 || showpackets!.integer != 0 {
                Com_Printf("%s:illegal fragment length\n"
                , NET_AdrToString(chan.remoteAddress))
            }
            return false
        }

        // AI: Raven added the offsets to the buffer pointers. The Swift buffers are raw, so the sums are taken on the base addresses.
        Com_Memcpy(OpaquePointer(chan.fragmentBuffer.base + chan.fragmentLength),
            OpaquePointer(UnsafeMutableRawPointer(msg.data!) + msg.readcount), CUnsignedLong(fragmentLength))

        chan.fragmentLength += fragmentLength

        // if this wasn't the last fragment, don't process anything
        if fragmentLength == FRAGMENT_SIZE {
            return false
        }

        if chan.fragmentLength + 4 > msg.maxsize {
            Com_Printf("%s:fragmentLength %i > msg->maxsize\n"
                , NET_AdrToString(chan.remoteAddress),
                chan.fragmentLength + 4)
            return false
        }

        // copy the full message over the partial fragment

        // make sure the sequence number is still there
        UnsafeMutableRawPointer(msg.data!).storeBytes(of: LittleLong(sequence), as: Int32.self)
        Com_Memcpy(OpaquePointer(UnsafeMutableRawPointer(msg.data!) + 4), OpaquePointer(chan.fragmentBuffer.base), CUnsignedLong(chan.fragmentLength))
        msg.cursize = chan.fragmentLength + 4
        chan.fragmentLength = 0
        msg.readcount = 4    // past the sequence number
        msg.bit = 32    // past the sequence number

        // but I am a wuss -mw
        // chan->incomingSequence = sequence;    // lets not accept any more with this sequence number -gil
        return true
    }

    //
    // the message can now be read from the current message pointer
    //
    chan.incomingSequence = sequence

    return true
}

/**
```
===================
NET_CompareBaseAdr

Compares without the port
===================
```
*/
/// Source: oracle/codemp/qcommon/net_chan.cpp:378
// TODO: Port signature
// Raven wrote: qboolean NET_CompareBaseAdr (netadr_t a, netadr_t b)
// No table row for `netadr_t a`.
func NET_CompareBaseAdr() -> Never {
    if a.type != b.type {
        return false
    }

    if a.type == NA_LOOPBACK {
        return true
    }

    if a.type == NA_IP {
        if a.ip[0] == b.ip[0] && a.ip[1] == b.ip[1] && a.ip[2] == b.ip[2] && a.ip[3] == b.ip[3] {
            return true
        }
        return false
    }

    if a.type == NA_IPX {
        if (memcmp(a.ipx, b.ipx, 10) == 0) {
            return true
        }
        return false
    }

    Com_Printf("NET_CompareBaseAdr: bad address type\n")
    return false
}

/// Source: oracle/codemp/qcommon/net_chan.cpp:406
// TODO: Port signature
// Raven wrote: const char *NET_AdrToString (netadr_t a)
// No table row for `netadr_t a`.
func NET_AdrToString() -> Never {
    var s = CharBuf(64)

    if a.type == NA_LOOPBACK {
        Com_sprintf(&s, Int32(s.count), "loopback")
    } else if a.type == NA_BOT {
        Com_sprintf(&s, Int32(s.count), "bot")
    } else if a.type == NA_IP {
        Com_sprintf(&s, Int32(s.count), "%i.%i.%i.%i:%i",
            a.ip[0], a.ip[1], a.ip[2], a.ip[3], BigShort(a.port))
    } else if a.type == NA_BAD {
        Com_sprintf(&s, Int32(s.count), "BAD")
    } else {
        Com_sprintf(&s, Int32(s.count), "%02x%02x%02x%02x.%02x%02x%02x%02x%02x%02x:%i",
        a.ipx[0], a.ipx[1], a.ipx[2], a.ipx[3], a.ipx[4], a.ipx[5], a.ipx[6], a.ipx[7], a.ipx[8], a.ipx[9],
        BigShort(a.port))
    }

    return String(s)
}

/// Source: oracle/codemp/qcommon/net_chan.cpp:429
// TODO: Port signature
// Raven wrote: qboolean NET_CompareAdr (netadr_t a, netadr_t b)
// No table row for `netadr_t a`.
func NET_CompareAdr() -> Never {
    if a.type != b.type {
        return false
    }

    if a.type == NA_LOOPBACK {
        return true
    }

    if a.type == NA_IP {
        if a.ip[0] == b.ip[0] && a.ip[1] == b.ip[1] && a.ip[2] == b.ip[2] && a.ip[3] == b.ip[3] && a.port == b.port {
            return true
        }
        return false
    }

    if a.type == NA_IPX {
        if (memcmp(a.ipx, b.ipx, 10) == 0) && a.port == b.port {
            return true
        }
        return false
    }

    Com_Printf("NET_CompareAdr: bad address type\n")
    return false
}

/// Source: oracle/codemp/qcommon/net_chan.cpp:458
// TODO: Port signature
// Raven wrote: qboolean NET_IsLocalAddress( netadr_t adr )
// No table row for `netadr_t adr`.
func NET_IsLocalAddress() -> Never {
    return (adr.type == NA_LOOPBACK)
}

/// Source: oracle/codemp/qcommon/net_chan.cpp:489
func NET_GetLoopPacket(_ sock: netsrc_t, _ net_from: Netadr, _ net_message: Msg) -> Bool {
    // Port-note: Raven's `loopback_t loopbacks[2]` has no Swift home, because the struct is defined inside net_chan.cpp and has no view.
    // TODO: Port NET_GetLoopPacket
    portMissing("NET_GetLoopPacket", source: "oracle/codemp/qcommon/net_chan.cpp:489")
}

/// Source: oracle/codemp/qcommon/net_chan.cpp:514
// TODO: Port signature
// Raven wrote: void NET_SendLoopPacket (netsrc_t sock, int length, const void *data, netadr_t to)
// No table row for `netadr_t to`.
func NET_SendLoopPacket() -> Never {
    // Port-note: Raven's `loopback_t loopbacks[2]` has no Swift home, because the struct is defined inside net_chan.cpp and has no view.
    // TODO: Port NET_SendLoopPacket
    portMissing("NET_SendLoopPacket", source: "oracle/codemp/qcommon/net_chan.cpp:514")
}

/// Source: oracle/codemp/qcommon/net_chan.cpp:531
// TODO: Port signature
// Raven wrote: void NET_SendPacket( netsrc_t sock, int length, const void *data, netadr_t to )
// No table row for `netadr_t to`.
func NET_SendPacket() -> Never {
    // sequenced packets are shown in netchan, so just show oob
    if showpackets!.integer != 0 && UnsafeMutableRawPointer(data!).load(as: Int32.self) == -1 {
        Com_Printf("send packet %4i\n", length)
    }

    if to.type == NA_LOOPBACK {
        NET_SendLoopPacket(sock, length, data, to)
        return
    }
    if to.type == NA_BOT {
        return
    }
    if to.type == NA_BAD {
        return
    }

    Sys_SendPacket(length, data, to)
}

/**
```
===============
NET_OutOfBandPrint

Sends a text message in an out-of-band datagram
================
```
*/
/// Source: oracle/codemp/qcommon/net_chan.cpp:559
// TODO: Port signature
// Raven wrote: void QDECL NET_OutOfBandPrint( netsrc_t sock, netadr_t adr, const char *format, ... )
// No table row for `netadr_t adr`.
func NET_OutOfBandPrint() -> Never {
    var string = CharBuf(MAX_MSGLEN)

    // set the header
    string[0] = -1
    string[1] = -1
    string[2] = -1
    string[3] = -1

    // AI: Raven called vsprintf into string+4 with the argument list. The Swift form formats the text first and copies it to offset 4.
    // The module name breaks the clash between the `format` parameter and the `format` function.
    Q_strncpyz(&string, JKAShared.format(format, args), MAX_MSGLEN, at: 4)

    // send the datagram
    let length = strlen(string)
    string.withUnsafeMutableRawPointer { NET_SendPacket(sock, length, OpaquePointer($0), adr) }
}

/**
```
===============
NET_OutOfBandPrint

Sends a data message in an out-of-band datagram (only used for "connect")
================
```
*/
/// Source: oracle/codemp/qcommon/net_chan.cpp:585
// TODO: Port signature
// Raven wrote: void QDECL NET_OutOfBandData( netsrc_t sock, netadr_t adr, byte *format, int len )
// No table row for `netadr_t adr`.
func NET_OutOfBandData() -> Never {
    let string = UnsafeMutableRawPointer.allocate(byteCount: Int(MAX_MSGLEN * 2), alignment: 8)
    defer { string.deallocate() }

    // set the header
    string.storeBytes(of: 0xff, toByteOffset: 0, as: byte.self)
    string.storeBytes(of: 0xff, toByteOffset: 1, as: byte.self)
    string.storeBytes(of: 0xff, toByteOffset: 2, as: byte.self)
    string.storeBytes(of: 0xff, toByteOffset: 3, as: byte.self)

    var i: Int32 = 0
    while i < len {
        string.storeBytes(of: UnsafeMutableRawPointer(format!).load(fromByteOffset: Int(i), as: byte.self), toByteOffset: Int(i + 4), as: byte.self)
        i += 1
    }

    Msg.scratch { mbuf in
        mbuf.data = OpaquePointer(string)
        mbuf.cursize = len + 4
        Huff_Compress(mbuf, 12)
        // send the datagram
        NET_SendPacket(sock, mbuf.cursize, mbuf.data, adr)
    }
}

/**
```
=============
NET_StringToAdr

Traps "localhost" for loopback, passes everything else to system
=============
```
*/
/// Source: oracle/codemp/qcommon/net_chan.cpp:617
func NET_StringToAdr(_ s: String, _ a: Netadr) -> Bool {
    let r: Bool
    var base = CharBuf(MAX_STRING_CHARS)
    var port: Int32?

    if strcmp(s, "localhost") == 0 {
        a.clear()
        a.type = NA_LOOPBACK
        return true
    }

    // look for a port number
    Q_strncpyz(&base, s, Int32(base.count))

    port = strstr(base, ":")
    if port != nil {
        base[port!] = 0
        port! += 1
    }

    r = Sys_StringToAdr(String(base), a)

    if !r {
        a.type = NA_BAD
        return false
    }

    // inet_addr returns this if out of range
    if a.ip[0] == 255 && a.ip[1] == 255 && a.ip[2] == 255 && a.ip[3] == 255 {
        a.type = NA_BAD
        return false
    }

    if port != nil {
        a.port = BigShort(Int16(truncatingIfNeeded: atoi(base[port!...])))
    } else {
        a.port = BigShort(PORT_SERVER)
    }

    return true
}
