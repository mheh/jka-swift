// The entry point of the dedicated server, Raven's WinDed binary.
// It prints the version line of Com_Init and exits, because the Com_Init and Com_Frame ports land in a later stage.
// Source: oracle/codemp/null/win_main.cpp:1410

/// The version of the MP game, from the arm of a build without FINAL_BUILD and _DEBUG, as WinDed Release is.
/// Source: oracle/codemp/qcommon/game_version.h:11, with VERSION_STRING_DOTTED from oracle/codemp/win32/AutoVersion.h:10
let Q3_VERSION = "(internal)JAmp: v1.0.1.0"

/// The platform name of the version line.
#if os(macOS)
/// Source: oracle/codemp/game/q_shared.h:197
let CPUSTRING = "MacOSX-other"
#elseif os(Linux)
/// Source: oracle/codemp/game/q_shared.h:276
let CPUSTRING = "linux-other"
#else
/// Port-note: Raven defined no CPUSTRING for a 64-bit Windows build, so the build failed there.
/// This is the value of Raven's x86 arm at oracle/codemp/game/q_shared.h:157.
let CPUSTRING = "win-x86"
#endif

// Source: oracle/codemp/qcommon/common.cpp:1219
// AI: Raven printed the compile date from __DATE__ after CPUSTRING. Swift has no compile date, so the line ends at CPUSTRING.
print("\(Q3_VERSION) \(CPUSTRING)")
