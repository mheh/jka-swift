import JKAMP
import JKAMP_Ded
import JKAShared
import Testing
@testable import JKAMP_DedLogic

/// This suite checks the StringEd parse of `stringed_ingame.cpp` in a fresh world.
/// The test hands the package a small `.str` text line by line, as `SE_Load_Actual` does, and reads the entries back.
@Suite(.serialized)
struct StringEdSuite {
    @Test("a parsed .str text gives its strings back through SE_GetString")
    func parsedTextReadsBack() {
        // given
        world = EngineWorld()
        let text = [
            "VERSION \"1\"",
            "CONFIG \"W:\\bin\\striped.cfg\"",
            "FILENOTES \"\"",
            "REFERENCE HELLO",
            "FLAGS FLAG_CAPTION",
            "LANG_ENGLISH \"Hello, world.  // not a comment\"",
            "",
            "REFERENCE QUOTE",
            "LANG_ENGLISH\t\"Line one\\nline two\"   // a trailing comment",
            "ENDMARKER",
        ].joined(separator: "\r\n")

        JKAMP.Cvar.scratch { debug in
            JKAMP.Cvar.scratch { leet in
                se_debug = debug
                sp_leet = leet

                // when
                TheStringPackage.SetupNewFileParse("strings/english/test.str", false)
                var psParsePos = TextCursor(CharBuf(text))
                var sLineBuffer = CharBuf(16384)
                var psErrorMessage = ""
                while psErrorMessage.isEmpty && TheStringPackage.ReadLine(&psParsePos, &sLineBuffer) {
                    if strlen(sLineBuffer) != 0 {
                        psErrorMessage = TheStringPackage.ParseLine(String(sLineBuffer))
                    }
                }

                // then
                #expect(psErrorMessage == "")
                #expect(TheStringPackage.EndMarkerFoundDuringParse())
                #expect(SE_GetString("TEST_HELLO") == "Hello, world.  // not a comment")
                #expect(SE_GetString("test", "quote") == "Line one\nline two")
                #expect(SE_GetString("TEST_MISSING") == "")
                #expect(SE_GetFlagMask("FLAG_CAPTION") == 1)
                #expect(SE_GetFlags("TEST_HELLO") == 1)
                #expect(SE_GetNumFlags() == 1)
                #expect(SE_GetFlagName(0) == "FLAG_CAPTION")
                #expect(SE_GetFlagName(-1) == "")

                se_debug = nil
                sp_leet = nil
            }
        }
    }

    @Test("an unknown keyword stops the parse with Raven's message")
    func unknownKeywordGivesTheMessage() {
        // given
        world = EngineWorld()
        TheStringPackage.SetupNewFileParse("strings/english/test.str", false)

        // when
        let psErrorMessage = TheStringPackage.ParseLine("BOGUS 1")

        // then
        #expect(psErrorMessage == "Unknown keyword at linestart: \"BOGUS 1\"\n")
    }
}
