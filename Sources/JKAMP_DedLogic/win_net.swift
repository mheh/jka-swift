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
var socksRelayAddr: Sockaddr {
    get { world.socksRelayAddr }
    set { world.socksRelayAddr = newValue }
}

/// Source: oracle/codemp/win32/win_net.cpp:27
var ip_socket: Int32 {
    get { world.variables.ip_socket }
    set { world.variables.ip_socket = newValue }
}

/// Source: oracle/codemp/win32/win_net.cpp:28
var socks_socket: Int32 {
    get { world.variables.socks_socket }
    set { world.variables.socks_socket = newValue }
}

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
    let code: Int32

    // AI: Raven called the Winsock WSAGetLastError. The backend reads errno.
    code = SysBackend.WSAGetLastError()
    // AI: Raven switched over the Winsock codes and returned the name of each. The backend gives the POSIX text of the errno value.
    return SysBackend.strerror(code)
}

// Raven's `NetadrToSockadr` of win_net.cpp:97 is in Sources/JKAMP_Ded/SysBackend.swift under his name.
// The table has no row for its `struct sockaddr *`, so this file has no stub of that name.

// Raven's `SockadrToNetadr` of win_net.cpp:127 is in Sources/JKAMP_Ded/SysBackend.swift under his name.
// The table has no row for its `struct sockaddr *`, so this file has no stub of that name.

// Raven's `Sys_StringToSockaddr` of win_net.cpp:160 is in Sources/JKAMP_Ded/SysBackend.swift under his name.
// The table has no row for its `struct sockaddr *`, so this file has no stub of that name.

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
    var sadr = Sockaddr()

    if !Sys_StringToSockaddr(s, &sadr) {
        return false
    }

    SockadrToNetadr(sadr, a)
    return true
}

/// Source: oracle/codemp/win32/win_net.cpp:250
func Sys_GetPacket(_ net_from: Netadr, _ net_message: Msg) -> Bool {
    var ret: Int32
    var from = Sockaddr()
    var fromlen: Int32
    var net_socket: Int32
    var `protocol`: Int32
    var err: Int32

    `protocol` = 0
    while `protocol` < 2 {
        if `protocol` == 0 {
            net_socket = ip_socket
        } else {
            net_socket = ipx_socket
        }

        if net_socket == INVALID_SOCKET {
            `protocol` += 1
            continue
        }

        fromlen = Sockaddr.byteCount
        recvfromCount += 1 // performance check
        // AI: Raven called the Winsock recvfrom with his record. The backend calls the POSIX recvfrom and converts the address of the sender.
        ret = SysBackend.recvfrom(net_socket, net_message.data!, net_message.maxsize, &from, &fromlen)

        if ret == SOCKET_ERROR {
            // AI: Raven called the Winsock WSAGetLastError. The backend reads errno.
            err = SysBackend.WSAGetLastError()

            if err == WSAEWOULDBLOCK || err == WSAECONNRESET {
                `protocol` += 1
                continue
            }
            Com_Printf("NET_GetPacket: %s\n", NET_ErrorString())
            `protocol` += 1
            continue
        }

        if net_socket == ip_socket {
            from.sin_zero = [UInt8](repeating: 0, count: 8)
        }

        if usingSocks && net_socket == ip_socket && from == socksRelayAddr {
            if ret < 10 || net_message.data![0] != 0 || net_message.data![1] != 0 || net_message.data![2] != 0 || net_message.data![3] != 1 {
                `protocol` += 1
                continue
            }
            net_from.type = NA_IP
            net_from.ip[0] = net_message.data![4]
            net_from.ip[1] = net_message.data![5]
            net_from.ip[2] = net_message.data![6]
            net_from.ip[3] = net_message.data![7]
            net_from.port = net_message.data![ushort: 8]
            net_message.readcount = 10
        } else {
            SockadrToNetadr(from, net_from)
            net_message.readcount = 0
        }

        if ret == net_message.maxsize {
            Com_Printf("Oversize packet from %s\n", NET_AdrToString(net_from))
            `protocol` += 1
            continue
        }

        net_message.cursize = ret
        return true
    }

    return false
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
    let ret: Int32
    var addr = Sockaddr()
    let net_socket: Int32

    if to.type == NA_BROADCAST {
        net_socket = ip_socket
    } else if to.type == NA_IP {
        net_socket = ip_socket
    } else if to.type == NA_IPX {
        net_socket = ipx_socket
    } else if to.type == NA_BROADCAST_IPX {
        net_socket = ipx_socket
    } else {
        Com_Error(ERR_FATAL, "Sys_SendPacket: bad address type")
    }

    if net_socket == INVALID_SOCKET {
        return
    }

    NetadrToSockadr(to, &addr)

    if usingSocks && to.type == NA_IP {
        // Port-note: Raven stores an int and a short into `char socksBuf[4096]` and copies the packet after them, row "SOCKS" of the win round.
        // Raven wrote: socksBuf[0] = 0; ... memcpy( &socksBuf[10], data, length ); ret = sendto( net_socket, socksBuf, length+10, 0, &socksRelayAddr, sizeof(socksRelayAddr) );
        portMissing("Sys_SendPacket", source: "oracle/codemp/win32/win_net.cpp:393")
    } else {
        // AI: Raven called the Winsock sendto with his record. The backend converts the record and calls the POSIX sendto.
        ret = SysBackend.sendto(net_socket, data, length, addr)
    }
    if ret == SOCKET_ERROR {
        // AI: Raven called the Winsock WSAGetLastError. The backend reads errno.
        let err = SysBackend.WSAGetLastError()

        // wouldblock is silent
        if err == WSAEWOULDBLOCK {
            return
        }

        // some PPP links do not allow broadcasts and return an error
        if (err == WSAEADDRNOTAVAIL) && ((to.type == NA_BROADCAST) || (to.type == NA_BROADCAST_IPX)) {
            return
        }

        Com_Printf("NET_SendPacket: %s\n", NET_ErrorString())
    }
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
    var i: Int32

    if net_forcenonlocal == nil {
        net_forcenonlocal = Cvar_Get("net_forcenonlocal", "0", 0)
    }

    if net_forcenonlocal != nil && net_forcenonlocal!.integer != 0 {
        return false
    }

    if adr.type == NA_LOOPBACK {
        return true
    }

    if adr.type == NA_IPX {
        return true
    }

    if adr.type != NA_IP {
        return false
    }

    // choose which comparison to use based on the class of the address being tested
    // any local adresses of a different class than the address being tested will fail based on the first byte

    if adr.ip[0] == 127 && adr.ip[1] == 0 && adr.ip[2] == 0 && adr.ip[3] == 1 {
        return true
    }

    if (adr.ip[0] == 192 && adr.ip[1] == 168) || (adr.ip[0] == 10 && adr.ip[1] == 100) || (adr.ip[0] == 172 && adr.ip[1] == 16) {
        return true
    }

    /*
    // Class A
    if( (adr.ip[0] & 0x80) == 0x00 ) {
    for ( i = 0 ; i < numIP ; i++ ) {
    if( adr.ip[0] == localIP[i][0] ) {
    return qtrue;
    }
    }
    // the RFC1918 class a block will pass the above test
    return qfalse;
    }

    // Class B
    if( (adr.ip[0] & 0xc0) == 0x80 ) {
    for ( i = 0 ; i < numIP ; i++ ) {
    if( adr.ip[0] == localIP[i][0] && adr.ip[1] == localIP[i][1] ) {
    return qtrue;
    }
    // also check against the RFC1918 class b blocks
    if( adr.ip[0] == 172 && localIP[i][0] == 172 && (adr.ip[1] & 0xf0) == 16 && (localIP[i][1] & 0xf0) == 16 ) {
    return qtrue;
    }
    }
    return qfalse;
    }
    */
    //we only look at class C since ISPs and Universities are using class A but we don't want to consider them on the same LAN.

    // Class C
    i = 0
    while i < numIP {
        if adr.ip[0] == localIP[i][0] && adr.ip[1] == localIP[i][1] && adr.ip[2] == localIP[i][2] {
            return true
        }

        //check for both on a local lan type thing
        if adr.ip[0] == 10 && localIP[i][0] == 10 {
            return true
        }

        // also check against the RFC1918 class c blocks
        //		if( adr.ip[0] == 192 && localIP[i][0] == 192 && adr.ip[1] == 168 && localIP[i][1] == 168 ) {
        //			return qtrue;
        //		}
        i += 1
    }
    return false
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
    var i: Int32

    i = 0
    while i < numIP {
        Com_Printf("IP: %i.%i.%i.%i\n", localIP[i][0], localIP[i][1], localIP[i][2], localIP[i][3])
        i += 1
    }
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
    let newsocket: Int32
    var address = Sockaddr()
    let err: Int32

    Com_Printf("Opening IP socket: %s:%i\n", net_interface, port)

    // AI: Raven called the Winsock socket( AF_INET, SOCK_DGRAM, IPPROTO_UDP ). The backend calls the POSIX socket with the same values.
    newsocket = SysBackend.udpSocket()
    if newsocket == INVALID_SOCKET {
        // AI: Raven called the Winsock WSAGetLastError. The backend reads errno.
        err = SysBackend.WSAGetLastError()
        if err != WSAEAFNOSUPPORT {
            Com_Printf("WARNING: UDP_OpenSocket: socket: %s\n", NET_ErrorString())
        }
        return INVALID_SOCKET
    }

    // make it non-blocking
    // AI: Raven called the Winsock ioctlsocket with FIONBIO. The backend sets O_NONBLOCK with the POSIX fcntl.
    if SysBackend.setNonBlocking(newsocket) == SOCKET_ERROR {
        Com_Printf("WARNING: UDP_OpenSocket: ioctl FIONBIO: %s\n", NET_ErrorString())
        return INVALID_SOCKET
    }

    // make it broadcast capable
    // AI: Raven called the Winsock setsockopt with SO_BROADCAST. The backend calls the POSIX setsockopt with the same option.
    if SysBackend.setBroadcast(newsocket) == SOCKET_ERROR {
        Com_Printf("WARNING: UDP_OpenSocket: setsockopt SO_BROADCAST: %s\n", NET_ErrorString())
        return INVALID_SOCKET
    }

    if net_interface.isEmpty || Q_stricmp(net_interface, "localhost") == 0 {
        address.sin_addr = SysBackend.INADDR_ANY
    } else {
        Sys_StringToSockaddr(net_interface, &address)
    }

    if port == PORT_ANY {
        address.sin_port = 0
    } else {
        // AI: Raven called the Winsock htons. The backend swaps the bytes to big-endian order.
        address.sin_port = SysBackend.htons(Int16(truncatingIfNeeded: port))
    }

    address.sin_family = SysBackend.AF_INET

    // AI: Raven called the Winsock bind with his record. The backend converts the record and calls the POSIX bind.
    if SysBackend.bind(newsocket, address) == SOCKET_ERROR {
        Com_Printf("WARNING: UDP_OpenSocket: bind: %s\n", NET_ErrorString())
        // AI: Raven called the Winsock closesocket. The backend calls the POSIX close.
        SysBackend.closesocket(newsocket)
        return INVALID_SOCKET
    }

    return newsocket
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
    // Port-note: Raven's SOCKS client talks TCP through `unsigned char buf[64]` and copies cvar text into it, row "SOCKS" of the win round.
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
    let hostname: String?
    let hostInfo: Hostent?
    var error: Int32
    var ip: Int32
    var n: Int32

    // Set this early so we can just return if there is an error
    numIP = 0

    // AI: Raven called the Winsock gethostname into `char hostname[256]`. The backend calls the POSIX gethostname, nil on a failure.
    hostname = SysBackend.gethostname()
    if hostname == nil {
        // AI: Raven called the Winsock WSAGetLastError. The backend reads errno.
        error = SysBackend.WSAGetLastError()
        return
    }

    // AI: Raven called the Winsock gethostbyname. The backend calls the POSIX gethostbyname and copies the record.
    hostInfo = SysBackend.gethostbyname(hostname!)
    if hostInfo == nil {
        // AI: Raven called the Winsock WSAGetLastError. The backend reads errno.
        error = SysBackend.WSAGetLastError()
        return
    }

    Com_Printf("Hostname: %s\n", hostInfo!.h_name)
    n = 0
    // AI: Raven walked the alias list to its NULL. The list is an array, so the walk stops at its count.
    while n < hostInfo!.h_aliases.count {
        let p = hostInfo!.h_aliases[n]
        n += 1
        Com_Printf("Alias: %s\n", p)
    }

    if hostInfo!.h_addrtype != SysBackend.AF_INET {
        return
    }

    // AI: Raven walked the address list to its NULL. The list is an array, so the walk stops at its count.
    while numIP < hostInfo!.h_addr_list.count && numIP < MAX_IPS {
        let p = hostInfo!.h_addr_list[numIP]
        // AI: Raven read the four bytes as an int and swapped them with ntohl. The backend reads the four bytes in network order.
        ip = SysBackend.ntohl(p)
        localIP[numIP][0] = p[0]
        localIP[numIP][1] = p[1]
        localIP[numIP][2] = p[2]
        localIP[numIP][3] = p[3]
        Com_Printf("IP: %i.%i.%i.%i\n", (ip >> 24) & 0xff, (ip >> 16) & 0xff, (ip >> 8) & 0xff, ip & 0xff)
        numIP += 1
    }
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
    let ip: Cvar?
    let port: Int32
    var i: Int32

    ip = Cvar_Get("net_ip", "localhost", CVAR_LATCH)
    port = Cvar_Get("net_port", va("%i", PORT_SERVER), CVAR_LATCH)!.integer

    // automatically scan for a valid port, so multiple
    // dedicated servers can be started without requiring
    // a different net_port for each one
    i = 0
    while i < 10 {
        ip_socket = NET_IPSocket(ip!.string!, port + i)
        if ip_socket != INVALID_SOCKET {
            Cvar_SetValue("net_port", Float(port + i))
            if net_socksEnabled!.integer != 0 {
                NET_OpenSocks(port + i)
            }
            NET_GetLocalAddress()
            return
        }
        i += 1
    }
    Com_Printf("WARNING: Couldn't allocate IP port\n")
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
    let newsocket: Int32
    var address = Sockaddr()
    let err: Int32

    // AI: Raven called the Winsock socket( AF_IPX, SOCK_DGRAM, NSPROTO_IPX ). A POSIX host has no IPX family, so the backend call fails.
    newsocket = SysBackend.ipxSocket()
    if newsocket == INVALID_SOCKET {
        // AI: Raven called the Winsock WSAGetLastError. The backend reads errno.
        err = SysBackend.WSAGetLastError()
        if err != WSAEAFNOSUPPORT {
            Com_Printf("WARNING: IPX_Socket: socket: %s\n", NET_ErrorString())
        }
        return INVALID_SOCKET
    }

    // make it non-blocking
    // AI: Raven called the Winsock ioctlsocket with FIONBIO. The backend sets O_NONBLOCK with the POSIX fcntl.
    if SysBackend.setNonBlocking(newsocket) == SOCKET_ERROR {
        Com_Printf("WARNING: IPX_Socket: ioctl FIONBIO: %s\n", NET_ErrorString())
        return INVALID_SOCKET
    }

    // make it broadcast capable
    // AI: Raven called the Winsock setsockopt with SO_BROADCAST. The backend calls the POSIX setsockopt with the same option.
    if SysBackend.setBroadcast(newsocket) == SOCKET_ERROR {
        Com_Printf("WARNING: IPX_Socket: setsockopt SO_BROADCAST: %s\n", NET_ErrorString())
        return INVALID_SOCKET
    }

    address.sa_family = SysBackend.AF_IPX
    address.sa_netnum = [0, 0, 0, 0]
    address.sa_nodenum = [0, 0, 0, 0, 0, 0]
    if port == PORT_ANY {
        address.sa_socket = 0
    } else {
        // AI: Raven called the Winsock htons. The backend swaps the bytes to big-endian order.
        address.sa_socket = SysBackend.htons(Int16(truncatingIfNeeded: port))
    }

    // AI: Raven called the Winsock bind with his record. The backend binds an IPv4 record alone, so this call fails.
    if SysBackend.bind(newsocket, address) == SOCKET_ERROR {
        Com_Printf("WARNING: IPX_Socket: bind: %s\n", NET_ErrorString())
        // AI: Raven called the Winsock closesocket. The backend calls the POSIX close.
        SysBackend.closesocket(newsocket)
        return INVALID_SOCKET
    }
    return newsocket
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
    let port: Int32

    port = Cvar_Get("net_port", va("%i", PORT_SERVER), CVAR_LATCH)!.integer
    ipx_socket = NET_IPXSocket(port)
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
    var modified: Bool

    modified = false

    if net_noudp != nil && net_noudp!.modified {
        modified = true
    }
    net_noudp = Cvar_Get("net_noudp", "0", CVAR_LATCH | CVAR_ARCHIVE)

    if net_noipx != nil && net_noipx!.modified {
        modified = true
    }
    net_noipx = Cvar_Get("net_noipx", "1", CVAR_LATCH | CVAR_ARCHIVE)


    if net_forcenonlocal != nil && net_forcenonlocal!.modified {
        modified = true
    }
    net_forcenonlocal = Cvar_Get("net_forcenonlocal", "0", CVAR_LATCH | CVAR_ARCHIVE)


    if net_socksEnabled != nil && net_socksEnabled!.modified {
        modified = true
    }
    net_socksEnabled = Cvar_Get("net_socksEnabled", "0", CVAR_LATCH | CVAR_ARCHIVE)

    if net_socksServer != nil && net_socksServer!.modified {
        modified = true
    }
    net_socksServer = Cvar_Get("net_socksServer", "", CVAR_LATCH | CVAR_ARCHIVE)

    if net_socksPort != nil && net_socksPort!.modified {
        modified = true
    }
    net_socksPort = Cvar_Get("net_socksPort", "1080", CVAR_LATCH | CVAR_ARCHIVE)

    if net_socksUsername != nil && net_socksUsername!.modified {
        modified = true
    }
    net_socksUsername = Cvar_Get("net_socksUsername", "", CVAR_LATCH | CVAR_ARCHIVE)

    if net_socksPassword != nil && net_socksPassword!.modified {
        modified = true
    }
    net_socksPassword = Cvar_Get("net_socksPassword", "", CVAR_LATCH | CVAR_ARCHIVE)


    return modified
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
    let modified: Bool
    var stop: Bool
    var start: Bool
    // Raven assigns his own `enableNetworking` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var enableNetworking = enableNetworking

    // get any latched changes to cvars
    modified = NET_GetCvars()

    if net_noudp!.integer != 0 && net_noipx!.integer != 0 {
        enableNetworking = false
    }

    // if enable state is the same and no cvars were modified, we have nothing to do
    if enableNetworking == networkingEnabled && !modified {
        return
    }

    if enableNetworking == networkingEnabled {
        if enableNetworking {
            stop = true
            start = true
        } else {
            stop = false
            start = false
        }
    } else {
        if enableNetworking {
            stop = false
            start = true
        } else {
            stop = true
            start = false
        }
        networkingEnabled = enableNetworking
    }

    if stop {
        // AI: Raven called the Winsock closesocket on each socket. The backend calls the POSIX close.
        if ip_socket != 0 && ip_socket != INVALID_SOCKET {
            SysBackend.closesocket(ip_socket)
            ip_socket = INVALID_SOCKET
        }

        if socks_socket != 0 && socks_socket != INVALID_SOCKET {
            SysBackend.closesocket(socks_socket)
            socks_socket = INVALID_SOCKET
        }

        if ipx_socket != 0 && ipx_socket != INVALID_SOCKET {
            SysBackend.closesocket(ipx_socket)
            ipx_socket = INVALID_SOCKET
        }
    }

    if start {
        if net_noudp!.integer == 0 {
            NET_OpenIP()
        }
        if net_noipx!.integer == 0 {
            NET_OpenIPX()
        }
    }
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
    let r: Int32

    // AI: Raven called the Winsock WSAStartup into `winsockdata`. POSIX sockets need no startup, so the result is Raven's 0 for a success.
    r = 0
    if r != 0 {
        Com_Printf("WARNING: Winsock initialization failed, returned %d\n", r)
        return
    }

    winsockInitialized = true
    Com_Printf("Winsock Initialized\n")

    // this is really just to get the cvars registered
    NET_GetCvars()

    //FIXME testing!
    NET_Config(true)
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
    if !winsockInitialized {
        return
    }

    NET_Config(false)
    // AI: Raven called the Winsock WSACleanup. POSIX sockets need no cleanup, so the call drops.
    winsockInitialized = false
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
    NET_Config(networkingEnabled)
}
