"""The compile gate keeps the hand functions of an adopted stem.

Each test aligns a hand file with the line rows of one function written by hand, so no test parses.
"""

from __future__ import annotations

import contextlib
import io
import sys
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
DRAFT = ["/// Source: oracle/codemp/game/g_x.c:4",
         "func G_X(_ ent: Int32) -> Int32 {",
         "    var total: Int32 = 0",
         "    total = ent * 2",
         "    return total",
         "}"]
STUB = ["/// Source: oracle/codemp/game/g_x.c:4",
        "func G_X(_ ent: Int32) -> Int32 {",
        "    // TODO: Port G_X",
        '    portMissing("G_X", source: "oracle/codemp/game/g_x.c:4")',
        "}"]


class Kept(unittest.TestCase):
    def kept(self, hand: list[str]) -> set[int]:
        from draftcheck import kept

        with contextlib.redirect_stderr(io.StringIO()):
            return kept(hand, [("G_X", ROWS)])

    def test_a_stub_body_and_a_same_body_are_not_kept(self) -> None:
        self.assertEqual(self.kept(STUB), set())
        self.assertEqual(self.kept(DRAFT), set())

    def test_an_edited_body_a_hand_body_and_a_rewritten_body_are_kept(self) -> None:
        edited = DRAFT[:3] + ["    total = ent * 3"] + DRAFT[4:]
        inserted = DRAFT[:4] + ["    total += 1"] + DRAFT[4:]
        rewritten = DRAFT[:2] + ["    let a = ent", "    let b = a << 1", "    let c = b | 0", "    return c", "}"]
        for hand in (edited, inserted, rewritten):
            self.assertEqual(self.kept(hand), {4})

    def test_the_splice_keeps_a_kept_function_and_replaces_the_rest(self) -> None:
        from draftcheck import splice

        edited = DRAFT[:3] + ["    total = ent * 3"] + DRAFT[4:]
        out, origins, replaced = splice(edited, DRAFT, {4})
        self.assertEqual((out, replaced), (edited, 0))
        self.assertTrue(all(origin is None for origin in origins))
        out, _, replaced = splice(STUB, DRAFT, set())
        self.assertEqual((out, replaced), (DRAFT, 1))


if __name__ == "__main__":
    unittest.main()
