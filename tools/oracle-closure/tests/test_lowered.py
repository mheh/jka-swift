"""Seam H: the lowered rows of a stem print the text the drafter prints.

The printer test reads line rows written by hand, and it needs no parse.
The other tests draft a stem of the real parse, so they run only with SLOW=1 in the environment.
They read and write a copy of the working store in a temporary folder, and the working store stays as it is.
"""

from __future__ import annotations

import os
import sqlite3
import sys
import tempfile
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))


class Printer(unittest.TestCase):
    def test_the_printer_indents_by_depth_joins_a_trailing_row_and_drops_the_module_qualifiers(self) -> None:
        import printer

        # given the line rows of two functions, a header row with a qualifier, a trailing comment, and one hole
        first = [(0, None, "header", 0, "/// Source: oracle/codemp/game/g_x.c:4"),
                 (1, None, "header", 0, "func G_X(_ ent: JKAMP.BgEntity) {"),
                 (2, 0, "own", 1, "var other: JKAMP.BgEntity? = nil"),
                 (3, 0, "trailing", 1, "// Raven's JKAShared.Vec3 comment"),
                 (4, 2, "frame", 1, "if true {"),
                 (5, 3, "note", 2, "// Port-note: a hole."),
                 (6, 3, "raven", 2, "// Raven wrote: x = y;"),
                 (7, 3, "marker", 2, "portMissing()"),
                 (8, 2, "frame", 1, "}"),
                 (9, None, "frame", 0, "}")]
        second = [(0, None, "header", 0, "func G_Y() {"), (1, None, "frame", 0, "}")]

        # when the printer prints them
        lines = printer.function_lines(first)
        text = printer.stem_text([first, second])

        # then the body indents four spaces a depth, the comment joins its line, and the header keeps its bytes
        self.assertEqual(lines, ["/// Source: oracle/codemp/game/g_x.c:4",
                                 "func G_X(_ ent: JKAMP.BgEntity) {",
                                 "    var other: BgEntity? = nil // Raven's Vec3 comment",
                                 "    if true {",
                                 "        // Port-note: a hole.",
                                 "        // Raven wrote: x = y;",
                                 "        portMissing()",
                                 "    }",
                                 "}"])
        # and the stem text is each function and a blank line, then the footer of one hole for each note line
        self.assertEqual(text, "\n".join(lines) + "\n\nfunc G_Y() {\n}\n\n// 1 holes\n")


@unittest.skipUnless(os.environ.get("SLOW") == "1", "slow: one parse and one draft of the real tree, run with SLOW=1")
class Lowered(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        import closure as C
        import table
        from bodies import Registry
        from skeleton import Skeleton

        # The copy of the working store keeps the base facts warm, so the sweep does not parse every fact again.
        cls.folder = tempfile.TemporaryDirectory()
        cls.store = Path(cls.folder.name) / "table.sqlite"
        if table.STORE.exists():
            with sqlite3.connect(table.STORE) as source, sqlite3.connect(cls.store) as copy:
                source.backup(copy)
        cls.sk = Skeleton(C.Parse(), path=cls.store)
        cls.registry = Registry()

    @classmethod
    def tearDownClass(cls) -> None:
        cls.sk.table.store.close()
        cls.folder.cleanup()

    def test_the_printer_prints_the_drafter_text_from_the_rows_byte_for_byte(self) -> None:
        import printer
        from bodies import Drafter, Lowering

        # given the drafter's lines of each function of bg_pmove from this run
        fns = self.sk.files["bg_pmove"]
        drafter = Drafter(self.sk, self.registry)
        expected = [drafter.draft(fn) for fn in fns]

        # when the lowering writes the rows of every function again and the printer prints each function from its rows
        lowering = Lowering(self.sk, self.registry)
        lowering.store.drop_lowered()
        printed = [printer.function_lines(lowering.lines("bg_pmove", fn.cur.spelling)) for fn in fns]

        # then each function prints the drafter's lines byte for byte, and every function was lowered from its draft
        self.assertEqual(lowering.lowered, len(fns))
        self.assertEqual(printed, expected)

    def test_a_warm_run_lowers_nothing_and_prints_the_same_text(self) -> None:
        import printer
        from bodies import Lowering

        # given a cold run that printed bg_pmove and left the rows of every function in the store
        functions = [fn.cur.spelling for fn in self.sk.files["bg_pmove"]]
        cold = Lowering(self.sk, self.registry)
        cold.store.drop_lowered()
        first = printer.stem_text([cold.lines("bg_pmove", function) for function in functions])

        # when a second run prints the stem over the same store
        warm = Lowering(self.sk, self.registry)
        text = printer.stem_text([warm.lines("bg_pmove", function) for function in functions])

        # then the first run lowered every function, the second run lowers none, and it prints the text of the first run
        self.assertEqual(cold.lowered, len(functions))
        self.assertEqual(warm.lowered, 0)
        self.assertEqual(text, first)

    def test_every_line_row_but_the_header_and_the_closing_brace_names_its_statement(self) -> None:
        from bodies import Lowering

        # given the line rows of every function of bg_pmove
        lowering = Lowering(self.sk, self.registry)
        functions = {fn.cur.spelling: lowering.lines("bg_pmove", fn.cur.spelling) for fn in self.sk.files["bg_pmove"]}

        # then a row with no statement is a header row or the function's closing brace, and the body's own rows name the body, seq 0
        for function, rows in functions.items():
            bare = [row for i, row in enumerate(rows) if row[1] is None and row[2] != "header" and i != len(rows) - 1]
            self.assertEqual(bare, [], function)
        self.assertTrue(any(row[1] == 0 for rows in functions.values() for row in rows))

if __name__ == "__main__":
    unittest.main()
