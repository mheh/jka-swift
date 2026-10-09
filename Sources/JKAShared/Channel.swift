/// The error and print route of the shared files, in the bg shape of rule 23.
/// The game module installs both closures at `dllEntry`, beside the bg channel, so the shared files reach the game's `Com_Error` and `Com_Printf`.
public final class SharedChannel {
    // MARK: - State

    /// The game module installs its own `Com_Error` at `dllEntry`.
    /// The default ends the process with Raven's text, as the engine would.
    public var error: (Int32, String) -> Never = { level, text in
        fatalError("Com_Error(\(level)): \(text)")
    }

    /// The game module installs its own `Com_Printf` at `dllEntry`.
    /// The default writes the text to standard output.
    public var print: (String) -> Void = { text in
        Swift.print(text, terminator: "")
    }

    public init() {}
}

/// The one instance. The engine calls the module from one thread, so this is not isolated.
public nonisolated(unsafe) var sharedChannel = SharedChannel()

/// This is Raven's `Com_Error` as the shared files call it.
/// The module supplies the route through `sharedChannel.error`.
/// Source: oracle/codemp/game/g_main.c:1208
public func Com_Error(_ level: Int32, _ text: String, _ args: any FormatArg...) -> Never {
    sharedChannel.error(level, format(text, args))
}

/// This is Raven's `Com_Printf` as the shared files call it.
/// The module supplies the route through `sharedChannel.print`.
/// Source: oracle/codemp/game/g_main.c:1219
public func Com_Printf(_ text: String, _ args: any FormatArg...) {
    sharedChannel.print(format(text, args))
}
