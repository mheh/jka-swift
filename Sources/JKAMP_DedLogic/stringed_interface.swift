import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/stringed_interface.cpp:131
var giFilesFound: Int32 {
    get { world.variables.giFilesFound }
    set { world.variables.giFilesFound = newValue }
}

// this just gets the binary of the file into memory, so I can parse it. Called by main SGE loader
//
//  returns either char * of loaded file, else NULL for failed-to-open...
//
/// Source: oracle/codemp/qcommon/stringed_interface.cpp:41
func SE_LoadFileData(_ psFileName: String, _ piLoadedLength: inout Int32) -> Slots<JKAShared.byte>? {
    // TODO: Port SE_LoadFileData
    portMissing("SE_LoadFileData", source: "oracle/codemp/qcommon/stringed_interface.cpp:41")
}

// called by main SGE code after loaded data has been parsedinto internal structures...
//
/// Source: oracle/codemp/qcommon/stringed_interface.cpp:109
// Port-note: Row S2. FS_FreeFile has no overload for the `Slots` of the loaded bytes, so the free waits for the form of SE_LoadFileData.
func SE_FreeFileDataAfterLoad(_ psLoadedFile: Slots<UInt8>) {
    // TODO: Port SE_FreeFileDataAfterLoad
    portMissing("SE_FreeFileDataAfterLoad", source: "oracle/codemp/qcommon/stringed_interface.cpp:109")
}

/// Source: oracle/codemp/qcommon/stringed_interface.cpp:132
private func SE_R_ListFiles(_ psExtension: String, _ psDir: String, _ strResults: inout String) {
    // TODO: Port SE_R_ListFiles
    portMissing("SE_R_ListFiles", source: "oracle/codemp/qcommon/stringed_interface.cpp:132")
}

// replace this with a call to whatever your own code equivalent is.
//
// expected result is a ';'-delineated string (including last one) containing file-list search results
//
/// Source: oracle/codemp/qcommon/stringed_interface.cpp:192
func SE_BuildFileList(_ psStartDir: String, _ strResults: inout String) -> Int32 {
    // TODO: Port SE_BuildFileList
    portMissing("SE_BuildFileList", source: "oracle/codemp/qcommon/stringed_interface.cpp:192")
}
