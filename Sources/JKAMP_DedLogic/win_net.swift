import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/win32/win_net.cpp:7
// Raven wrote: static WSADATA winsockdata
let winsockdata: Int32 = 0

/// Source: oracle/codemp/win32/win_net.cpp:8
var winsockInitialized: Bool {
    get { world.variables.winsockInitialized }
    set { world.variables.winsockInitialized = newValue }
}

/// Source: oracle/codemp/win32/win_net.cpp:9
var usingSocks: Bool {
    get { world.variables.usingSocks }
    set { world.variables.usingSocks = newValue }
}

/// Source: oracle/codemp/win32/win_net.cpp:10
var networkingEnabled: Bool {
    get { world.variables.networkingEnabled }
    set { world.variables.networkingEnabled = newValue }
}

/// Source: oracle/codemp/win32/win_net.cpp:12
var net_noudp: JKAMP.Cvar? {
    get { world.variables.net_noudp }
    set { world.variables.net_noudp = newValue }
}

/// Source: oracle/codemp/win32/win_net.cpp:13
var net_noipx: JKAMP.Cvar? {
    get { world.variables.net_noipx }
    set { world.variables.net_noipx = newValue }
}

/// Source: oracle/codemp/win32/win_net.cpp:15
var net_forcenonlocal: JKAMP.Cvar? {
    get { world.variables.net_forcenonlocal }
    set { world.variables.net_forcenonlocal = newValue }
}

/// Source: oracle/codemp/win32/win_net.cpp:17
var net_socksEnabled: JKAMP.Cvar? {
    get { world.variables.net_socksEnabled }
    set { world.variables.net_socksEnabled = newValue }
}

/// Source: oracle/codemp/win32/win_net.cpp:18
var net_socksServer: JKAMP.Cvar? {
    get { world.variables.net_socksServer }
    set { world.variables.net_socksServer = newValue }
}

/// Source: oracle/codemp/win32/win_net.cpp:19
var net_socksPort: JKAMP.Cvar? {
    get { world.variables.net_socksPort }
    set { world.variables.net_socksPort = newValue }
}

/// Source: oracle/codemp/win32/win_net.cpp:20
var net_socksUsername: JKAMP.Cvar? {
    get { world.variables.net_socksUsername }
    set { world.variables.net_socksUsername = newValue }
}

/// Source: oracle/codemp/win32/win_net.cpp:21
var net_socksPassword: JKAMP.Cvar? {
    get { world.variables.net_socksPassword }
    set { world.variables.net_socksPassword = newValue }
}

/// Source: oracle/codemp/win32/win_net.cpp:22
// TODO: Port global socksRelayAddr
// Raven wrote: static struct sockaddr socksRelayAddr
// No view for `sockaddr`, a struct Raven defines inside a .c file.

/// Source: oracle/codemp/win32/win_net.cpp:27
// Raven wrote: static SOCKET ip_socket = INVALID_SOCKET
let ip_socket: Int32 = { () -> Int32 in portMissing("ip_socket", source: "oracle/codemp/win32/win_net.cpp:27") }()

/// Source: oracle/codemp/win32/win_net.cpp:28
// Raven wrote: static SOCKET socks_socket = INVALID_SOCKET
let socks_socket: Int32 = { () -> Int32 in portMissing("socks_socket", source: "oracle/codemp/win32/win_net.cpp:28") }()

/// Source: oracle/codemp/win32/win_net.cpp:29
var ipx_socket: Int32 {
    get { world.variables.ipx_socket }
    set { world.variables.ipx_socket = newValue }
}

/// Source: oracle/codemp/win32/win_net.cpp:31
let MAX_IPS = 16 as Int32

/// Source: oracle/codemp/win32/win_net.cpp:32
var numIP: Int32 {
    get { world.variables.numIP }
    set { world.variables.numIP = newValue }
}

/// Source: oracle/codemp/win32/win_net.cpp:33
var localIP: [[JKAShared.byte]] {
    get { world.variables.localIP }
    set { world.variables.localIP = newValue }
}

/// Source: oracle/codemp/win32/win_net.cpp:248
var recvfromCount: Int32 {
    get { world.variables.recvfromCount }
    set { world.variables.recvfromCount = newValue }
}

/// Source: oracle/codemp/win32/win_net.cpp:386
var socksBuf: JKAShared.CharBuf {
    get { world.variables.socksBuf }
    set { world.variables.socksBuf = newValue }
}

/**
```
====================
NET_ErrorString
====================
```
*/
/// Source: oracle/codemp/win32/win_net.cpp:43
func NET_ErrorString() -> String {
    // TODO: Port NET_ErrorString
    portMissing("NET_ErrorString", source: "oracle/codemp/win32/win_net.cpp:43")
}

/// Source: oracle/codemp/win32/win_net.cpp:97
// TODO: Port signature
// Raven wrote: void NetadrToSockadr( netadr_t *a, struct sockaddr *s )
// No table row for `struct sockaddr * s`.
func NetadrToSockadr() -> Never {
    // TODO: Port NetadrToSockadr
    portMissing("NetadrToSockadr", source: "oracle/codemp/win32/win_net.cpp:97")
}

/// Source: oracle/codemp/win32/win_net.cpp:127
// TODO: Port signature
// Raven wrote: void SockadrToNetadr( struct sockaddr *s, netadr_t *a )
// No table row for `struct sockaddr * s`.
func SockadrToNetadr() -> Never {
    // TODO: Port SockadrToNetadr
    portMissing("SockadrToNetadr", source: "oracle/codemp/win32/win_net.cpp:127")
}

/// Source: oracle/codemp/win32/win_net.cpp:160
// TODO: Port signature
// Raven wrote: qboolean Sys_StringToSockaddr( const char *s, struct sockaddr *sadr )
// No table row for `struct sockaddr * sadr`.
func Sys_StringToSockaddr() -> Never {
    // TODO: Port Sys_StringToSockaddr
    portMissing("Sys_StringToSockaddr", source: "oracle/codemp/win32/win_net.cpp:160")
}

/**
```
=============
Sys_StringToAdr

idnewt
192.246.40.70
=============
```
*/
/// Source: oracle/codemp/win32/win_net.cpp:228
func Sys_StringToAdr(_ s: String, _ a: Netadr) -> Bool {
    // TODO: Port Sys_StringToAdr
    portMissing("Sys_StringToAdr", source: "oracle/codemp/win32/win_net.cpp:228")
}

/// Source: oracle/codemp/win32/win_net.cpp:250
func Sys_GetPacket(_ net_from: Netadr, _ net_message: Msg) -> Bool {
    // TODO: Port Sys_GetPacket
    portMissing("Sys_GetPacket", source: "oracle/codemp/win32/win_net.cpp:250")
}

/**
```
==================
Sys_SendPacket
==================
```
*/
/// Source: oracle/codemp/win32/win_net.cpp:393
func Sys_SendPacket(_ length: Int32, _ data: Slots<JKAShared.byte>, _ to: Netadr) {
    // TODO: Port Sys_SendPacket
    portMissing("Sys_SendPacket", source: "oracle/codemp/win32/win_net.cpp:393")
}

/**
```
==================
Sys_IsLANAddress

LAN clients will have their rate var ignored
==================
```
*/
/// Source: oracle/codemp/win32/win_net.cpp:479
func Sys_IsLANAddress(_ adr: Netadr) -> Bool {
    // TODO: Port Sys_IsLANAddress
    portMissing("Sys_IsLANAddress", source: "oracle/codemp/win32/win_net.cpp:479")
}

/**
```
==================
Sys_ShowIP
==================
```
*/
/// Source: oracle/codemp/win32/win_net.cpp:571
func Sys_ShowIP() {
    // TODO: Port Sys_ShowIP
    portMissing("Sys_ShowIP", source: "oracle/codemp/win32/win_net.cpp:571")
}

/**
```
====================
NET_IPSocket
====================
```
*/
/// Source: oracle/codemp/win32/win_net.cpp:588
func NET_IPSocket(_ net_interface: String, _ port: Int32) -> Int32 {
    // TODO: Port NET_IPSocket
    portMissing("NET_IPSocket", source: "oracle/codemp/win32/win_net.cpp:588")
}

/**
```
====================
NET_OpenSocks
====================
```
*/
/// Source: oracle/codemp/win32/win_net.cpp:653
func NET_OpenSocks(_ port: Int32) {
    // TODO: Port NET_OpenSocks
    portMissing("NET_OpenSocks", source: "oracle/codemp/win32/win_net.cpp:653")
}

/**
```
=====================
NET_GetLocalAddress
=====================
```
*/
/// Source: oracle/codemp/win32/win_net.cpp:838
func NET_GetLocalAddress() {
    // TODO: Port NET_GetLocalAddress
    portMissing("NET_GetLocalAddress", source: "oracle/codemp/win32/win_net.cpp:838")
}

/**
```
====================
NET_OpenIP
====================
```
*/
/// Source: oracle/codemp/win32/win_net.cpp:914
func NET_OpenIP() {
    // TODO: Port NET_OpenIP
    portMissing("NET_OpenIP", source: "oracle/codemp/win32/win_net.cpp:914")
}

/**
```
====================
NET_IPXSocket
====================
```
*/
/// Source: oracle/codemp/win32/win_net.cpp:946
func NET_IPXSocket(_ port: Int32) -> Int32 {
    // TODO: Port NET_IPXSocket
    portMissing("NET_IPXSocket", source: "oracle/codemp/win32/win_net.cpp:946")
}

/**
```
====================
NET_OpenIPX
====================
```
*/
/// Source: oracle/codemp/win32/win_net.cpp:1003
func NET_OpenIPX() {
    // TODO: Port NET_OpenIPX
    portMissing("NET_OpenIPX", source: "oracle/codemp/win32/win_net.cpp:1003")
}

/**
```
====================
NET_GetCvars
====================
```
*/
/// Source: oracle/codemp/win32/win_net.cpp:1020
private func NET_GetCvars() -> Bool {
    // TODO: Port NET_GetCvars
    portMissing("NET_GetCvars", source: "oracle/codemp/win32/win_net.cpp:1020")
}

/**
```
====================
NET_Config
====================
```
*/
/// Source: oracle/codemp/win32/win_net.cpp:1077
func NET_Config(_ enableNetworking: Bool) {
    // TODO: Port NET_Config
    portMissing("NET_Config", source: "oracle/codemp/win32/win_net.cpp:1077")
}

/**
```
====================
NET_Init
====================
```
*/
/// Source: oracle/codemp/win32/win_net.cpp:1151
public func NET_Init() {
    // TODO: Port NET_Init
    portMissing("NET_Init", source: "oracle/codemp/win32/win_net.cpp:1151")
}

/**
```
====================
NET_Shutdown
====================
```
*/
/// Source: oracle/codemp/win32/win_net.cpp:1193
func NET_Shutdown() {
    // TODO: Port NET_Shutdown
    portMissing("NET_Shutdown", source: "oracle/codemp/win32/win_net.cpp:1193")
}

/**
```
====================
NET_Sleep

sleeps msec or until net socket is ready
====================
```
*/
/// Source: oracle/codemp/win32/win_net.cpp:1211
func NET_Sleep(_ msec: Int32) {
    // TODO: Port NET_Sleep
    portMissing("NET_Sleep", source: "oracle/codemp/win32/win_net.cpp:1211")
}

/**
```
====================
NET_Restart_f
====================
```
*/
/// Source: oracle/codemp/win32/win_net.cpp:1220
func NET_Restart() {
    // TODO: Port NET_Restart
    portMissing("NET_Restart", source: "oracle/codemp/win32/win_net.cpp:1220")
}
