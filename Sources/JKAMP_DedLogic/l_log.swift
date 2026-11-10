import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/botlib/l_log.cpp:24
private let MAX_LOGFILENAMESIZE = 1024 as Int32

/// Source: oracle/codemp/botlib/l_log.cpp:33
private var logfile: Logfile { world.storage.l_log_logfile }

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_log.cpp:41
func Log_Open(_ filename: inout JKAShared.CharBuf) {
    if LibVarValue("log", "0") == 0 { return }
    if strlen(filename) == 0 {
        botimport.runPrint(PRT_MESSAGE, "openlog <filename>\n")
        return
    } //end if
    if logfile.fp != nil {
        botimport.runPrint(PRT_ERROR, "log file %s is already opened\n", logfile.filename)
        return
    } //end if
    logfile.fp = FileBackend.fopen(String(filename), "wb")
    if logfile.fp == nil {
        botimport.runPrint(PRT_ERROR, "can't open the log file %s\n", String(filename))
        return
    } //end if
    strncpy(&logfile.filenameBuffer, String(filename), MAX_LOGFILENAMESIZE)
    botimport.runPrint(PRT_MESSAGE, "Opened log %s\n", logfile.filename)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_log.cpp:69
func Log_Close() {
    if logfile.fp == nil { return }
    if FileBackend.fclose(logfile.fp) != 0 {
        botimport.runPrint(PRT_ERROR, "can't close log file %s\n", logfile.filename)
        return
    } //end if
    logfile.fp = nil
    botimport.runPrint(PRT_MESSAGE, "Closed log %s\n", logfile.filename)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_log.cpp:86
func Log_Shutdown() {
    if logfile.fp != nil { Log_Close() }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_log.cpp:96
func Log_Write(_ fmt: String, _ args: any JKAShared.FormatArg...) {
    if logfile.fp == nil { return }
    // AI: Raven prints with vfprintf to the stream. The text formats with JKAShared.format, and FileBackend.fwrite writes its bytes.
    let text = CharBuf(JKAShared.format(fmt, args))
    _ = FileBackend.fwrite(text, at: 0, 1, strlen(text), logfile.fp)
    //fprintf(logfile.fp, "\r\n");
    FileBackend.fflush(logfile.fp)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_log.cpp:113
func Log_WriteTimeStamped(_ fmt: String, _ args: any JKAShared.FormatArg...) {
    if logfile.fp == nil { return }
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // AI: Raven prints with fprintf, vfprintf, and fprintf to the stream. Each text formats with JKAShared.format, and FileBackend.fwrite writes its bytes.
    var text = CharBuf(JKAShared.format("%d   %02d:%02d:%02d:%02d   ", [
        logfile.numwrites,
        Int32(botlibglobals.time / 60 / 60),
        Int32(botlibglobals.time / 60),
        Int32(botlibglobals.time),
        Int32(botlibglobals.time * 100) - Int32(botlibglobals.time) * 100,
    ]))
    _ = FileBackend.fwrite(text, at: 0, 1, strlen(text), logfile.fp)
    text = CharBuf(JKAShared.format(fmt, args) + "\r\n")
    _ = FileBackend.fwrite(text, at: 0, 1, strlen(text), logfile.fp)
    logfile.numwrites += 1
    FileBackend.fflush(logfile.fp)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_log.cpp:138
func Log_FilePointer() -> OpaquePointer? {
    return logfile.fp
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_log.cpp:148
func Log_Flush() {
    if logfile.fp != nil { FileBackend.fflush(logfile.fp) }
}
