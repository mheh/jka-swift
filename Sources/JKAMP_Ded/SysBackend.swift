#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#endif
internal import CJKAMP_Ded
import JKAMP
import JKAShared

// MARK: - The Winsock names

/// Raven's `INVALID_SOCKET` of `winsock.h`, the socket that a failed `socket` call returns.
/// Source: oracle/codemp/win32/win_net.cpp:27
// AI: Raven read the Winsock value. A POSIX descriptor is an int, and -1 is the failed descriptor.
public let INVALID_SOCKET: Int32 = -1

/// Raven's `SOCKET_ERROR` of `winsock.h`, the result of a failed socket call.
/// Source: oracle/codemp/win32/win_net.cpp:274
// AI: Raven read the Winsock value. A POSIX socket call returns -1 on a failure, the same value.
public let SOCKET_ERROR: Int32 = -1

/// Raven's `WSAEWOULDBLOCK`, the error of a nonblocking call with no data.
/// Source: oracle/codemp/win32/win_net.cpp:278
// AI: Raven read the Winsock code. The POSIX host reads the errno value of the same condition.
public let WSAEWOULDBLOCK = Int32(EWOULDBLOCK)

/// Raven's `WSAECONNRESET`, the error after a port-unreachable reply.
/// Source: oracle/codemp/win32/win_net.cpp:278
// AI: Raven read the Winsock code. The POSIX host reads the errno value of the same condition.
public let WSAECONNRESET = Int32(ECONNRESET)

/// Raven's `WSAEAFNOSUPPORT`, the error of a socket family the host does not have.
/// Source: oracle/codemp/win32/win_net.cpp:604
// AI: Raven read the Winsock code. The POSIX host reads the errno value of the same condition.
public let WSAEAFNOSUPPORT = Int32(EAFNOSUPPORT)

/// Raven's `WSAEADDRNOTAVAIL`, the error of a broadcast that a link refuses.
/// Source: oracle/codemp/win32/win_net.cpp:460
// AI: Raven read the Winsock code. The POSIX host reads the errno value of the same condition.
public let WSAEADDRNOTAVAIL = Int32(EADDRNOTAVAIL)

/// Raven's `FILE_ATTRIBUTE_READONLY` of `winnt.h`, the attribute bit of a file that refuses a write.
/// Source: oracle/codemp/qcommon/files_pc.cpp:950
// AI: Raven read the Win32 value. The backend gives this bit when the owner of the file has no write permission.
public let FILE_ATTRIBUTE_READONLY: UInt32 = 0x0000_0001

/// Raven's `FILETIME` of `windef.h`, a time in 100-nanosecond steps since 1 January 1601, split into two 32-bit halves.
/// Source: oracle/codemp/qcommon/files_pc.cpp:568
// AI: Raven read the Win32 record. The value keeps its two fields, and SysBackend.GetFileTime fills them from the POSIX modification time.
public struct FILETIME {
    public var dwLowDateTime: UInt32 = 0
    public var dwHighDateTime: UInt32 = 0

    public init() {}
}

/// Raven's `_A_SUBDIR` of `io.h`, the attribute bit of a directory entry.
/// Source: oracle/codemp/null/win_main.cpp:457
// AI: Raven read the Win32 CRT value. The backend sets this bit for an entry that the POSIX stat names a directory.
public let _A_SUBDIR: Int32 = 0x10

/// Raven's `struct _finddata_t` of `io.h`, the entry that `_findfirst` and `_findnext` fill.
/// Source: oracle/codemp/null/win_main.cpp:438
// AI: Raven read the Win32 CRT record. The value keeps the two fields the bodies read, and `name` holds the text of `char name[260]`.
public struct _finddata_t {
    public var attrib: Int32 = 0
    public var name: String = ""

    public init() {}
}

// MARK: - The address records

/// Raven's `struct sockaddr` in its Winsock layout, the sixteen bytes that Raven reads as a `sockaddr_in` or a `sockaddr_ipx`.
/// Each accessor reads and writes the bytes at the Winsock offset of its field, so a store keeps C's bit pattern.
// AI: Raven passes the Winsock record to the socket calls. The value keeps that layout, and the backend converts it to the POSIX record at each call.
public struct Sockaddr: Equatable {
    /// The size of the record in bytes, Raven's `sizeof(struct sockaddr)`.
    public static let byteCount: Int32 = 16

    public var bytes = [UInt8](repeating: 0, count: 16)

    public init() {}

    /// Raven's `sa_family` and `sin_family`, the first two bytes.
    public var sa_family: Int32 {
        get { Int32(self.load(UInt16.self, at: 0)) }
        set { self.store(UInt16(truncatingIfNeeded: newValue), at: 0) }
    }

    /// Raven's `sin_family` of the `sockaddr_in` cast.
    public var sin_family: Int32 {
        get { self.sa_family }
        set { self.sa_family = newValue }
    }

    /// Raven's `sin_port`, in network order as the record stores it.
    public var sin_port: UInt16 {
        get { self.load(UInt16.self, at: 2) }
        set { self.store(newValue, at: 2) }
    }

    /// Raven's `sin_addr.s_addr`, in network order as the record stores it.
    public var sin_addr: Int32 {
        get { self.load(Int32.self, at: 4) }
        set { self.store(newValue, at: 4) }
    }

    /// Raven's `sin_zero`, the eight bytes after the address.
    public var sin_zero: [UInt8] {
        get { Array(self.bytes[8..<16]) }
        set { self.bytes.replaceSubrange(8..<16, with: newValue.prefix(8)) }
    }

    /// Raven's `sa_netnum` of the `sockaddr_ipx` cast, four bytes after the family.
    public var sa_netnum: [UInt8] {
        get { Array(self.bytes[2..<6]) }
        set { self.bytes.replaceSubrange(2..<6, with: newValue.prefix(4)) }
    }

    /// Raven's `sa_nodenum` of the `sockaddr_ipx` cast, six bytes after the network number.
    public var sa_nodenum: [UInt8] {
        get { Array(self.bytes[6..<12]) }
        set { self.bytes.replaceSubrange(6..<12, with: newValue.prefix(6)) }
    }

    /// Raven's `sa_socket` of the `sockaddr_ipx` cast, in network order.
    public var sa_socket: UInt16 {
        get { self.load(UInt16.self, at: 12) }
        set { self.store(newValue, at: 12) }
    }

    private func load<T>(_ type: T.Type, at offset: Int) -> T {
        self.bytes.withUnsafeBytes { $0.loadUnaligned(fromByteOffset: offset, as: T.self) }
    }

    private mutating func store<T>(_ value: T, at offset: Int) {
        self.bytes.withUnsafeMutableBytes { $0.storeBytes(of: value, toByteOffset: offset, as: T.self) }
    }
}

/// Raven's `struct hostent`, the answer of `gethostbyname`.
/// Each address of `h_addr_list` holds the four bytes of an IPv4 address in network order.
// AI: Raven reads the C record and walks its NULL-terminated lists. The value holds the lists as arrays.
public struct Hostent {
    public var h_name: String
    public var h_aliases: [String]
    public var h_addrtype: Int32
    public var h_addr_list: [[UInt8]]
}

// MARK: - The platform calls

/// The POSIX calls under Raven's win32 files, one function for each Win32 or Winsock call that Raven makes.
/// Each function names the call of Raven's that it replaces, and its `Source:` line names the first site.
public enum SysBackend {
    /// Raven's Winsock `AF_INET`.
    public static let AF_INET: Int32 = 2

    /// Raven's Winsock `AF_IPX`.
    public static let AF_IPX: Int32 = 6

    /// Raven's `INADDR_ANY`, the address of every interface.
    public static let INADDR_ANY: Int32 = 0

    /// Raven's `INADDR_BROADCAST`, the limited broadcast address.
    public static let INADDR_BROADCAST: Int32 = -1

    /// Raven's `timeGetTime`, the milliseconds since the system started, truncated to 32 bits as the DWORD wraps.
    /// Source: oracle/codemp/win32/win_shared.cpp:24
    // AI: Raven called the Win32 timeGetTime. The backend reads the monotonic clock of the platform in milliseconds.
    public static func timeGetTime() -> Int32 {
        var now = timespec()
        clock_gettime(CLOCK_MONOTONIC, &now)
        let milliseconds = Int64(now.tv_sec) * 1000 + Int64(now.tv_nsec) / 1_000_000
        return Int32(truncatingIfNeeded: milliseconds)
    }

    /// Raven's `kbhit` of `conio.h`, true when a key waits on the console.
    /// On the first call with a terminal on standard input, it turns off the line mode and the echo, as the Win32 console gives keys one by one.
    /// Source: oracle/codemp/null/win_main.cpp:207
    // AI: Raven called the conio kbhit. The backend polls standard input with no wait.
    public static func kbhit() -> Bool {
        var settings = termios()
        if tcgetattr(STDIN_FILENO, &settings) == 0 && (settings.c_lflag & tcflag_t(ICANON)) != 0 {
            settings.c_lflag &= ~tcflag_t(ICANON | ECHO)
            settings.c_iflag &= ~tcflag_t(ICRNL)
            tcsetattr(STDIN_FILENO, TCSANOW, &settings)
            // At exit, we give the terminal its line mode and its echo again.
            atexit {
                var restore = termios()
                if tcgetattr(STDIN_FILENO, &restore) == 0 {
                    restore.c_lflag |= tcflag_t(ICANON | ECHO)
                    restore.c_iflag |= tcflag_t(ICRNL)
                    tcsetattr(STDIN_FILENO, TCSANOW, &restore)
                }
            }
        }
        var waiting = pollfd(fd: STDIN_FILENO, events: Int16(POLLIN), revents: 0)
        return poll(&waiting, 1, 0) > 0 && (waiting.revents & Int16(POLLIN)) != 0
    }

    /// Raven's `getch` of `conio.h`, one key from the console with no echo.
    /// Source: oracle/codemp/null/win_main.cpp:211
    // AI: Raven called the conio getch. The backend reads one byte from standard input, after kbhit gave the terminal its key mode.
    public static func getch() -> Int32 {
        var key: UInt8 = 0
        // An end of file gives 0, which Raven's switch reads as the first byte of a function key, so the console prints nothing.
        if read(STDIN_FILENO, &key, 1) != 1 {
            return 0
        }
        return Int32(key)
    }

    /// Raven's `printf` of a text with no format argument, the bytes of the buffer up to its first NUL on standard output.
    /// Source: oracle/codemp/null/win_main.cpp:38
    // AI: Raven called the C printf on the console. The backend writes the bytes of the buffer to the standard output descriptor.
    // The `stdout` stream global is not concurrency-safe on Glibc, so the write goes to the descriptor, which needs no flush.
    public static func printf(_ text: CharBuf) {
        text.withUnsafeRawPointer { base in
            _ = write(STDOUT_FILENO, base, Int(strlen(base.assumingMemoryBound(to: CChar.self))))
        }
    }

    /// Raven's `_mkdir`, one directory at the path.
    /// Source: oracle/codemp/null/win_main.cpp:389
    // AI: Raven called the Win32 _mkdir. The backend calls the POSIX mkdir with every permission bit, which the umask narrows.
    public static func _mkdir(_ path: String) {
        var buf = CharBuf(path)
        buf.withUnsafeMutableRawPointer { base in
            _ = mkdir(base.assumingMemoryBound(to: CChar.self), 0o777)
        }
    }

    /// Raven's `_getcwd`, the working directory of the process, or an empty text when the call fails.
    /// Source: oracle/codemp/null/win_main.cpp:400
    // AI: Raven called the Win32 _getcwd into his buffer. The backend calls the POSIX getcwd and returns its text.
    public static func _getcwd() -> String {
        var cwd = CharBuf(Int(JKAMP.MAX_OSPATH))
        cwd.withUnsafeMutableRawPointer { base in
            if getcwd(base.assumingMemoryBound(to: CChar.self), Int(JKAMP.MAX_OSPATH)) == nil {
                base.storeBytes(of: 0, as: UInt8.self)
            }
        }
        return String(cwd)
    }

    /// Raven's `GetUserName`, the login name of the process owner, or nil when the call fails.
    /// Source: oracle/codemp/win32/win_shared.cpp:302
    // AI: Raven called the Win32 GetUserName. The backend reads the name of the effective user from the password database.
    public static func GetUserName() -> String? {
        guard let entry = getpwuid(geteuid()), let name = entry.pointee.pw_name else { return nil }
        return cText(name)
    }

    /// Raven's `dwTotalPhys` of `GlobalMemoryStatus`, the bytes of physical memory.
    /// Source: oracle/codemp/null/win_main.cpp:50
    // AI: Raven called the Win32 GlobalMemoryStatus. The backend multiplies the physical page count by the page size.
    public static func GlobalMemoryStatus() -> UInt64 {
        let pages = sysconf(Int32(_SC_PHYS_PAGES))
        let pageSize = sysconf(Int32(_SC_PAGESIZE))
        if pages < 0 || pageSize < 0 {
            return 0
        }
        return UInt64(pages) * UInt64(pageSize)
    }

    /// Raven's `FreeLibrary`, false when the library does not close.
    /// Source: oracle/codemp/null/win_main.cpp:727
    // AI: Raven called the Win32 FreeLibrary. The backend calls the POSIX dlclose on the handle of dlopen.
    public static func FreeLibrary(_ dllHandle: OpaquePointer) -> Bool {
        dlclose(UnsafeMutableRawPointer(dllHandle)) == 0
    }

    /// Raven's `WSAGetLastError`, the error of the last socket call.
    /// Source: oracle/codemp/win32/win_net.cpp:46
    // AI: Raven called the Winsock WSAGetLastError. The backend reads errno.
    public static func WSAGetLastError() -> Int32 {
        errno
    }

    /// The text of an error code, the name that Raven's NET_ErrorString gives each Winsock code.
    /// Source: oracle/codemp/win32/win_net.cpp:47
    // AI: Raven switched over the Winsock codes for their names. The backend gives the POSIX text of the errno value.
    public static func strerror(_ code: Int32) -> String {
        guard let text = c_strerror(code) else { return "NO ERROR" }
        return cText(text)
    }

    /// Raven's `socket( AF_INET, SOCK_DGRAM, IPPROTO_UDP )`, a UDP socket, or `INVALID_SOCKET`.
    /// Source: oracle/codemp/win32/win_net.cpp:602
    // AI: Raven called the Winsock socket. The backend calls the POSIX socket with the same three values.
    public static func udpSocket() -> Int32 {
        #if canImport(Glibc)
        socket(PF_INET, Int32(SOCK_DGRAM.rawValue), Int32(IPPROTO_UDP))
        #else
        socket(PF_INET, SOCK_DGRAM, Int32(IPPROTO_UDP))
        #endif
    }

    /// Raven's `socket( AF_IPX, SOCK_DGRAM, NSPROTO_IPX )`, which fails on a POSIX host.
    /// Source: oracle/codemp/win32/win_net.cpp:958
    // AI: Raven called the Winsock socket for IPX. A POSIX host has no IPX family, so the call fails with WSAEAFNOSUPPORT.
    public static func ipxSocket() -> Int32 {
        errno = EAFNOSUPPORT
        return INVALID_SOCKET
    }

    /// Raven's `ioctlsocket( s, FIONBIO, &_true )`, which makes the socket nonblocking.
    /// Source: oracle/codemp/win32/win_net.cpp:611
    // AI: Raven called the Winsock ioctlsocket. The backend sets O_NONBLOCK with the POSIX fcntl.
    public static func setNonBlocking(_ s: Int32) -> Int32 {
        let flags = fcntl(s, F_GETFL, 0)
        if flags == -1 {
            return SOCKET_ERROR
        }
        return fcntl(s, F_SETFL, flags | O_NONBLOCK) == -1 ? SOCKET_ERROR : 0
    }

    /// Raven's `setsockopt( s, SOL_SOCKET, SO_BROADCAST, ... )` with a value of 1.
    /// Source: oracle/codemp/win32/win_net.cpp:617
    // AI: Raven called the Winsock setsockopt. The backend calls the POSIX setsockopt with the same option.
    public static func setBroadcast(_ s: Int32) -> Int32 {
        var i: Int32 = 1
        return setsockopt(s, SOL_SOCKET, SO_BROADCAST, &i, socklen_t(MemoryLayout<Int32>.size))
    }

    /// Raven's `bind` of a socket to an IPv4 address.
    /// Source: oracle/codemp/win32/win_net.cpp:638
    // AI: Raven called the Winsock bind with his record. The backend converts the record and calls the POSIX bind.
    public static func bind(_ s: Int32, _ address: Sockaddr) -> Int32 {
        // A POSIX host has no IPX family, so only an IPv4 record binds.
        if address.sa_family != self.AF_INET {
            errno = EAFNOSUPPORT
            return SOCKET_ERROR
        }
        var platform = self.platformAddress(address)
        return withUnsafePointer(to: &platform) { pointer in
            pointer.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                c_bind(s, $0, socklen_t(MemoryLayout<sockaddr_in>.size))
            }
        }
    }

    /// Raven's `closesocket`.
    /// Source: oracle/codemp/win32/win_net.cpp:640
    // AI: Raven called the Winsock closesocket. The backend calls the POSIX close.
    public static func closesocket(_ s: Int32) {
        _ = close(s)
    }

    /// Raven's `recvfrom` into the bytes of a message, which fills the sender's record and its length.
    /// Source: oracle/codemp/win32/win_net.cpp:272
    // AI: Raven called the Winsock recvfrom with his record. The backend calls the POSIX recvfrom and converts the sender's address.
    public static func recvfrom(_ s: Int32, _ buf: Slots<byte>, _ len: Int32, _ from: inout Sockaddr, _ fromlen: inout Int32) -> Int32 {
        var platform = sockaddr_in()
        var platformLength = socklen_t(MemoryLayout<sockaddr_in>.size)
        let ret = withUnsafeMutablePointer(to: &platform) { pointer in
            pointer.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                c_recvfrom(s, buf.base, Int(len), 0, $0, &platformLength)
            }
        }
        if ret >= 0 {
            from = Sockaddr()
            if Int32(platform.sin_family) == PF_INET {
                from.sin_family = self.AF_INET
                from.sin_port = platform.sin_port
                from.sin_addr = Int32(bitPattern: platform.sin_addr.s_addr)
            }
            fromlen = Sockaddr.byteCount
        }
        return Int32(truncatingIfNeeded: ret)
    }

    /// Raven's `sendto` of bytes to an IPv4 address.
    /// Source: oracle/codemp/win32/win_net.cpp:447
    // AI: Raven called the Winsock sendto with his record. The backend converts the record and calls the POSIX sendto.
    public static func sendto(_ s: Int32, _ data: Slots<byte>, _ len: Int32, _ to: Sockaddr) -> Int32 {
        // A POSIX host has no IPX family, so only an IPv4 record sends.
        if to.sa_family != self.AF_INET {
            errno = EAFNOSUPPORT
            return SOCKET_ERROR
        }
        var platform = self.platformAddress(to)
        let ret = withUnsafePointer(to: &platform) { pointer in
            pointer.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                c_sendto(s, data.base, Int(len), 0, $0, socklen_t(MemoryLayout<sockaddr_in>.size))
            }
        }
        return Int32(truncatingIfNeeded: ret)
    }

    /// Raven's `gethostname`, the name of this host, or nil when the call fails.
    /// Source: oracle/codemp/win32/win_net.cpp:852
    // AI: Raven called the Winsock gethostname into a buffer of 256. The backend calls the POSIX gethostname and returns its text.
    public static func gethostname() -> String? {
        var hostname = CharBuf(256)
        let ret = hostname.withUnsafeMutableRawPointer { base in
            c_gethostname(base.assumingMemoryBound(to: CChar.self), 256)
        }
        return ret == 0 ? String(hostname) : nil
    }

    /// Raven's `gethostbyname`, the IPv4 record of a name, or nil when the name does not resolve.
    /// Source: oracle/codemp/win32/win_net.cpp:206
    // AI: Raven called the Winsock gethostbyname. The backend calls the POSIX gethostbyname and copies the record before the next call reuses it.
    public static func gethostbyname(_ name: String) -> Hostent? {
        var buf = CharBuf(name)
        let entry = buf.withUnsafeMutableRawPointer { base in
            c_gethostbyname(base.assumingMemoryBound(to: CChar.self))
        }
        guard let entry else { return nil }
        let record = entry.pointee
        var aliases = [String]()
        if let list = record.h_aliases {
            var n = 0
            while let alias = list[n] {
                aliases.append(cText(alias))
                n += 1
            }
        }
        var addresses = [[UInt8]]()
        if let list = record.h_addr_list {
            var n = 0
            while let address = list[n] {
                let bytes = UnsafeRawPointer(address).assumingMemoryBound(to: UInt8.self)
                addresses.append([bytes[0], bytes[1], bytes[2], bytes[3]])
                n += 1
            }
        }
        let family = Int32(record.h_addrtype) == PF_INET ? self.AF_INET : Int32(record.h_addrtype)
        return Hostent(
            h_name: record.h_name.map { cText($0) } ?? "",
            h_aliases: aliases,
            h_addrtype: family,
            h_addr_list: addresses
        )
    }

    /// Raven's `inet_addr`, the network-order address of a dotted text.
    /// Source: oracle/codemp/win32/win_net.cpp:199
    // AI: Raven called the Winsock inet_addr. The backend calls the POSIX inet_addr.
    public static func inet_addr(_ s: String) -> Int32 {
        var buf = CharBuf(s)
        return buf.withUnsafeMutableRawPointer { base in
            Int32(bitPattern: c_inet_addr(base.assumingMemoryBound(to: CChar.self)))
        }
    }

    /// Raven's `ntohl( *(int *)p )` over the four bytes of an address.
    /// Source: oracle/codemp/win32/win_net.cpp:874
    // AI: Raven read the bytes as an int and swapped them with ntohl. The backend reads the four bytes in network order.
    public static func ntohl(_ p: [UInt8]) -> Int32 {
        Int32(bitPattern: UInt32(p[0]) << 24 | UInt32(p[1]) << 16 | UInt32(p[2]) << 8 | UInt32(p[3]))
    }

    /// Raven's `htons( (short)port )`, the port in network order.
    /// Source: oracle/codemp/win32/win_net.cpp:633
    // AI: Raven called the Winsock htons. The backend swaps the bytes to big-endian order.
    public static func htons(_ port: Int16) -> UInt16 {
        UInt16(bitPattern: port).bigEndian
    }

    /// Raven's `socket( AF_INET, SOCK_STREAM, IPPROTO_TCP )`, a TCP socket, or `INVALID_SOCKET`.
    /// Source: oracle/codemp/win32/win_net.cpp:666
    // AI: Raven called the Winsock socket. The backend calls the POSIX socket with the same three values.
    public static func tcpSocket() -> Int32 {
        #if canImport(Glibc)
        socket(PF_INET, Int32(SOCK_STREAM.rawValue), Int32(IPPROTO_TCP))
        #else
        socket(PF_INET, SOCK_STREAM, Int32(IPPROTO_TCP))
        #endif
    }

    /// Raven's `connect` of a socket to an IPv4 address.
    /// Source: oracle/codemp/win32/win_net.cpp:692
    // AI: Raven called the Winsock connect with his record. The backend converts the record and calls the POSIX connect.
    public static func connect(_ s: Int32, _ address: Sockaddr) -> Int32 {
        // A POSIX host has no IPX family, so only an IPv4 record connects.
        if address.sa_family != self.AF_INET {
            errno = EAFNOSUPPORT
            return SOCKET_ERROR
        }
        var platform = self.platformAddress(address)
        return withUnsafePointer(to: &platform) { pointer in
            pointer.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                c_connect(s, $0, socklen_t(MemoryLayout<sockaddr_in>.size))
            }
        }
    }

    /// Raven's `send` of the first `len` bytes of a buffer on a connected socket.
    /// Source: oracle/codemp/win32/win_net.cpp:719
    // AI: Raven called the Winsock send. The backend calls the POSIX send with the bytes of the buffer.
    public static func send(_ s: Int32, _ buf: CharBuf, _ len: Int32) -> Int32 {
        precondition(len >= 0 && Int(len) <= buf.count, "send: length past the end of the buffer")
        let ret = buf.withUnsafeRawPointer { base in
            c_send(s, base, Int(len), 0)
        }
        return Int32(truncatingIfNeeded: ret)
    }

    /// Raven's `recv` of at most `len` bytes into a buffer from a connected socket.
    /// Source: oracle/codemp/win32/win_net.cpp:726
    // AI: Raven called the Winsock recv. The backend calls the POSIX recv into the bytes of the buffer.
    public static func recv(_ s: Int32, _ buf: inout CharBuf, _ len: Int32) -> Int32 {
        precondition(len >= 0 && Int(len) <= buf.count, "recv: length past the end of the buffer")
        let ret = buf.withUnsafeMutableRawPointer { base in
            c_recv(s, base, Int(len), 0)
        }
        return Int32(truncatingIfNeeded: ret)
    }

    /// Raven's `CreateFile`, `GetFileTime`, and `CloseHandle` of Sys_GetFileTime, the last write time of a file, false when the file does not open.
    /// Source: oracle/codemp/qcommon/files_pc.cpp:568
    // AI: Raven read the last write time through the Win32 file handle. The backend reads the POSIX stat modification time as a FILETIME.
    public static func GetFileTime(_ psFileName: String, _ ft: inout FILETIME) -> Bool {
        var info = stat()
        var path = CharBuf(psFileName)
        let ret = path.withUnsafeMutableRawPointer { base in
            stat(base.assumingMemoryBound(to: CChar.self), &info)
        }
        if ret != 0 {
            return false
        }
        #if canImport(Darwin)
        let seconds = Int64(info.st_mtimespec.tv_sec)
        let nanoseconds = Int64(info.st_mtimespec.tv_nsec)
        #else
        let seconds = Int64(info.st_mtim.tv_sec)
        let nanoseconds = Int64(info.st_mtim.tv_nsec)
        #endif
        // A FILETIME counts 100-nanosecond steps from 1601, which is 11644473600 seconds before the POSIX epoch.
        let steps = UInt64(bitPattern: (seconds + 11_644_473_600) * 10_000_000 + nanoseconds / 100)
        ft.dwLowDateTime = UInt32(truncatingIfNeeded: steps)
        ft.dwHighDateTime = UInt32(truncatingIfNeeded: steps >> 32)
        return true
    }

    /// Raven's `_findfirst`, the first entry of a directory that matches the last part of `search`, or -1 when no entry matches.
    /// The last part of `search` is a pattern with `*` and `?`, which match without case as Win32 does.
    /// Source: oracle/codemp/null/win_main.cpp:451
    // AI: Raven called the Win32 CRT _findfirst. The backend reads the directory with the POSIX opendir and keeps the entries under the handle it returns.
    public static func _findfirst(_ search: CharBuf, _ findinfo: inout _finddata_t) -> Int32 {
        // A backslash is a path separator, as Win32 reads it.
        let path = String(String(search).map { $0 == "\\" ? "/" : $0 })
        let cut = path.lastIndex(of: "/")
        let directory = cut.map { String(path[..<$0]) } ?? "."
        let pattern = cut.map { String(path[path.index(after: $0)...]) } ?? path
        guard let dir = opendir(directory.isEmpty ? "/" : directory) else { return -1 }
        defer { closedir(dir) }
        var entries: [_finddata_t] = []
        while let entry = readdir(dir) {
            let name = withUnsafeBytes(of: entry.pointee.d_name) { raw in
                String(decoding: raw.prefix(while: { $0 != 0 }), as: UTF8.self)
            }
            if !self.wildcardMatch(Array(pattern.lowercased().utf8), Array(name.lowercased().utf8)) {
                continue
            }
            var info = stat()
            var found = _finddata_t()
            found.name = name
            if stat(directory + "/" + name, &info) == 0 && (info.st_mode & S_IFMT) == S_IFDIR {
                found.attrib = _A_SUBDIR
            }
            entries.append(found)
        }
        if entries.isEmpty {
            return -1
        }
        self.nextFindHandle += 1
        findinfo = entries[0]
        self.finds[self.nextFindHandle] = (entries, 1)
        return self.nextFindHandle
    }

    /// Raven's `_findnext`, the next entry of the handle, or -1 after the last entry.
    /// Source: oracle/codemp/null/win_main.cpp:476
    // AI: Raven called the Win32 CRT _findnext. The backend steps through the entries it kept at _findfirst.
    public static func _findnext(_ handle: Int32, _ findinfo: inout _finddata_t) -> Int32 {
        guard let find = self.finds[handle], find.next < find.entries.count else { return -1 }
        findinfo = find.entries[find.next]
        self.finds[handle] = (find.entries, find.next + 1)
        return 0
    }

    /// Raven's `_findclose`, which frees the entries of the handle.
    /// Source: oracle/codemp/null/win_main.cpp:478
    // AI: Raven called the Win32 CRT _findclose. The backend drops the entries it kept at _findfirst.
    @discardableResult
    public static func _findclose(_ handle: Int32) -> Int32 {
        return self.finds.removeValue(forKey: handle) == nil ? -1 : 0
    }

    /// The entries of each open find handle, and the next entry that _findnext gives.
    nonisolated(unsafe) private static var finds: [Int32: (entries: [_finddata_t], next: Int)] = [:]

    /// The last handle that _findfirst gave.
    nonisolated(unsafe) private static var nextFindHandle: Int32 = 0

    /// This matches a name against a Win32 pattern, where `*` matches any run of bytes and `?` matches one byte.
    private static func wildcardMatch(_ pattern: [UInt8], _ name: [UInt8]) -> Bool {
        var p = 0
        var n = 0
        var star = -1
        var mark = 0
        while n < name.count {
            if p < pattern.count && (pattern[p] == UInt8(ascii: "?") || pattern[p] == name[n]) {
                p += 1
                n += 1
            } else if p < pattern.count && pattern[p] == UInt8(ascii: "*") {
                star = p
                mark = n
                p += 1
            } else if star >= 0 {
                p = star + 1
                mark += 1
                n = mark
            } else {
                return false
            }
        }
        while p < pattern.count && pattern[p] == UInt8(ascii: "*") {
            p += 1
        }
        return p == pattern.count
    }

    /// Raven's `CopyFile( src, dest, FALSE )`, a copy of every byte that replaces the destination, false when a step fails.
    /// Source: oracle/codemp/qcommon/files_pc.cpp:948
    // AI: Raven called the Win32 CopyFile. The backend copies the bytes with the C library streams, the form of FileBackend.
    public static func CopyFile(_ lpExistingFileName: String, _ lpNewFileName: String, _ bFailIfExists: Bool) -> Bool {
        var source = CharBuf(lpExistingFileName)
        var dest = CharBuf(lpNewFileName)
        var readMode = CharBuf("rb")
        var writeMode = CharBuf(bFailIfExists ? "wbx" : "wb")
        let from = source.withUnsafeMutableRawPointer { name in
            readMode.withUnsafeMutableRawPointer { mode in
                fopen(name.assumingMemoryBound(to: CChar.self), mode.assumingMemoryBound(to: CChar.self))
            }
        }
        guard let from else { return false }
        defer { fclose(from) }
        let to = dest.withUnsafeMutableRawPointer { name in
            writeMode.withUnsafeMutableRawPointer { mode in
                fopen(name.assumingMemoryBound(to: CChar.self), mode.assumingMemoryBound(to: CChar.self))
            }
        }
        guard let to else { return false }
        var chunk = [UInt8](repeating: 0, count: 65536)
        var ok = true
        while ok {
            let count = chunk.withUnsafeMutableBytes { fread($0.baseAddress, 1, $0.count, from) }
            if count == 0 {
                ok = ferror(from) == 0
                break
            }
            let written = chunk.withUnsafeBytes { fwrite($0.baseAddress, 1, count, to) }
            ok = written == count
        }
        if fclose(to) != 0 {
            ok = false
        }
        return ok
    }

    /// Raven's `GetFileAttributes`, the attribute bits of a file, or 0xFFFFFFFF when the file does not exist.
    /// Source: oracle/codemp/qcommon/files_pc.cpp:950
    // AI: Raven called the Win32 GetFileAttributes. The backend gives FILE_ATTRIBUTE_READONLY from the owner write bit of the POSIX mode, or 0x80 for a plain file.
    public static func GetFileAttributes(_ lpFileName: String) -> UInt32 {
        var info = stat()
        var path = CharBuf(lpFileName)
        let ret = path.withUnsafeMutableRawPointer { base in
            stat(base.assumingMemoryBound(to: CChar.self), &info)
        }
        if ret != 0 {
            return 0xFFFF_FFFF
        }
        if (info.st_mode & S_IWUSR) == 0 {
            return FILE_ATTRIBUTE_READONLY
        }
        return 0x0000_0080
    }

    /// Raven's `SetFileAttributes`, which sets or clears the read-only state of a file, false when the call fails.
    /// Source: oracle/codemp/qcommon/files_pc.cpp:951
    // AI: Raven called the Win32 SetFileAttributes. The backend clears every write bit of the POSIX mode for FILE_ATTRIBUTE_READONLY, and sets the owner write bit for the rest.
    public static func SetFileAttributes(_ lpFileName: String, _ dwFileAttributes: UInt32) -> Bool {
        var info = stat()
        var path = CharBuf(lpFileName)
        return path.withUnsafeMutableRawPointer { base in
            let name = base.assumingMemoryBound(to: CChar.self)
            if stat(name, &info) != 0 {
                return false
            }
            var mode = info.st_mode
            if (dwFileAttributes & FILE_ATTRIBUTE_READONLY) != 0 {
                mode &= ~(S_IWUSR | S_IWGRP | S_IWOTH)
            } else {
                mode |= S_IWUSR
            }
            return chmod(name, mode) == 0
        }
    }

    /// The POSIX `sockaddr_in` of Raven's Winsock record, with the port and the address bytes as Raven stored them.
    private static func platformAddress(_ address: Sockaddr) -> sockaddr_in {
        var platform = sockaddr_in()
        #if canImport(Darwin)
        platform.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        #endif
        platform.sin_family = sa_family_t(PF_INET)
        platform.sin_port = address.sin_port
        platform.sin_addr.s_addr = in_addr_t(UInt32(bitPattern: address.sin_addr))
        return platform
    }
}

// MARK: - The C calls that a member of the same name hides

// Inside `SysBackend`, a member hides the C function of its name, so these forwards call the C library from file scope.

private func c_strerror(_ code: Int32) -> UnsafeMutablePointer<CChar>? {
    strerror(code)
}

private func c_bind(_ s: Int32, _ address: UnsafePointer<sockaddr>, _ length: socklen_t) -> Int32 {
    bind(s, address, length)
}

private func c_recvfrom(_ s: Int32, _ buf: UnsafeMutableRawPointer, _ len: Int, _ flags: Int32, _ from: UnsafeMutablePointer<sockaddr>, _ fromlen: UnsafeMutablePointer<socklen_t>) -> Int {
    recvfrom(s, buf, len, flags, from, fromlen)
}

private func c_sendto(_ s: Int32, _ data: UnsafeRawPointer, _ len: Int, _ flags: Int32, _ to: UnsafePointer<sockaddr>, _ tolen: socklen_t) -> Int {
    sendto(s, data, len, flags, to, tolen)
}

private func c_gethostname(_ name: UnsafeMutablePointer<CChar>, _ len: Int) -> Int32 {
    gethostname(name, len)
}

private func c_gethostbyname(_ name: UnsafePointer<CChar>) -> UnsafeMutablePointer<hostent>? {
    gethostbyname(name)
}

private func c_inet_addr(_ s: UnsafePointer<CChar>) -> UInt32 {
    UInt32(inet_addr(s))
}

private func c_connect(_ s: Int32, _ address: UnsafePointer<sockaddr>, _ length: socklen_t) -> Int32 {
    connect(s, address, length)
}

private func c_send(_ s: Int32, _ buf: UnsafeRawPointer, _ len: Int, _ flags: Int32) -> Int {
    send(s, buf, len, flags)
}

private func c_recv(_ s: Int32, _ buf: UnsafeMutableRawPointer, _ len: Int, _ flags: Int32) -> Int {
    recv(s, buf, len, flags)
}

/// The bytes of a C string as text, one byte for each scalar, through the codec of `CharBuf`.
private func cText(_ p: UnsafePointer<CChar>) -> String {
    String(CharBuf(bytes: Array(UnsafeBufferPointer(start: p, count: Int(strlen(p)))) + [0]))
}

// MARK: - The SOCKS buffers

extension CharBuf {
    /// The `int` at a byte offset of the buffer, Raven's `*(int *)&buf[4]` over a `char` array.
    // AI: Raven casts a `char` pointer to an `int` pointer. The subscript reads and writes the four bytes at the offset, the form of `Slots[int:]`.
    public subscript(int ofs: some BinaryInteger) -> Int32 {
        get {
            self.withUnsafeRawPointer { base in
                precondition(Int(ofs) >= 0 && Int(ofs) + 4 <= self.count, "CharBuf word past the end")
                return base.loadUnaligned(fromByteOffset: Int(ofs), as: Int32.self)
            }
        }
        set {
            precondition(Int(ofs) >= 0 && Int(ofs) + 4 <= self.count, "CharBuf word past the end")
            self.withUnsafeMutableRawPointer { base in
                base.storeBytes(of: newValue, toByteOffset: Int(ofs), as: Int32.self)
            }
        }
    }

    /// The `short` at a byte offset of the buffer, Raven's `*(short *)&buf[8]`, which holds a port in network order.
    /// The value is a `UInt16`, the type of `Sockaddr.sin_port` and of `SysBackend.htons`, so the two bytes move with no conversion.
    // AI: Raven casts a `char` pointer to a `short` pointer. The subscript reads and writes the two bytes at the offset, the form of `Slots[ushort:]`.
    public subscript(ushort ofs: some BinaryInteger) -> UInt16 {
        get {
            self.withUnsafeRawPointer { base in
                precondition(Int(ofs) >= 0 && Int(ofs) + 2 <= self.count, "CharBuf short past the end")
                return base.loadUnaligned(fromByteOffset: Int(ofs), as: UInt16.self)
            }
        }
        set {
            precondition(Int(ofs) >= 0 && Int(ofs) + 2 <= self.count, "CharBuf short past the end")
            self.withUnsafeMutableRawPointer { base in
                base.storeBytes(of: newValue, toByteOffset: Int(ofs), as: UInt16.self)
            }
        }
    }
}

/// Raven's `memcpy( &buf[offset], src, count )` from a text into a `char` array at a byte offset.
/// Source: oracle/codemp/win32/win_net.cpp:752
// AI: Raven copies into a pointer into the buffer. The function takes the buffer and the byte offset of that pointer, the form of `Com_Memset(_:_:_:at:)`.
public func memcpy(_ dest: inout CharBuf, _ src: CharBuf, _ count: some BinaryInteger, at offset: some BinaryInteger) {
    let start = Int(offset)
    let limit = Int(count)
    precondition(limit >= 0 && start >= 0 && start + limit <= dest.count && limit <= src.count, "memcpy: count past the end of the buffer")
    var index = 0
    while index < limit {
        dest[start + index] = src[index] as Int8
        index += 1
    }
}

/// Raven's `memcpy( &socksBuf[10], data, length )` from the bytes of a packet into a `char` array at a byte offset.
/// Source: oracle/codemp/win32/win_net.cpp:442
// AI: Raven copies into a pointer into the buffer. The function takes the buffer and the byte offset of that pointer, the form of `Com_Memset(_:_:_:at:)`.
public func memcpy(_ dest: inout CharBuf, _ src: Slots<byte>, _ count: some BinaryInteger, at offset: some BinaryInteger) {
    let start = Int(offset)
    let limit = Int(count)
    precondition(limit >= 0 && start >= 0 && start + limit <= dest.count && limit <= src.count, "memcpy: count past the end of the buffer")
    var index = 0
    while index < limit {
        dest[start + index] = src[index]
        index += 1
    }
}

// MARK: - Raven's address conversions

// The three functions below are Raven's bodies under Raven's names.
// The view target holds them, because the table has no row for their `struct sockaddr *`, so the logic file has no stub of these names.

/// Source: oracle/codemp/win32/win_net.cpp:97
public func NetadrToSockadr(_ a: Netadr, _ s: inout Sockaddr) {
    s = Sockaddr()

    if a.type == NA_BROADCAST {
        s.sin_family = SysBackend.AF_INET
        s.sin_port = UInt16(truncatingIfNeeded: a.port)
        s.sin_addr = SysBackend.INADDR_BROADCAST
    } else if a.type == NA_IP {
        s.sin_family = SysBackend.AF_INET
        s.sin_addr = a.ip[int: 0]
        s.sin_port = UInt16(truncatingIfNeeded: a.port)
    } else if a.type == NA_IPX {
        s.sa_family = SysBackend.AF_IPX
        s.sa_netnum = [a.ipx[0], a.ipx[1], a.ipx[2], a.ipx[3]]
        s.sa_nodenum = [a.ipx[4], a.ipx[5], a.ipx[6], a.ipx[7], a.ipx[8], a.ipx[9]]
        s.sa_socket = UInt16(truncatingIfNeeded: a.port)
    } else if a.type == NA_BROADCAST_IPX {
        s.sa_family = SysBackend.AF_IPX
        s.sa_netnum = [0, 0, 0, 0]
        s.sa_nodenum = [0xff, 0xff, 0xff, 0xff, 0xff, 0xff]
        s.sa_socket = UInt16(truncatingIfNeeded: a.port)
    }
}

/// Source: oracle/codemp/win32/win_net.cpp:127
public func SockadrToNetadr(_ s: Sockaddr, _ a: Netadr) {
    if s.sa_family == SysBackend.AF_INET {
        a.type = NA_IP
        a.ip[int: 0] = s.sin_addr
        a.port = Int32(s.sin_port)
    } else if s.sa_family == SysBackend.AF_IPX {
        a.type = NA_IPX
        for i in 0..<4 {
            a.ipx[i] = s.sa_netnum[i]
        }
        for i in 0..<6 {
            a.ipx[4 + i] = s.sa_nodenum[i]
        }
        a.port = Int32(s.sa_socket)
    }
}

/// Source: oracle/codemp/win32/win_net.cpp:160
@discardableResult
public func Sys_StringToSockaddr(_ s: String, _ sadr: inout Sockaddr) -> Bool {
    let s = CharBuf(s)
    var val: Int32 = 0
    var copy = CharBuf(JKAShared.MAX_STRING_CHARS)

    /// Raven's `DO(src,dest)` macro of win_net.cpp:153, the byte of the two hex digits at `src`.
    /// Source: oracle/codemp/win32/win_net.cpp:153
    func DO(_ src: Int32) -> UInt8 {
        copy[0] = s[src] as Int8
        copy[1] = s[src + 1] as Int8
        // AI: Raven read the two digits with sscanf "%x", which keeps the old value on a failure. The parse keeps it the same way.
        if let parsed = Int32(String(copy), radix: 16) {
            val = parsed
        }
        return UInt8(truncatingIfNeeded: val)
    }

    sadr = Sockaddr()

    // check for an IPX address
    if (strlen(s) == 21) && (s[8] == Int32(ascii: ".")) {
        sadr.sa_family = SysBackend.AF_IPX
        sadr.sa_socket = 0
        copy[2] = 0
        sadr.sa_netnum = [DO(0), DO(2), DO(4), DO(6)]
        sadr.sa_nodenum = [DO(9), DO(11), DO(13), DO(15), DO(17), DO(19)]
    } else {
        sadr.sin_family = SysBackend.AF_INET
        sadr.sin_port = 0

        if s[0] >= Int32(ascii: "0") && s[0] <= Int32(ascii: "9") {
            sadr.sin_addr = SysBackend.inet_addr(String(s))
        } else {
            guard let h = SysBackend.gethostbyname(String(s)), let address = h.h_addr_list.first else { // NOT SUPPORTED ON XBOX!
                return false
            }
            sadr.sin_addr = Int32(bitPattern: UInt32(address[0]) | UInt32(address[1]) << 8 | UInt32(address[2]) << 16 | UInt32(address[3]) << 24)
        }
    }

    return true
}
