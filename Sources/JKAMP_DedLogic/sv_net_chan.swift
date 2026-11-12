import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/**
```
==============
SV_Netchan_Encode

	// first four bytes of the data are always:
	long reliableAcknowledge;

==============
```
*/
/// Source: oracle/codemp/server/sv_net_chan.cpp:17
private func SV_Netchan_Encode(_ client: Client, _ msg: Msg) {
    let reliableAcknowledge: CLong
    var i: CLong
    var index: CLong
    var key: byte
    let string: CharBuf
    let srdc: Int32
    let sbit: Int32
    let soob: Int32

    if msg.cursize < SV_ENCODE_START {
        return
    }

    srdc = msg.readcount
    sbit = msg.bit
    soob = (msg.oob ? 1 : 0)

    msg.bit = 0
    msg.readcount = 0
    msg.oob = false

    reliableAcknowledge = CLong(MSG_ReadLong(msg))

    msg.oob = soob != 0
    msg.bit = sbit
    msg.readcount = srdc

    string = client.lastClientCommandStringBuffer
    index = 0
    // xor the client challenge with the netchan sequence number
    key = UInt8(truncatingIfNeeded: client.challenge ^ client.netchan.outgoingSequence)
    i = CLong(SV_ENCODE_START)
    while i < msg.cursize {
        // modify the key with the last received and with this message acknowledged client command
        if string[index] as UInt8 == 0 {
            index = 0
        }
        if /*string[index] > 127 ||*/ // eurofix: remove this so we can chat in european languages...	-ste
            string[index] as UInt8 == UInt8(ascii: "%") {
            key ^= UInt8(truncatingIfNeeded: Int32(ascii: ".") << (i & 1))
        } else {
            key ^= UInt8(truncatingIfNeeded: Int32(string[index] as UInt8) << (i & 1))
        }
        index += 1
        // encode the data with this key
        msg.data![i] = msg.data![i] ^ key
        i += 1
    }
}

/**
```
==============
SV_Netchan_Decode

	// first 12 bytes of the data are always:
	long serverId;
	long messageAcknowledge;
	long reliableAcknowledge;

==============
```
*/
/// Source: oracle/codemp/server/sv_net_chan.cpp:76
private func SV_Netchan_Decode(_ client: Client, _ msg: Msg) {
    let serverId: Int32
    let messageAcknowledge: Int32
    let reliableAcknowledge: Int32
    var i: Int32
    var index: Int32
    let srdc: Int32
    let sbit: Int32
    let soob: Int32
    var key: byte
    let string: CharBuf

    srdc = msg.readcount
    sbit = msg.bit
    soob = (msg.oob ? 1 : 0)

    msg.oob = false

    serverId = MSG_ReadLong(msg)
    messageAcknowledge = MSG_ReadLong(msg)
    reliableAcknowledge = MSG_ReadLong(msg)

    msg.oob = soob != 0
    msg.bit = sbit
    msg.readcount = srdc

    // AI: Raven points `string` into one slot of `reliableCommands`. The buffer copies all the bytes of the slot, because the loop reads past the first zero.
    string = charBuf(at: client.reliableCommands.slot(at: reliableAcknowledge & (MAX_RELIABLE_COMMANDS - 1)).base, capacity: Int(MAX_STRING_CHARS))
    index = 0
    //
    key = UInt8(truncatingIfNeeded: client.challenge ^ serverId ^ messageAcknowledge)
    i = msg.readcount + SV_DECODE_START
    while i < msg.cursize {
        // modify the key with the last sent and acknowledged server command
        if string[index] as UInt8 == 0 {
            index = 0
        }
        if /*string[index] > 127 || */ // eurofix: remove this so we can chat in european languages...	-ste
            string[index] as UInt8 == UInt8(ascii: "%") {
            key ^= UInt8(truncatingIfNeeded: Int32(ascii: ".") << (i & 1))
        } else {
            key ^= UInt8(truncatingIfNeeded: Int32(string[index] as UInt8) << (i & 1))
        }
        index += 1
        // decode the data with this key
        msg.data![i] = msg.data![i] ^ key
        i += 1
    }
}

/**
```
=================
SV_Netchan_TransmitNextFragment
=================
```
*/
/// Source: oracle/codemp/server/sv_net_chan.cpp:126
public func SV_Netchan_TransmitNextFragment(_ chan: Netchan) {
    Netchan_TransmitNextFragment(chan)
}

//extern byte chksum[65536];
/// Source: oracle/codemp/server/sv_net_chan.cpp:138
public func SV_Netchan_Transmit(_ client: Client, _ msg: Msg) {
    //int length, const byte *data ) {
    //	int i;
    MSG_WriteByte(msg, svc_EOF)
    //	for(i=SV_ENCODE_START;i<msg->cursize;i++) {
    //		chksum[i-SV_ENCODE_START] = msg->data[i];
    //	}
    //	Huff_Compress( msg, SV_ENCODE_START );
    SV_Netchan_Encode(client, msg)
    Netchan_Transmit(client.netchan, msg.cursize, msg.data!)
}

/**
```
=================
Netchan_SV_Process
=================
```
*/
/// Source: oracle/codemp/server/sv_net_chan.cpp:154
public func SV_Netchan_Process(_ client: Client, _ msg: Msg) -> Bool {
    let ret: Int32
    //	int i;
    ret = (Netchan_Process(client.netchan, msg) ? 1 : 0)
    if ret == 0 {
        return false
    }
    SV_Netchan_Decode(client, msg)
    //	Huff_Decompress( msg, SV_DECODE_START );
    //	for(i=SV_DECODE_START+msg->readcount;i<msg->cursize;i++) {
    //		if (msg->data[i] != chksum[i-(SV_DECODE_START+msg->readcount)]) {
    //			Com_Error(ERR_DROP,"bad\n");
    //		}
    //	}
    return true
}
