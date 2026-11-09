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
    var psReturn: Slots<JKAShared.byte>? = nil
    // Raven's `if ( piLoadedLength )` test has no path here, because an `inout` length is never NULL.
    piLoadedLength = 0

    // local filename, so prepend the base dir etc according to game and load it however (from PAK?)
    //
    var pvLoadedData: OpaquePointer? = nil
    let iLen = FS_ReadFile(psFileName, &pvLoadedData)

    if iLen > 0 {
        // AI: Raven returns the `unsigned char *` of the block. The return is a Slots over the `iLen` bytes and the NUL that FS_ReadFile puts after them.
        psReturn = ZipBackend.bytes(pvLoadedData, count: iLen + 1)
        piLoadedLength = iLen
    }

    return psReturn
}

// called by main SGE code after loaded data has been parsedinto internal structures...
//
/// Source: oracle/codemp/qcommon/stringed_interface.cpp:109
func SE_FreeFileDataAfterLoad(_ psLoadedFile: Slots<UInt8>) {
    // Raven's `if ( psLoadedFile )` test has no path here, because the Slots is never NULL.
    FS_FreeFile(psLoadedFile)
}

/// Source: oracle/codemp/qcommon/stringed_interface.cpp:132
private func SE_R_ListFiles(_ psExtension: String, _ psDir: String, _ strResults: inout String) {
    //	Com_Printf(va("Scanning Dir: %s\n",psDir));

    let sysFiles: [String]
    let dirFiles: [String]
    var numSysFiles: Int32 = 0
    var i: Int32
    var numdirs: Int32 = 0

    dirFiles = FS_ListFiles(psDir, "/", &numdirs)
    i = 0
    while i < numdirs {
        if CharBuf(dirFiles[i])[0] != 0 && CharBuf(dirFiles[i])[0] != Int32(ascii: ".") { // skip blanks, plus ".", ".." etc
            var sDirName = CharBuf(MAX_QPATH)
            // AI: Raven formats with `sprintf`, which has no size. The format writes into the buffer of MAX_QPATH bytes with Com_sprintf.
            Com_sprintf(&sDirName, Int32(sDirName.count), "%s/%s", psDir, dirFiles[i])
            //
            // for some reason the quake filesystem in this game now returns an extra slash on the end,
            //	didn't used to. Sigh...
            //
            if sDirName[strlen(sDirName) - 1] == Int32(ascii: "/") {
                sDirName[strlen(sDirName) - 1] = 0
            }
            SE_R_ListFiles(psExtension, String(sDirName), &strResults)
        }
        i += 1
    }

    sysFiles = FS_ListFiles(psDir, psExtension, &numSysFiles)
    i = 0
    while i < numSysFiles {
        var sFilename = CharBuf(MAX_QPATH)
        // AI: Raven formats with `sprintf`, which has no size. The format writes into the buffer of MAX_QPATH bytes with Com_sprintf.
        Com_sprintf(&sFilename, Int32(sFilename.count), "%s/%s", psDir, sysFiles[i])

        //		Com_Printf("%sFound file: %s",!i?"\n":"",sFilename);

        strResults += String(sFilename)
        strResults += ";"
        giFilesFound += 1

        // read it in...
        //
        /*		byte *pbData = NULL;
                int iSize = FS_ReadFile( sFilename, (void **)&pbData);

                if (pbData)
                {

                    FS_FreeFile( pbData );
                }
        */
        i += 1
    }
    FS_FreeFileList(sysFiles)
    FS_FreeFileList(dirFiles)
}

// replace this with a call to whatever your own code equivalent is.
//
// expected result is a ';'-delineated string (including last one) containing file-list search results
//
/// Source: oracle/codemp/qcommon/stringed_interface.cpp:192
@discardableResult
func SE_BuildFileList(_ psStartDir: String, _ strResults: inout String) -> Int32 {
    giFilesFound = 0
    strResults = ""

    SE_R_ListFiles(sSE_INGAME_FILE_EXTENSION, psStartDir, &strResults)

    return giFilesFound
}
