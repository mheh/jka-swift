"""Seam J: the comparison of a hand file, or of a snapshot, with the line rows of a stem.

Each test writes the line rows and the statement rows of one function by hand into a temporary store, so no test parses.
"""

from __future__ import annotations

import contextlib
import io
import sys
import tempfile
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

# The line rows of G_X, each as its seq, its statement seq, its role, its depth, and its text.
ROWS = [(0, None, "header", 0, "/// Source: oracle/codemp/game/g_x.c:4"),
        (1, None, "header", 0, "func G_X(_ ent: Int32) -> Int32 {"),
        (2, 1, "own", 1, "var total: Int32 = 0"),
        (3, 2, "own", 1, "total = ent * 2"),
        (4, 3, "own", 1, "return total"),
        (5, None, "frame", 0, "}")]
# The statement rows of G_X, each as its seq, its parent, its kind, its first line, and its text.
STATEMENTS = [(0, None, "COMPOUND_STMT", 5, "{ }"),
              (1, 0, "DECL_STMT", 6, "int total = 0;"),
              (2, 0, "BINARY_OPERATOR", 8, "total = ent * 2"),
              (3, 0, "RETURN_STMT", 9, "return total")]
DRAFT = ["/// Source: oracle/codemp/game/g_x.c:4",
         "func G_X(_ ent: Int32) -> Int32 {",
         "    var total: Int32 = 0",
         "    total = ent * 2",
         "    return total",
         "}"]
KEY = "lowered-key"
NAME = "Sources/JKAMP_GameLogic/g_x.swift"


class Compare(unittest.TestCase):
    def setUp(self) -> None:
        import store as S
        from lowering_key import LANGUAGE

        self.folder = tempfile.TemporaryDirectory()
        self.store = S.Store(Path(self.folder.name) / "table.sqlite")
        statements = [("g_x", "G_X", seq, parent, kind, line, 1, line, 2, 10 * seq, 10 * seq + 5, text)
                      for seq, parent, kind, line, text in STATEMENTS]
        self.store.save("base", "base-key", {}, {}, tables={"statements": statements})
        self.store.reset_lowered(KEY, {})
        self.store.save_lowered(LANGUAGE, "g_x", "G_X", [], ROWS)
        self.hand = Path(self.folder.name) / "g_x.swift"

    def tearDown(self) -> None:
        self.store.close()
        self.folder.cleanup()

    def compare(self, lines: list[str]) -> tuple[list[str], int]:
        """Align the hand file of the given lines, then compare it, and give back the printed lines and the exit code."""
        import align
        import compare

        self.hand.write_text("\n".join(["import JKAShared", ""] + lines + [""]))
        with contextlib.redirect_stderr(io.StringIO()):
            align.align_stem(self.store, KEY, "g_x", ["G_X"], self.hand, NAME)
        return compare.compare_stem(self.store, KEY, "g_x", ["G_X"], self.hand, NAME)

    def test_a_stem_compared_with_itself_prints_nothing_and_exits_zero(self) -> None:
        import compare
        import printer

        # given a hand file equal to the draft, and a snapshot folder that holds the stem's own printed text
        snapshot = Path(self.folder.name) / "snapshot"
        (snapshot / "bodies").mkdir(parents=True)
        (snapshot / "bodies" / "g_x.swift").write_text(printer.stem_text([ROWS]))

        # when the stem is compared with its hand file and with the snapshot
        printed, code = self.compare(DRAFT)
        against, against_code = compare.compare_against(self.store, KEY, "g_x", ["G_X"], snapshot)

        # then neither comparison prints a line, and both exit 0
        self.assertEqual((printed, code), ([], 0))
        self.assertEqual((against, against_code), ([], 0))

    def test_one_edited_line_prints_its_c_line_and_both_texts_and_exits_one(self) -> None:
        # given a hand file that changes the one line `total = ent * 2`, statement 2 at Raven's line 8
        lines = DRAFT[:3] + ["    total = ent &* 2"] + DRAFT[4:]

        # when the stem is compared with its hand file
        printed, code = self.compare(lines)

        # then one difference prints, the C line, the function, and the role, then the draft text and the hand text, and the code is 1
        self.assertEqual(printed, ["g_x.c:8 G_X own", "    draft: total = ent * 2", "    hand: total = ent &* 2"])
        self.assertEqual(code, 1)

    def test_a_snapshot_line_that_differs_prints_its_c_line_and_both_texts_and_exits_one(self) -> None:
        import compare
        import printer

        # given a snapshot whose draft of the stem changes the line of statement 2, Raven's line 8
        snapshot = Path(self.folder.name) / "snapshot"
        snapshot.mkdir()
        (snapshot / "g_x.swift").write_text(printer.stem_text([ROWS]).replace("total = ent * 2", "total = ent + ent"))

        # when the stored rows are compared with the snapshot
        printed, code = compare.compare_against(self.store, KEY, "g_x", ["G_X"], snapshot)

        # then the one line prints with its C line and both texts, and the code is 1
        self.assertEqual(printed, ["g_x.c:8 G_X own", "    stored:     total = ent * 2", "    snapshot:     total = ent + ent"])
        self.assertEqual(code, 1)

    def test_a_hand_file_with_no_alignment_is_missing(self) -> None:
        import compare

        # given a hand file that align.py never read
        self.hand.write_text("\n".join(DRAFT) + "\n")

        # when the stem is compared, then the comparison stops on the missing alignment, which the command turns into exit 2
        with self.assertRaises(compare.Missing):
            compare.compare_stem(self.store, KEY, "g_x", ["G_X"], self.hand, NAME)


if __name__ == "__main__":
    unittest.main()
