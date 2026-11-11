import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:41
public var se_language: JKAMP.Cvar? {
    get { world.variables.se_language }
    set { world.variables.se_language = newValue }
}

/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:42
public var se_debug: JKAMP.Cvar? {
    get { world.variables.se_debug }
    set { world.variables.se_debug = newValue }
}

/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:43
public var sp_leet: JKAMP.Cvar? {
    get { world.variables.sp_leet }
    set { world.variables.sp_leet = newValue }
}

/// Raven's string entry of the StringEd package: the text, the debug text, and the flag bits of one reference.
/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:48
// AI: Raven declares two `std::string` fields. The struct holds them as `String`, by the C++ docket.
struct SE_Entry_t {
    var m_strString: String = ""
    var m_strDebug: String = ""	// english and/or "#same", used for debugging only. Also prefixed by "SE:" to show which strings go through StringEd (ie aren't hardwired)
    var m_iFlags: Int32 = 0
}

/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:62
// AI: Raven keys a `std::map` by the reference. The table is a Dictionary, by row C6 of the C++ docket.
typealias mapStringEntries_t = [String: SE_Entry_t]

/// Raven's StringEd package, the string table of every loaded `.str` file and the flag names of its entries.
/// One instance exists, `TheStringPackage` on `EngineWorld`, and every `SE_` function reads it.
/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:64
// AI: Raven declares a C++ class with one global instance. The class is a final class on EngineWorld, so a method changes the one table in place.
final class CStringEdPackage {
    private var m_bEndMarkerFound_ParseOnly: Bool = false
    private var m_strCurrentEntryRef_ParseOnly: String = ""
    private var m_strCurrentEntryEnglish_ParseOnly: String = ""
    private var m_strCurrentFileRef_ParseOnly: String = ""
    private var m_strLoadingLanguage_ParseOnly: String = ""	// eg "german"
    private var m_bLoadingEnglish_ParseOnly: Bool = false

    var m_StringEntries: mapStringEntries_t = [:]	// needs to be in public space now
    var m_bLoadDebug: Bool = false		// ""
    //
    // flag stuff...
    //
    // AI: Raven holds a `vector<string>` and a `map<string,int>`. The fields are an Array and a Dictionary, by the C++ docket.
    var m_vstrFlagNames: [String] = []
    var m_mapFlagMasks: [String: Int32] = [:]

    /// Source: oracle/codemp/qcommon/stringed_ingame.cpp:77
    init() {
        self.Clear(false)
    }

    /// Source: oracle/codemp/qcommon/stringed_ingame.cpp:82
    deinit {
        self.Clear(false)
    }

    /// Source: oracle/codemp/qcommon/stringed_ingame.cpp:101
    func EndMarkerFoundDuringParse() -> Bool {
        return self.m_bEndMarkerFound_ParseOnly
    }
}

/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:124
var TheStringPackage: CStringEdPackage { world.TheStringPackage }

// MARK: - The package methods before CopeWithDumbStringData

extension CStringEdPackage {
    /// Source: oracle/codemp/qcommon/stringed_ingame.cpp:127
    func Clear(_ bChangingLanguages: Bool) {
        self.m_StringEntries.removeAll()

        if !bChangingLanguages {
            // if we're changing languages, then I'm going to leave these alone. This is to do with any (potentially) cached
            //	flag bitmasks on the game side. It shouldn't matter since all files are written out at once using the build
            //	command in StringEd. But if ever someone changed a file by hand, or added one, or whatever, and it had a
            //	different set of flags declared, or the strings were in a different order, then the flags might also change
            //	the order I see them in, and hence their indexes and masks. This should never happen unless people mess with
            //	the .STR files by hand and delete some, but this way makes sure it'll all work just in case...
            //
            // ie. flags stay defined once they're defined, and only the destructor (at app-end) kills them.
            //
            self.m_vstrFlagNames.removeAll()
            self.m_mapFlagMasks.removeAll()
        }

        self.m_bEndMarkerFound_ParseOnly = false
        self.m_strCurrentEntryRef_ParseOnly = ""
        self.m_strCurrentEntryEnglish_ParseOnly = ""
        //
        // the other vars are cleared in SetupNewFileParse(), and are ok to not do here.
        //
    }

    // loses anything after the path (if any), (eg) "dir/name.bmp" becomes "dir"
    // (copes with either slash-scheme for names)
    //
    // (normally I'd call another function for this, but this is supposed to be engine-independant,
    //	 so a certain amount of re-invention of the wheel is to be expected...)
    //
    /// Source: oracle/codemp/qcommon/stringed_ingame.cpp:162
    // AI: Raven fills a static buffer and returns it. The method fills a local buffer of the same bound and returns its String, by rule 7.
    private func Filename_PathOnly(_ psFilename: String) -> String {
        var sString = CharBuf(iSE_MAX_FILENAME_LENGTH)

        strcpy(&sString, psFilename)

        let p1 = strrchr(sString, Int32(ascii: "\\"))
        let p2 = strrchr(sString, Int32(ascii: "/"))
        // A NULL pointer compares below every pointer into the buffer.
        let p = (p1 ?? -1) > (p2 ?? -1) ? p1 : p2
        if let p {
            sString[p] = 0
        }

        return String(sString)
    }

    // returns (eg) "dir/name" for "dir/name.bmp"
    // (copes with either slash-scheme for names)
    //
    // (normally I'd call another function for this, but this is supposed to be engine-independant,
    //	 so a certain amount of re-invention of the wheel is to be expected...)
    //
    /// Source: oracle/codemp/qcommon/stringed_ingame.cpp:184
    // AI: Raven fills a static buffer and returns it. The method fills a local buffer of the same bound and returns its String, by rule 7.
    private func Filename_WithoutExt(_ psFilename: String) -> String {
        var sString = CharBuf(iSE_MAX_FILENAME_LENGTH)

        strcpy(&sString, psFilename)

        let p = strrchr(sString, Int32(ascii: "."))
        let p2 = strrchr(sString, Int32(ascii: "\\"))
        let p3 = strrchr(sString, Int32(ascii: "/"))

        // special check, make sure the first suffix we found from the end wasn't just a directory suffix (eg on a path'd filename with no extension anyway)
        //
        if p != nil &&
            (p2 == nil || (p2 != nil && p! > p2!)) &&
            (p3 == nil || (p3 != nil && p! > p3!))
        {
            sString[p!] = 0
        }

        return String(sString)
    }

    // returns actual filename only, no path
    // (copes with either slash-scheme for names)
    //
    // (normally I'd call another function for this, but this is supposed to be engine-independant,
    //	 so a certain amount of re-invention of the wheel is to be expected...)
    //
    /// Source: oracle/codemp/qcommon/stringed_ingame.cpp:211
    // AI: Raven fills a static buffer and returns it. The method fills a local buffer of the same bound and returns its String, by rule 7.
    private func Filename_WithoutPath(_ psFilename: String) -> String {
        var sString = CharBuf(iSE_MAX_FILENAME_LENGTH)

        // Raven steps his own `psFilename` parameter through its bytes, so the body walks an index over a copy of them.
        let psFilename = CharBuf(psFilename)
        var iFilename: Int32 = 0
        var psCopyPos: Int32 = 0

        while psFilename[iFilename] != 0 {
            if psFilename[iFilename] == Int32(ascii: "/") || psFilename[iFilename] == Int32(ascii: "\\") {
                psCopyPos = iFilename + 1
            }
            iFilename += 1
        }

        strcpy(&sString, psFilename[psCopyPos...])

        return String(sString)
    }

    /// Source: oracle/codemp/qcommon/stringed_ingame.cpp:230
    func ExtractLanguageFromPath(_ psFileName: String) -> String {
        return self.Filename_WithoutPath(self.Filename_PathOnly(psFileName))
    }

    /// Source: oracle/codemp/qcommon/stringed_ingame.cpp:236
    func SetupNewFileParse(_ psFileName: String, _ bLoadDebug: Bool) {
        var sString = CharBuf(iSE_MAX_FILENAME_LENGTH)

        strcpy(&sString, self.Filename_WithoutPath(self.Filename_WithoutExt(psFileName)))
        Q_strupr(&sString)

        self.m_strCurrentFileRef_ParseOnly = String(sString)	// eg "OBJECTIVES"
        self.m_strLoadingLanguage_ParseOnly = self.ExtractLanguageFromPath(psFileName)
        self.m_bLoadingEnglish_ParseOnly = (stricmp(self.m_strLoadingLanguage_ParseOnly, "english") == 0) ? true : false
        self.m_bLoadDebug = bLoadDebug
    }

    // returns SE_TRUE if supplied keyword found at line start (and advances supplied ptr past any whitespace to next arg (or line end if none),
    //
    //	else returns SE_FALSE...
    //
    /// Source: oracle/codemp/qcommon/stringed_ingame.cpp:254
    private func CheckLineForKeyword(_ psKeyword: String, _ psLine: inout TextCursor) -> Bool {
        if Q_stricmpn(psKeyword, psLine.text, strlen(psKeyword)) == 0 {
            psLine.advance(by: strlen(psKeyword))

            // skip whitespace to arrive at next item...
            //
            while psLine.byte == Int32(ascii: "\t") || psLine.byte == Int32(ascii: " ") {
                psLine.advance()
            }
            return true
        }

        return false
    }

    // change "\n" to '\n' (i.e. 2-byte char-string to 1-byte ctrl-code)...
    //  (or "\r\n" in editor)
    //
    /// Source: oracle/codemp/qcommon/stringed_ingame.cpp:275
    // AI: Raven keeps the text in a static std::string and returns its c_str. The method keeps it in a local String and returns it, by row C6.
    private func ConvertCRLiterals_Read(_ psString: String) -> String {
        var str = psString
        while let iLoc = str.range(of: "\\n") {
            str.replaceSubrange(iLoc, with: "\n")
        }

        return str
    }

    // kill off any "//" onwards part in the line, but NOT if it's inside a quoted string...
    //
    /// Source: oracle/codemp/qcommon/stringed_ingame.cpp:292
    private func REMKill(_ psBuffer: inout CharBuf) {
        var psScanPos: Int32 = 0
        var iDoubleQuotesSoFar: Int32 = 0

        // scan forwards in case there are more than one (and the first is inside quotes)...
        //
        while let found = strstr(psBuffer[psScanPos...], "//") {
            let p = psScanPos + found
            // count the number of double quotes before this point, if odd number, then we're inside quotes...
            //
            var iDoubleQuoteCount = iDoubleQuotesSoFar

            var i: Int32 = 0
            while i < p - psScanPos {
                if psBuffer[psScanPos + i] == Int32(ascii: "\"") {
                    iDoubleQuoteCount += 1
                }
                i += 1
            }
            if (iDoubleQuoteCount & 1) == 0 {
                // not inside quotes, so kill line here...
                //
                psBuffer[p] = 0
                //
                // and remove any trailing whitespace...
                //
                if psBuffer[psScanPos] != 0 {	// any strlen? (else access violation with -1 below)
                    var iWhiteSpaceScanPos = strlen(psBuffer[psScanPos...]) - 1
                    while iWhiteSpaceScanPos >= 0 && isspace(psBuffer[psScanPos + iWhiteSpaceScanPos]) != 0 {
                        psBuffer[psScanPos + iWhiteSpaceScanPos] = 0
                        iWhiteSpaceScanPos -= 1
                    }
                }

                return
            } else {
                // inside quotes (blast), oh well, skip past and keep scanning...
                //
                psScanPos = p + 1
                iDoubleQuotesSoFar = iDoubleQuoteCount
            }
        }
    }

    // returns true while new lines available to be read...
    //
    /// Source: oracle/codemp/qcommon/stringed_ingame.cpp:344
    func ReadLine(_ psParsePos: inout TextCursor, _ psDest: inout CharBuf) -> Bool {
        if psParsePos[0] != 0 {
            if let psLineEnd = strchr(psParsePos.buf[psParsePos.offset!...], Int32(ascii: "\n")) {
                let iCharsToCopy = psLineEnd
                strncpy(&psDest, psParsePos.buf[psParsePos.offset!...], iCharsToCopy)
                psDest[iCharsToCopy] = 0
                psParsePos.advance(by: iCharsToCopy)
                while psParsePos.byte != 0 && strchr("\r\n", psParsePos.byte) != nil {
                    psParsePos.advance()	// skip over CR or CR/LF pairs
                }
            } else {
                // last line...
                //
                strcpy(&psDest, psParsePos.buf[psParsePos.offset!...])
                psParsePos.advance(by: strlen(psParsePos.buf[psParsePos.offset!...]))
            }

            // clean up the line...
            //
            if psDest[0] != 0 {
                var iWhiteSpaceScanPos = strlen(psDest) - 1
                while iWhiteSpaceScanPos >= 0 && isspace(psDest[iWhiteSpaceScanPos]) != 0 {
                    psDest[iWhiteSpaceScanPos] = 0
                    iWhiteSpaceScanPos -= 1
                }

                self.REMKill(&psDest)
            }
            return true
        }

        return false
    }

    // remove any outside quotes from this supplied line, plus any leading or trailing whitespace...
    //
    /// Source: oracle/codemp/qcommon/stringed_ingame.cpp:388
    // AI: Raven keeps the text in a static std::string and returns its c_str. The method keeps it in a local String and returns it, by row C6.
    private func InsideQuotes(_ psLine: String) -> String {
        // I *could* replace this string object with a declared array, but wasn't sure how big to leave it, and it'd have to
        //	be static as well, hence permanent. (problem on consoles?)
        //
        var str = ""	// do NOT join to above line

        // Raven steps his own `psLine` parameter through its bytes, so the body walks a TextCursor over a copy of them.
        var psLine = TextCursor(CharBuf(psLine))

        // skip any leading whitespace...
        //
        while psLine.byte == Int32(ascii: " ") || psLine.byte == Int32(ascii: "\t") {
            psLine.advance()
        }

        // skip any leading quote...
        //
        if psLine.byte == Int32(ascii: "\"") {
            psLine.advance()
        }

        // assign it...
        //
        str = psLine.text

        if psLine[0] != 0 {
            // lose any trailing whitespace...
            //
            // Port-note: Raven reads the byte before the text when every byte is a space or a tab.
            // The test stops at an empty text.
            while !str.isEmpty && (str.unicodeScalars.last == " " || str.unicodeScalars.last == "\t") {
                str.unicodeScalars.removeLast()
            }

            // lose any trailing quote...
            //
            if str.unicodeScalars.last == "\"" {
                str.unicodeScalars.removeLast()
            }
        }

        // and return it...
        //
        return str
    }

    // returns flag bitmask (eg 00000010b), else 0 for not found
    //
    /// Source: oracle/codemp/qcommon/stringed_ingame.cpp:441
    func GetFlagMask(_ psFlagName: String) -> Int32 {
        if let iMask = self.m_mapFlagMasks[psFlagName] {
            return iMask
        }

        return 0
    }

    /// Source: oracle/codemp/qcommon/stringed_ingame.cpp:454
    private func AddFlagReference(_ psLocalReference: String, _ psFlagName: String) {
        // add the flag to the list of known ones...
        //
        var iMask = self.GetFlagMask(psFlagName)
        if iMask == 0 {
            self.m_vstrFlagNames.append(psFlagName)
            iMask = 1 << (self.m_vstrFlagNames.count - 1)
            self.m_mapFlagMasks[psFlagName] = iMask
        }
        //
        // then add the reference to this flag to the currently-parsed reference...
        //
        // AI: Raven changes the entry through a reference into the map. The method changes it through the Dictionary subscript.
        if self.m_StringEntries[va("%s_%s", self.m_strCurrentFileRef_ParseOnly, psLocalReference)] != nil {
            self.m_StringEntries[va("%s_%s", self.m_strCurrentFileRef_ParseOnly, psLocalReference)]!.m_iFlags |= iMask
        }
    }
}

// this copes with both foreigners using hi-char values (eg the french using 0x92 instead of 0x27
//  for a "'" char), as well as the fact that our buggy fontgen program writes out zeroed glyph info for
//	some fonts anyway (though not all, just as a gotcha).
//
// New bit, instead of static buffer (since XBox guys are desperately short of mem) I return a malloc'd buffer now,
//	so remember to free it!
//
/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:483
private func CopeWithDumbStringData(_ psSentence: String, _ psThisLanguage: String) -> String {
    let iBufferSize: Int32 = strlen(psSentence) * 3	// *3 to allow for expansion of anything even stupid string consisting entirely of elipsis chars
    // AI: Raven takes the buffer from Z_Malloc, and the caller frees it with Z_Free. The function uses a local buffer of the same size and returns its String.
    var psNewString = CharBuf(iBufferSize)
    Q_strncpyz(&psNewString, psSentence, iBufferSize)

    // this is annoying, I have to just guess at which languages to do it for (ie NOT ASIAN/MBCS!!!) since the
    //	string system was deliberately (and correctly) designed to not know or care whether it was doing SBCS
    //	or MBCS languages, because it was never envisioned that I'd have to clean up other people's mess.
    //
    // Ok, bollocks to it, this will have to do. Any other languages that come later and have bugs in their text can
    //	get fixed by them typing it in properly in the first place...
    //
    if stricmp(psThisLanguage, "ENGLISH") == 0 ||
        stricmp(psThisLanguage, "FRENCH") == 0 ||
        stricmp(psThisLanguage, "GERMAN") == 0 ||
        stricmp(psThisLanguage, "ITALIAN") == 0 ||
        stricmp(psThisLanguage, "SPANISH") == 0 ||
        stricmp(psThisLanguage, "POLISH") == 0 ||
        stricmp(psThisLanguage, "RUSSIAN") == 0
    {
        //	strXLS_Speech.Replace(va("%c",0x92),va("%c",0x27));	// "'"
        while let p = strchr(psNewString, 0x92) {	// "rich" (and illegal) apostrophe
            psNewString[p] = 0x27
        }

        //	strXLS_Speech.Replace(va("%c",0x93),"\"");			// smart quotes -> '"'
        while let p = strchr(psNewString, 0x93) {
            psNewString[p] = Int32(ascii: "\"")
        }

        //	strXLS_Speech.Replace(va("%c",0x94),"\"");			// smart quotes -> '"'
        while let p = strchr(psNewString, 0x94) {
            psNewString[p] = Int32(ascii: "\"")
        }

        //	strXLS_Speech.Replace(va("%c",0x0B),".");			// full stop
        while let p = strchr(psNewString, 0x0B) {
            psNewString[p] = Int32(ascii: ".")
        }

        //	strXLS_Speech.Replace(va("%c",0x85),"...");			// "..."-char ->  3-char "..."
        while var p = strchr(psNewString, 0x85) {	// "rich" (and illegal) apostrophe
            memmove(&psNewString, p, strlen(psNewString[p...]), at: p + 2)
            psNewString[p] = Int32(ascii: ".")
            p += 1
            psNewString[p] = Int32(ascii: ".")
            p += 1
            psNewString[p] = Int32(ascii: ".")
        }

        //	strXLS_Speech.Replace(va("%c",0x91),va("%c",0x27));	// "'"
        while let p = strchr(psNewString, 0x91) {
            psNewString[p] = 0x27
        }

        //	strXLS_Speech.Replace(va("%c",0x96),va("%c",0x2D));	// "-"
        while let p = strchr(psNewString, 0x96) {
            psNewString[p] = 0x2D
        }

        //	strXLS_Speech.Replace(va("%c",0x97),va("%c",0x2D));	// "-"
        while let p = strchr(psNewString, 0x97) {
            psNewString[p] = 0x2D
        }

        // bug fix for picky grammatical errors, replace "?." with "? "
        //
        while let p = strstr(psNewString, "?.") {
            psNewString[p + 1] = Int32(ascii: " ")
        }

        // StripEd and our print code don't support tabs...
        //
        while let p = strchr(psNewString, 0x09) {
            psNewString[p] = Int32(ascii: " ")
        }
    }

    return String(psNewString)
}

// MARK: - The package methods before Leetify

extension CStringEdPackage {
    // return is either NULL for good else error message to display...
    //
    /// Source: oracle/codemp/qcommon/stringed_ingame.cpp:578
    // AI: Raven returns NULL for a good line. The method returns "" for NULL, because no message of his is empty.
    func ParseLine(_ psLine: String) -> String {
        var psErrorMessage = ""

        // Raven steps his own `psLine` parameter through its bytes, so the body walks a TextCursor over a copy of them.
        var psLine = TextCursor(CharBuf(psLine))

        if !psLine.isNull {
            if self.CheckLineForKeyword(sSE_KEYWORD_VERSION, &psLine) {
                // VERSION 	"1"
                //
                let psVersionNumber = self.InsideQuotes(psLine.text)
                let iVersionNumber = atoi(psVersionNumber)

                if iVersionNumber != iSE_VERSION {
                    psErrorMessage = va("Unexpected version number %d, expecting %d!\n", iVersionNumber, iSE_VERSION)
                }
            } else if self.CheckLineForKeyword(sSE_KEYWORD_CONFIG, &psLine)
                || self.CheckLineForKeyword(sSE_KEYWORD_FILENOTES, &psLine)
                || self.CheckLineForKeyword(sSE_KEYWORD_NOTES, &psLine)
            {
                // not used ingame, but need to absorb the token
            } else if self.CheckLineForKeyword(sSE_KEYWORD_REFERENCE, &psLine) {
                // REFERENCE	GUARD_GOOD_TO_SEE_YOU
                //
                let psLocalReference = self.InsideQuotes(psLine.text)
                self.AddEntry(psLocalReference)
            } else if self.CheckLineForKeyword(sSE_KEYWORD_FLAGS, &psLine) {
                // FLAGS 	FLAG_CAPTION FLAG_TYPEMATIC
                //
                let psReference = self.GetCurrentReference_ParseOnly()
                if !psReference.isEmpty {
                    let sSeperators = " \t"
                    var sFlags = CharBuf(1024)	// 1024 chars should be enough to store 8 flag names
                    strncpy(&sFlags, psLine.text, sFlags.count - 1)
                    // AI: Raven walks the tokens of the copy with strtok. The body splits the copy on the same separators, which gives the same tokens.
                    for psToken in String(sFlags).split(whereSeparator: { sSeperators.contains($0) }) {
                        // psToken = flag name (in caps)
                        //
                        let psToken = Q_strupr(String(psToken))	// jic
                        self.AddFlagReference(psReference, psToken)

                        // read next flag for this string...
                        //
                    }
                } else {
                    psErrorMessage = "Error parsing file: Unexpected \"" + sSE_KEYWORD_FLAGS + "\"\n"
                }
            } else if self.CheckLineForKeyword(sSE_KEYWORD_ENDMARKER, &psLine) {
                // ENDMARKER
                //
                self.m_bEndMarkerFound_ParseOnly = true	// the only major error checking I bother to do (for file truncation)
            } else if Q_stricmpn(sSE_KEYWORD_LANG, psLine.text, strlen(sSE_KEYWORD_LANG)) == 0 {
                // LANG_ENGLISH 	"GUARD:  Good to see you, sir.  Taylor is waiting for you in the clean tent.  We need to get you suited up.  "
                //
                let psReference = self.GetCurrentReference_ParseOnly()
                if !psReference.isEmpty {
                    psLine.advance(by: strlen(sSE_KEYWORD_LANG))

                    // what language is this?...
                    //
                    var psWordEnd = psLine
                    while psWordEnd.byte != 0 && psWordEnd.byte != Int32(ascii: " ") && psWordEnd.byte != Int32(ascii: "\t") {
                        psWordEnd.advance()
                    }
                    var sThisLanguage = CharBuf(1024)
                    var iCharsToCopy = psWordEnd.offset! - psLine.offset!
                    if iCharsToCopy > sThisLanguage.count - 1 {
                        iCharsToCopy = Int32(sThisLanguage.count) - 1
                    }
                    strncpy(&sThisLanguage, psLine.text, iCharsToCopy)	// already declared as {0} so no need to zero-cap dest buffer

                    psLine.advance(by: strlen(sThisLanguage))
                    let _psSentence = self.ConvertCRLiterals_Read(self.InsideQuotes(psLine.text))

                    // Dammit, I hate having to do crap like this just because other people mess up and put
                    //	stupid data in their text, so I have to cope with it.
                    //
                    // note hackery with _psSentence and psSentence because of const-ness. bleurgh. Just don't ask.
                    //
                    let psSentence = CopeWithDumbStringData(_psSentence, String(sThisLanguage))

                    if self.m_bLoadingEnglish_ParseOnly {
                        // if loading just "english", then go ahead and store it...
                        //
                        self.SetString(psReference, psSentence, false)
                    } else {
                        // if loading a foreign language...
                        //
                        let bSentenceIsEnglish = (stricmp(String(sThisLanguage), "english") == 0) ? true : false	// see whether this is the english master or not

                        // this check can be omitted, I'm just being extra careful here...
                        //
                        if !bSentenceIsEnglish {
                            // basically this is just checking that an .STE file override is the same language as the .STR...
                            //
                            if stricmp(self.m_strLoadingLanguage_ParseOnly, String(sThisLanguage)) != 0 {
                                psErrorMessage = va("Language \"%s\" found when expecting \"%s\"!\n", String(sThisLanguage), self.m_strLoadingLanguage_ParseOnly)
                            }
                        }

                        if psErrorMessage.isEmpty {
                            self.SetString(psReference, psSentence, bSentenceIsEnglish)
                        }
                    }

                    // AI: Raven frees the Z_Malloc buffer of CopeWithDumbStringData here. A String needs no free, so the call goes.
                } else {
                    psErrorMessage = "Error parsing file: Unexpected \"" + sSE_KEYWORD_LANG + "\"\n"
                }
            } else {
                psErrorMessage = va("Unknown keyword at linestart: \"%s\"\n", psLine.text)
            }
        }

        return psErrorMessage
    }

    // returns reference of string being parsed, else "" for none.
    //
    /// Source: oracle/codemp/qcommon/stringed_ingame.cpp:731
    private func GetCurrentReference_ParseOnly() -> String {
        return self.m_strCurrentEntryRef_ParseOnly
    }

    // add new string entry (during parse)
    //
    /// Source: oracle/codemp/qcommon/stringed_ingame.cpp:738
    private func AddEntry(_ psLocalReference: String) {
        // the reason I don't just assign it anyway is because the optional .STE override files don't contain flags,
        //	and therefore would wipe out the parsed flags of the .STR file...
        //
        if self.m_StringEntries[va("%s_%s", self.m_strCurrentFileRef_ParseOnly, psLocalReference)] == nil {
            let SE_Entry = SE_Entry_t()
            self.m_StringEntries[va("%s_%s", self.m_strCurrentFileRef_ParseOnly, psLocalReference)] = SE_Entry
        }
        self.m_strCurrentEntryRef_ParseOnly = psLocalReference
    }
}

/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:752
// AI: Raven keeps the text in a static std::string and returns its c_str. The function keeps it in a local buffer and returns its String, by row C6.
public func Leetify(_ psString: String) -> String {
    var str = CharBuf(psString)
    if sp_leet!.integer == 42 {	// very specific test, so you won't hit it accidentally
        let cReplace = CharBuf(bytes: [
            0x6F, 0x30, 0x6C, 0x31, 0x65, 0x33, 0x61, 0x34, 0x73, 0x35, 0x74, 0x37, 0x69, 0x21, 0x68, 0x23,
            0x4F, 0x30, 0x4C, 0x31, 0x45, 0x33, 0x41, 0x34, 0x53, 0x35, 0x54, 0x37, 0x49, 0x21, 0x48, 0x23,	// laziness because of strchr()
        ])

        var i: Int32 = 0
        while i < cReplace.count {
            while let p = strchr(str, cReplace[i] as Int32) {
                str[p] = cReplace[i + 1] as Int8
            }
            i += 2
        }
    }

    return String(str)
}

// MARK: - The package method after Leetify

extension CStringEdPackage {
    /// Source: oracle/codemp/qcommon/stringed_ingame.cpp:775
    // AI: Raven changes the entry through a reference into the map. The method changes it through the Dictionary subscript.
    private func SetString(_ psLocalReference: String, _ psNewString: String, _ bEnglishDebug: Bool) {
        let key = va("%s_%s", self.m_strCurrentFileRef_ParseOnly, psLocalReference)
        if self.m_StringEntries[key] != nil {
            if bEnglishDebug || self.m_bLoadingEnglish_ParseOnly {
                // then this is the leading english text of a foreign sentence pair (so it's the debug-key text),
                //	or it's the only text when it's english being loaded...
                //
                self.m_StringEntries[key]!.m_strString = Leetify(psNewString)
                if self.m_bLoadDebug {
                    self.m_StringEntries[key]!.m_strDebug = sSE_DEBUGSTR_PREFIX
                    self.m_StringEntries[key]!.m_strDebug += /* m_bLoadingEnglish_ParseOnly ? "" : */ psNewString
                    self.m_StringEntries[key]!.m_strDebug += sSE_DEBUGSTR_SUFFIX
                }
                self.m_strCurrentEntryEnglish_ParseOnly = psNewString	// for possible "#same" resolving in foreign later
            } else {
                // then this is foreign text (so check for "#same" resolving)...
                //
                if stricmp(psNewString, sSE_EXPORT_SAME) == 0 {
                    self.m_StringEntries[key]!.m_strString = self.m_strCurrentEntryEnglish_ParseOnly	// foreign "#same" is now english
                    if self.m_bLoadDebug {
                        self.m_StringEntries[key]!.m_strDebug = sSE_DEBUGSTR_PREFIX
                        self.m_StringEntries[key]!.m_strDebug += sSE_EXPORT_SAME				// english (debug) is now "#same"
                        self.m_StringEntries[key]!.m_strDebug += sSE_DEBUGSTR_SUFFIX
                    }
                } else {
                    self.m_StringEntries[key]!.m_strString = psNewString							// foreign is just foreign
                }
            }
        } else {
            //	__ASSERT(0);	// should never happen
        }
    }
}

// filename is local here, eg:	"strings/german/obj.str"
//
// return is either NULL for good else error message to display...
//
/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:828
private func SE_Load_Actual(_ psFileName: String, _ bLoadDebug: Bool, _ bSpeculativeLoad: Bool) -> String? {
    var psErrorMessage: String? = nil

    // AI: Raven omits `piLoadedLength`, whose default is NULL. The call passes a scratch length, which the body reads nowhere.
    var piLoadedLength: Int32 = 0
    let psLoadedData = SE_LoadFileData(psFileName, &piLoadedLength)
    if psLoadedData != nil {
        // now parse the data...
        //
        // AI: Raven casts the loaded bytes to `char *`. The body copies them into a CharBuf for the cursor.
        var sLoadedText = CharBuf(psLoadedData!.count)
        Com_Memcpy(&sLoadedText, psLoadedData!, psLoadedData!.count)
        var psParsePos = TextCursor(sLoadedText)

        TheStringPackage.SetupNewFileParse(psFileName, bLoadDebug)

        var sLineBuffer = CharBuf(16384)	// should be enough for one line of text (some of them can be BIG though)
        while psErrorMessage == nil && TheStringPackage.ReadLine(&psParsePos, &sLineBuffer) {
            if strlen(sLineBuffer) != 0 {
                //				__DEBUGOUT( sLineBuffer );
                //				__DEBUGOUT( "\n" );

                // AI: Raven stores the NULL of ParseLine. The method returns "" for NULL, so the store reads "" as nil.
                let psLineError = TheStringPackage.ParseLine(String(sLineBuffer))
                psErrorMessage = psLineError.isEmpty ? nil : psLineError
            }
        }

        SE_FreeFileDataAfterLoad(psLoadedData!)

        if psErrorMessage == nil && !TheStringPackage.EndMarkerFoundDuringParse() {
            psErrorMessage = va("Truncated file, failed to find \"%s\" at file end!", sSE_KEYWORD_ENDMARKER)
        }
    } else {
        if bSpeculativeLoad {
            // then it's ok to not find the file, so do nothing...
        } else {
            psErrorMessage = va("Unable to load \"%s\"!", psFileName)
        }
    }

    return psErrorMessage
}

/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:875
private func SE_GetFoundFile(_ strResult: inout String) -> String? {
    // Raven's static buffer keeps the result valid after the return, and a returned `String` is already a copy.
    var sTemp = CharBuf(1024/*MAX_PATH*/)

    if strlen(strResult) == 0 {
        return nil
    }

    strncpy(&sTemp, strResult, Int32(sTemp.count) - 1)
    sTemp[sTemp.count - 1] = 0

    let psSemiColon = strchr(sTemp, Int32(ascii: ";"))
    if psSemiColon != nil {
        sTemp[psSemiColon!] = 0

        // AI: Raven erases the bytes up to the semicolon from the C++ string. The text after them is the new value.
        strResult = String(CharBuf(strResult)[(psSemiColon! + 1)...])
    } else {
        // no semicolon found, probably last entry? (though i think even those have them on, oh well)
        //
        strResult = ""
    }

    //	strlwr(sTemp);	// just for consistancy and set<> -> set<> erasure checking etc

    return String(sTemp)
}

//////////// API entry points from rest of game.... //////////////////////////////

// filename is local here, eg:	"strings/german/obj.str"
//
// return is either NULL for good else error message to display...
//
/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:910
public func SE_Load(_ psFileName: String, _ bLoadDebug: Bool = true, _ bFailIsCritical: Bool = true) -> String? {
    // Raven sets his own `psFileName` parameter to the built name, so the body takes a copy.
    var psFileName = psFileName
    ////////////////////////////////////////////////////
    //
    // ingame here tends to pass in names without paths, but I expect them when doing a language load, so...
    //
    var sTemp = CharBuf(1000)
    if strchr(psFileName, Int32(ascii: "/")) == nil {
        strcpy(&sTemp, sSE_STRINGS_DIR)
        strcat(&sTemp, "/")
        if se_language != nil {
            strcat(&sTemp, se_language!.string!)
            strcat(&sTemp, "/")
        }
    }
    strcat(&sTemp, psFileName)
    COM_DefaultExtension(&sTemp, Int32(sTemp.count), sSE_INGAME_FILE_EXTENSION)
    psFileName = String(sTemp)
    //
    ////////////////////////////////////////////////////


    var psErrorMessage = SE_Load_Actual(psFileName, bLoadDebug, false)

    // check for any corresponding / overriding .STE files and load them afterwards...
    //
    if psErrorMessage == nil {
        var sFileName = CharBuf(iSE_MAX_FILENAME_LENGTH)
        strncpy(&sFileName, psFileName, sFileName.count - 1)
        sFileName[sFileName.count - 1] = 0
        let p = strrchr(sFileName, Int32(ascii: "."))
        if p != nil && strlen(sFileName[p!...]) == strlen(sSE_EXPORT_FILE_EXTENSION) {
            strcpy(&sFileName, sSE_EXPORT_FILE_EXTENSION, at: p!)

            psErrorMessage = SE_Load_Actual(String(sFileName), bLoadDebug, true)
        }
    }

    if psErrorMessage != nil {
        if bFailIsCritical {
            //		TheStringPackage.Clear(TRUE);	// Will we want to do this?  Any errors that arise should be fixed immediately
            Com_Error(ERR_DROP, "SE_Load(): Couldn't load \"%s\"!\n\nError: \"%s\"\n", psFileName, psErrorMessage!)
        } else {
            Com_DPrintf(S_COLOR_YELLOW + "SE_Load(): Couldn't load \"%s\"!\n", psFileName)
        }
    }

    return psErrorMessage
}

// convenience-function for the main GetString call...
//
/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:971
public func SE_GetString(_ psPackageReference: String, _ psStringReference: String) -> String {
    var sReference = CharBuf(256)	// will always be enough, I've never seen one more than about 30 chars long

    // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of sReference.
    Com_sprintf(&sReference, Int32(sReference.count), "%s_%s", psPackageReference, psStringReference)

    Q_strupr(&sReference)
    return SE_GetString(String(sReference))
}

/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:981
public func SE_GetString(_ psPackageAndStringReference: String) -> String {
    var sReference = CharBuf(256)	// will always be enough, I've never seen one more than about 30 chars long
    Q_strncpyz(&sReference, psPackageAndStringReference, Int32(sReference.count))
    Q_strupr(&sReference)

    if let Entry = TheStringPackage.m_StringEntries[String(sReference)] {
        if se_debug!.integer != 0 && TheStringPackage.m_bLoadDebug {
            return Entry.m_strDebug
        } else {
            return Entry.m_strString
        }
    }

    // should never get here, but fall back anyway... (except we DO use this to see if there's a debug-friendly key bind, which may not exist)
    //
    //	__ASSERT(0);
    return ""	// you may want to replace this with something based on _DEBUG or not?
}

// convenience-function for the main GetFlags call...
//
/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:1012
public func SE_GetFlags(_ psPackageReference: String, _ psStringReference: String) -> Int32 {
    var sReference = CharBuf(256)	// will always be enough, I've never seen one more than about 30 chars long

    // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of sReference.
    Com_sprintf(&sReference, Int32(sReference.count), "%s_%s", psPackageReference, psStringReference)

    return SE_GetFlags(String(sReference))
}

/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:1021
public func SE_GetFlags(_ psPackageAndStringReference: String) -> Int32 {
    if let Entry = TheStringPackage.m_StringEntries[psPackageAndStringReference] {
        return Entry.m_iFlags
    }

    // should never get here, but fall back anyway...
    //
    //	__ASSERT(0);

    return 0
}

/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:1039
public func SE_GetNumFlags() -> Int32 {
    return Int32(TheStringPackage.m_vstrFlagNames.count)
}

/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:1044
// AI: Raven compares the int with the unsigned size, so a negative index fails the test. The body converts the index the same way.
public func SE_GetFlagName(_ iFlagIndex: Int32) -> String {
    if UInt32(bitPattern: iFlagIndex) < TheStringPackage.m_vstrFlagNames.count {
        return TheStringPackage.m_vstrFlagNames[iFlagIndex]
    }

    //	__ASSERT(0);
    return ""
}

// returns flag bitmask (eg 00000010b), else 0 for not found
//
/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:1057
public func SE_GetFlagMask(_ psFlagName: String) -> Int32 {
    return TheStringPackage.GetFlagMask(psFlagName)
}

// I could cache the result of this since it won't change during app lifetime unless someone does a build-publish
//	while you're still ingame. Cacheing would make sense since it can take a while to scan, but I'll leave it and
//	let whoever calls it cache the results instead. I'll make it known that it's a slow process to call this, but
//	whenever anyone calls someone else's code they should assign it to an int anyway, since you've no idea what's
//	going on. Basically, don't  use this in a FOR loop as the end-condition. Duh.
//
// Groan, except for Bob. I mentioned that this was slow and only call it once, but he's calling it from
//	every level-load...  Ok, cacheing it is...
//
/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:1071
public var gvLanguagesAvailable: [String] {
    get { world.gvLanguagesAvailable }
    set { world.gvLanguagesAvailable = newValue }
}

/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:1072
public func SE_GetNumLanguages() -> Int32 {
    if gvLanguagesAvailable.isEmpty {
        var strResults = ""
        /*int iFilesFound = */SE_BuildFileList(sSE_STRINGS_DIR, &strResults)

        // AI: Raven keeps a C++ `set<string>`. The Swift Set holds the same texts.
        var strUniqueStrings = Set<String>()	// laziness <g>
        var p: String
        while let next = SE_GetFoundFile(&strResults) {
            p = next
            let psLanguage = TheStringPackage.ExtractLanguageFromPath(p)

            //		__DEBUGOUT( p );
            //		__DEBUGOUT( "\n" );
            //		__DEBUGOUT( psLanguage );
            //		__DEBUGOUT( "\n" );

            if !strUniqueStrings.contains(psLanguage) {
                strUniqueStrings.insert(psLanguage)

                // if english is available, it should always be first... ( I suppose )
                //
                if stricmp(psLanguage, "english") == 0 {
                    gvLanguagesAvailable.insert(psLanguage, at: 0)
                } else {
                    gvLanguagesAvailable.append(psLanguage)
                }
            }
        }
    }

    return Int32(gvLanguagesAvailable.count)
}

// SE_GetNumLanguages() must have been called before this...
//
/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:1120
// AI: Raven compares the int with the unsigned size, so a negative index fails the test. The body converts the index the same way.
public func SE_GetLanguageName(_ iLangIndex: Int32) -> String {
    if UInt32(bitPattern: iLangIndex) < gvLanguagesAvailable.count {
        return gvLanguagesAvailable[iLangIndex]
    }

    //	__ASSERT(0);
    return ""
}

// SE_GetNumLanguages() must have been called before this...
//
/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:1133
// AI: Raven compares the int with the unsigned size, so a negative index fails the test. The body converts the index the same way.
public func SE_GetLanguageDir(_ iLangIndex: Int32) -> String {
    if UInt32(bitPattern: iLangIndex) < gvLanguagesAvailable.count {
        return va("%s/%s", sSE_STRINGS_DIR, gvLanguagesAvailable[iLangIndex])
    }

    //	__ASSERT(0);
    return ""
}

/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:1144
public func SE_NewLanguage() {
    TheStringPackage.Clear(true)
}

// these two functions aren't needed other than to make Quake-type games happy and/or stop memory managers
//	complaining about leaks if they report them before the global StringEd package object calls it's own dtor.
//
// but here they are for completeness's sake I guess...
//
/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:1156
public func SE_Init() {
    TheStringPackage.Clear(false)

    se_language = Cvar_Get("se_language", "english", CVAR_ARCHIVE | CVAR_NORESTART)
    se_debug = Cvar_Get("se_debug", "0", 0)
    sp_leet = Cvar_Get("sp_leet", "0", CVAR_ROM)

    // if doing a buildscript, load all languages...
    //
    if com_buildScript!.integer == 2 {
        let iLanguages = SE_GetNumLanguages()
        var iLang: Int32 = 0
        while iLang < iLanguages {
            let psLanguage = SE_GetLanguageName(iLang)	// eg "german"
            Com_Printf("com_buildScript(2): Loading language \"%s\"...\n", psLanguage)
            _ = SE_LoadLanguage(psLanguage)
            iLang += 1
        }
    }

    let psErrorMessage = SE_LoadLanguage(se_language!.string!)
    if psErrorMessage != nil {
        Com_Error(ERR_DROP, "SE_Init() Unable to load language: \"%s\"!\nError: \"%s\"\n", se_language!.string!, psErrorMessage!)
    }
}

/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:1198
public func SE_ShutDown() {
    TheStringPackage.Clear(false)
}

// returns error message else NULL for ok.
//
// Any errors that result from this should probably be treated as game-fatal, since an asset file is fuxored.
//
/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:1208
public func SE_LoadLanguage(_ psLanguage: String, _ bLoadDebug: Bool = true) -> String? {
    var psErrorMessage: String? = nil

    if !psLanguage.isEmpty {
        SE_NewLanguage()

        var strResults = ""
        /*int iFilesFound = */SE_BuildFileList(sSE_STRINGS_DIR, &strResults)

        while let p = SE_GetFoundFile(&strResults), psErrorMessage == nil {
            let psThisLang = TheStringPackage.ExtractLanguageFromPath(p)

            if stricmp(psLanguage, psThisLang) == 0 {
                psErrorMessage = SE_Load(p, bLoadDebug)
            }
        }
    } else {
        //	__ASSERT( 0 && "SE_LoadLanguage(): Bad language name!" );
    }

    return psErrorMessage
}

// called in Com_Frame, so don't take up any time! (can also be called during dedicated)
//
// instead of re-loading just the files we've already loaded I'm going to load the whole language (simpler)
//
/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:1250
public func SE_CheckForLanguageUpdates() {
    if se_language != nil && se_language!.modified {
        let psErrorMessage = SE_LoadLanguage(se_language!.string!, true)
        if psErrorMessage != nil {
            Com_Error(ERR_DROP, psErrorMessage!)
        }
        se_language!.modified = false
    }
}
