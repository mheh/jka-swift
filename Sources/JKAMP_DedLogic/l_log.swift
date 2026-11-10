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
        // Port-note: botimport.Print takes Raven's format as an OpaquePointer and has no arguments, so no call can pass his text, row BL1.
        // Raven wrote: botimport.Print(PRT_MESSAGE, "openlog <filename>\n")
        portMissing("Log_Open", source: "oracle/codemp/botlib/l_log.cpp:41")
        return
    } //end if
    if logfile.fp != nil {
        // Port-note: botimport.Print takes Raven's format as an OpaquePointer and has no arguments, so no call can pass his text, row BL1.
        // Raven wrote: botimport.Print(PRT_ERROR, "log file %s is already opened\n", logfile.filename)
        portMissing("Log_Open", source: "oracle/codemp/botlib/l_log.cpp:41")
        return
    } //end if
    logfile.fp = FileBackend.fopen(String(filename), "wb")
    if logfile.fp == nil {
        // Port-note: botimport.Print takes Raven's format as an OpaquePointer and has no arguments, so no call can pass his text, row BL1.
        // Raven wrote: botimport.Print(PRT_ERROR, "can't open the log file %s\n", filename)
        portMissing("Log_Open", source: "oracle/codemp/botlib/l_log.cpp:41")
        return
    } //end if
    strncpy(&logfile.filenameBuffer, String(filename), MAX_LOGFILENAMESIZE)
    // Port-note: botimport.Print takes Raven's format as an OpaquePointer and has no arguments, so no call can pass his text, row BL1.
    // Raven wrote: botimport.Print(PRT_MESSAGE, "Opened log %s\n", logfile.filename)
    portMissing("Log_Open", source: "oracle/codemp/botlib/l_log.cpp:41")
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
        // Port-note: botimport.Print takes Raven's format as an OpaquePointer and has no arguments, so no call can pass his text, row BL1.
        // Raven wrote: botimport.Print(PRT_ERROR, "can't close log file %s\n", logfile.filename)
        portMissing("Log_Close", source: "oracle/codemp/botlib/l_log.cpp:69")
        return
    } //end if
    logfile.fp = nil
    // Port-note: botimport.Print takes Raven's format as an OpaquePointer and has no arguments, so no call can pass his text, row BL1.
    // Raven wrote: botimport.Print(PRT_MESSAGE, "Closed log %s\n", logfile.filename)
    portMissing("Log_Close", source: "oracle/codemp/botlib/l_log.cpp:69")
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
func Log_Write(_ fmt: inout JKAShared.CharBuf, _ args: any JKAShared.FormatArg...) {
    if logfile.fp == nil { return }
    // Port-note: FileBackend has no vfprintf, so no call writes the formatted text to the stream, row BL2.
    // Raven wrote: vfprintf(logfile.fp, fmt, ap)
    portMissing("Log_Write", source: "oracle/codemp/botlib/l_log.cpp:96")
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
func Log_WriteTimeStamped(_ fmt: inout JKAShared.CharBuf, _ args: any JKAShared.FormatArg...) {
    if logfile.fp == nil { return }
    // Port-note: FileBackend has no fprintf or vfprintf, so no call writes the formatted text to the stream, row BL2.
    // Raven wrote: fprintf(logfile.fp, "%d   %02d:%02d:%02d:%02d   ", logfile.numwrites, (int) (botlibglobals.time / 60 / 60), (int) (botlibglobals.time / 60), (int) (botlibglobals.time), (int) ((int) (botlibglobals.time * 100)) - ((int) botlibglobals.time) * 100)
    // Raven wrote: vfprintf(logfile.fp, fmt, ap)
    // Raven wrote: fprintf(logfile.fp, "\r\n")
    portMissing("Log_WriteTimeStamped", source: "oracle/codemp/botlib/l_log.cpp:113")
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
