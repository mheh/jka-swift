"""Seam I: the alignment of a hand file with the line rows of its drafts.

Each test writes the line rows of one function by hand into a temporary store and a hand file beside it, so no test parses.
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
        (3, 0, "blank", 0, ""),
        (4, 2, "own", 1, "if ent == 0 {"),
        (5, 3, "own", 2, "return 0"),
        (6, 2, "frame", 1, "}"),
        (7, 4, "own", 1, "total = ent * 2"),
        (8, 4, "trailing", 1, "// twice"),
        (9, 5, "own", 1, "return total"),
        (10, None, "frame", 0, "}")]
# The printed lines of ROWS, which a hand file equal to the draft holds.
DRAFT = ["/// Source: oracle/codemp/game/g_x.c:4",
         "func G_X(_ ent: Int32) -> Int32 {",
         "    var total: Int32 = 0",
         "",
         "    if ent == 0 {",
         "        return 0",
         "    }",
         "    total = ent * 2 // twice",
         "    return total",
         "}"]
KEY = "lowered-key"


class Align(unittest.TestCase):
    def setUp(self) -> None:
        import store as S
        from lowering_key import LANGUAGE

        self.folder = tempfile.TemporaryDirectory()
        self.store = S.Store(Path(self.folder.name) / "table.sqlite")
        self.store.reset_lowered(KEY, {})
        self.store.save_lowered(LANGUAGE, "g_x", "G_X", [], ROWS)
        self.hand = Path(self.folder.name) / "g_x.swift"

    def tearDown(self) -> None:
        self.store.close()
        self.folder.cleanup()

    def align(self, lines: list[str]) -> tuple[list[tuple], str]:
        """Align the hand file of the given lines and give back its alignment rows and the standard error of the run."""
        import align

        self.hand.write_text("\n".join(["import JKAShared", ""] + lines + [""]))
        err = io.StringIO()
        with contextlib.redirect_stderr(err):
            align.align_stem(self.store, KEY, "g_x", ["G_X"], self.hand, "Sources/JKAMP_GameLogic/g_x.swift")
        return self.store.alignments("Sources/JKAMP_GameLogic/g_x.swift"), err.getvalue()

    def test_a_hand_file_equal_to_the_draft_aligns_every_line_as_same(self) -> None:
        # given a hand file whose function is the draft byte for byte, after two lines outside any function
        # when the file is aligned
        rows, _ = self.align(DRAFT)

        # then each line of the function is same and names the line row it prints, the trailing row aside
        printed = [row for row in ROWS if row[2] != "trailing"]
        self.assertEqual(rows, [("G_X", 3 + i, row[0], row[1], row[2], "same") for i, row in enumerate(printed)])

    def test_an_inserted_hand_line_is_hand_with_no_line_seq(self) -> None:
        # given a hand file that adds one comment line above the `if` of the draft
        lines = DRAFT[:4] + ["    // The hand checks the world entity first."] + DRAFT[4:]

        # when the file is aligned
        rows, _ = self.align(lines)

        # then the added line is hand with no line row and no statement, and the lines around it stay same
        self.assertEqual(rows[4], ("G_X", 7, None, None, None, "hand"))
        self.assertEqual([row[5] for row in rows], ["same"] * 4 + ["hand"] + ["same"] * 6)
        self.assertEqual(rows[5], ("G_X", 8, 4, 2, "own", "same"))

    def test_a_function_under_the_ratio_is_rewritten(self) -> None:
        # given a hand file that keeps the Source line, the signature, and the brace of the draft, and writes a new body
        # Three lines of 21 match, so the ratio is 6 of 21, under 0.3.
        body = ["    // The hand folds the test into a guard.", "    guard ent != 0 else { return .zero }", "    let doubled = ent << 1",
                "    precondition(doubled >= ent)", "    assert(doubled % 2 == 0)", "    _ = doubled", "    let result = doubled", "    return result"]
        lines = DRAFT[:2] + body + DRAFT[-1:]

        # when the file is aligned
        rows, err = self.align(lines)

        # then every line of the function is rewritten with no line row, and the function goes to standard error with its ratio
        self.assertEqual(rows, [("G_X", 3 + i, None, None, None, "rewritten") for i in range(len(lines))])
        self.assertIn("G_X", err)
        self.assertIn("ratio 0.", err)

    def test_an_unequal_replace_block_is_hand_and_its_draft_lines_count_as_deleted(self) -> None:
        # given a hand file that writes two lines in the place of the one draft line `total = ent * 2`
        lines = DRAFT[:7] + ["    total = ent", "    total += ent"] + DRAFT[8:]

        # when the file is aligned
        rows, err = self.align(lines)

        # then the two hand lines are hand with no line row, the lines around them stay same, and the one draft line counts as deleted
        self.assertEqual(rows[7:9], [("G_X", 10, None, None, None, "hand"), ("G_X", 11, None, None, None, "hand")])
        self.assertEqual([row[5] for row in rows], ["same"] * 7 + ["hand"] * 2 + ["same"] * 2)
        self.assertIn("1 draft lines deleted", err)

    def test_a_replaced_line_in_a_block_of_equal_length_is_edited_with_its_line_row(self) -> None:
        # given a hand file that changes the one line `total = ent * 2 // twice`
        lines = DRAFT[:7] + ["    total = ent &* 2 // twice"] + DRAFT[8:]

        # when the file is aligned
        rows, _ = self.align(lines)

        # then the changed line is edited and names the line row and the statement of the draft line it replaced
        self.assertEqual(rows[7], ("G_X", 10, 7, 4, "own", "edited"))
        self.assertEqual([row[5] for row in rows], ["same"] * 7 + ["edited"] + ["same"] * 2)

    def test_a_hand_function_with_no_draft_function_is_hand(self) -> None:
        # given a hand file with a forward to G_X and a helper whose Source line names a Raven line no draft holds
        forward = ["/// A caller that passes NULL reaches `G_X` through this forward, and a NULL caller passes the optional.",
                   "/// Source: oracle/codemp/game/g_x.c:4", "func G_X(_ ent: Int32?) -> Int32 {", "    return G_X(ent ?? 0)", "}", ""]
        helper = ["", "/// Source: oracle/codemp/game/g_x.c:90", "func G_Helper() {", "    G_X(1)", "}"]

        # when the file is aligned
        rows, _ = self.align(forward + DRAFT + helper)

        # then each line of the forward and of the helper, from its Source line to its brace, is hand with no line row
        self.assertEqual(rows[:4], [("G_X", 4 + i, None, None, None, "hand") for i in range(4)])
        self.assertEqual(rows[-4:], [("G_Helper", 20 + i, None, None, None, "hand") for i in range(4)])
        self.assertEqual([row[5] for row in rows[4:-4]], ["same"] * 10)


if __name__ == "__main__":
    unittest.main()
