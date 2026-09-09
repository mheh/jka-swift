import Foundation
import JKAShared

/// This serializes access to the one process-wide `Syscall.transport` for tests that install a fake one.
/// Swift Testing runs suites concurrently, so two suites can race on the same global without this lock.
private let transportLock = NSLock()

/// This installs `transport` on `Syscall.transport`, runs `body`, and clears the transport before it unlocks.
/// The lock holds for the whole call, so no other test observes a partial or a wrong transport.
public func withTransport<T>(_ transport: SyscallTransport, _ body: () throws -> T) rethrows -> T {
    transportLock.lock()
    defer {
        Syscall.transport = nil
        transportLock.unlock()
    }
    Syscall.transport = transport
    return try body()
}

/// This runs `body` with `Syscall.transport` nil, under the same lock as `withTransport`.
/// A test asserts the empty state with this, so no installed transport of another suite leaks in.
public func withoutTransport<T>(_ body: () throws -> T) rethrows -> T {
    transportLock.lock()
    defer {
        Syscall.transport = nil
        transportLock.unlock()
    }
    Syscall.transport = nil
    return try body()
}
