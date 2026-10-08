"""Seam H: the lowered rows of a stem print the text the drafter prints.

The printer test reads line rows written by hand, and it needs no parse.
The other tests draft a stem of the real parse, so they run only with SLOW=1 in the environment.
They read and write a copy of the working store in a temporary folder, and the working store stays as it is.
"""

from __future__ import annotations

import os
import sqlite3
import subprocess
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


    def test_a_compile_hole_takes_the_deeper_loop_step_inside_its_statement(self) -> None:
        import printer

        # given a loop whose `if` holds the loop step before its `continue`, and a rejected row for the `if`, seq 2
        rows = [(0, None, "header", 0, "/// Source: oracle/codemp/game/g_x.c:4"),
                (1, None, "header", 0, "func G_X() {"),
                (2, 1, "own", 1, "while i < 4 {"),
                (3, 2, "own", 2, "if skip {"),
                (4, 4, "own", 3, "i += 1"),
                (5, 3, "own", 3, "continue"),
                (6, 2, "frame", 2, "}"),
                (7, 4, "own", 2, "i += 1"),
                (8, 1, "frame", 1, "}"),
                (9, None, "frame", 0, "}")]
        statements = [{"seq": 0, "parent_seq": None, "text": "{ }"},
                      {"seq": 1, "parent_seq": 0, "text": "while ( i < 4 ) { }"},
                      {"seq": 2, "parent_seq": 1, "text": "if ( skip ) {\n\t\tcontinue;\n\t}"},
                      {"seq": 3, "parent_seq": 2, "text": "continue"},
                      {"seq": 4, "parent_seq": 1, "text": "i++"}]

        # when the printer prints the function with the `if` as a compile hole
        lines = printer.function_lines(printer.holed(rows, statements, {2: "boom"}, "G_X"))

        # then the three lines of the hole stand in the place of the whole `if`, the step inside it included
        self.assertEqual(lines, ["/// Source: oracle/codemp/game/g_x.c:4",
                                 "func G_X() {",
                                 "    while i < 4 {",
                                 '        // Port-note: The draft of this statement did not compile, and the compiler wrote "boom".',
                                 "        // Raven wrote: if ( skip ) { continue; }",
                                 '        portMissing("G_X", source: "oracle/codemp/game/g_x.c:4")',
                                 "        i += 1",
                                 "    }",
                                 "}"])

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

    def test_a_nested_blank_row_names_its_enclosing_statement_and_not_the_body(self) -> None:
        from bodies import LANGUAGE, Lowering

        # given the line rows of every function of bg_pmove with no label
        # The labeled path drafts its blocks with no statement mark, so a nested line there names the body, a comment line too.
        lowering = Lowering(self.sk, self.registry)
        functions = {fn.cur.spelling: lowering.lines("bg_pmove", fn.cur.spelling) for fn in self.sk.files["bg_pmove"]}
        functions = {function: rows for function, rows in functions.items()
                     if all(form != "label" for _, form, *_ in lowering.store.lowered_rows(LANGUAGE, "bg_pmove", function))}

        # when each blank row is paired with the next row of its function that holds text
        nested = []
        for function, rows in functions.items():
            for i, row in enumerate(rows):
                following = next((later for later in rows[i + 1:] if later[4]), None)
                if row[2] == "blank" and following is not None and following[3] >= 2:
                    nested.append((function, row))

        # then a blank row inside a nested block names a statement inside the body, and it keeps depth 0 so it prints as an empty line
        self.assertTrue(nested)
        self.assertEqual([(function, row) for function, row in nested if row[1] == 0], [])
        self.assertEqual([(function, row) for function, row in nested if row[3] != 0 or row[4]], [])

    def test_the_printer_prints_a_stem_from_a_copied_store_with_no_parse_byte_for_byte(self) -> None:
        import printer
        from bodies import Lowering

        # given the text bodies.py --stem prints for bg_pmove, and a copy of the store it wrote
        lowering = Lowering(self.sk, self.registry)
        expected = printer.stem_text([lowering.lines("bg_pmove", fn.cur.spelling) for fn in self.sk.files["bg_pmove"]])
        copied = Path(self.folder.name) / "printed.sqlite"
        with sqlite3.connect(self.store) as source, sqlite3.connect(copied) as copy:
            source.backup(copy)

        # when a process that never parses prints the stem from the copied store
        script = ("import sys; sys.path.insert(0, sys.argv[1]); import printer; from pathlib import Path; "
                  "sys.stdout.write(printer.store_text(Path(sys.argv[2]), stem='bg_pmove')); "
                  "import clang.cindex as ci; sys.exit(3 if ci.conf.loaded else 0)")
        run = subprocess.run([sys.executable, "-c", script, str(HERE), str(copied)], capture_output=True, text=True)

        # then the process loads no libclang and prints the text of bodies.py byte for byte
        self.assertEqual(run.returncode, 0, run.stderr)
        self.assertEqual(run.stdout, expected)

    def test_a_rejected_row_makes_its_statement_a_compile_hole_under_the_flag_and_not_without_it(self) -> None:
        import printer
        from bodies import LANGUAGE, Lowering

        # given the rows of PM_AddTouchEnt in a copy of the store, and a rejected row for its first `if`, seq 2, under the lowered key
        lowering = Lowering(self.sk, self.registry)
        lowering.lines("bg_pmove", "PM_AddTouchEnt")
        lowering.store.save_rejected(lowering.key, LANGUAGE, "bg_pmove", [("PM_AddTouchEnt", 2, "cannot convert value")])
        copied = Path(self.folder.name) / "rejected.sqlite"
        with sqlite3.connect(self.store) as source, sqlite3.connect(copied) as copy:
            source.backup(copy)
        hole = ['    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value".',
                "    // Raven wrote: if ( entityNum == ENTITYNUM_WORLD ) { return; }",
                '    portMissing("PM_AddTouchEnt", source: "oracle/codemp/game/bg_pmove.c:924")']

        # when the printer and bodies.py print the function without the flag and with it
        plain = printer.store_text(copied, only=["PM_AddTouchEnt"]).splitlines()
        holed = printer.store_text(copied, only=["PM_AddTouchEnt"], compile_holes=True).splitlines()
        drafted = printer.function_lines(Lowering(self.sk, self.registry, compile_holes=True).lines("bg_pmove", "PM_AddTouchEnt"))

        # then without the flag the `if` prints as drafted, and no line is a compile hole
        self.assertTrue(any(line.lstrip().startswith("if ") and "ENTITYNUM_WORLD" in line for line in plain), plain)
        self.assertFalse(any("did not compile" in line for line in plain), plain)
        # and with the flag the three lines of the hole stand in the place of the `if`, in the printer and in bodies.py alike
        start = holed.index(hole[0])
        self.assertEqual(holed[start:start + 3], hole)
        self.assertFalse(any(line.lstrip().startswith("if ") and "ENTITYNUM_WORLD" in line for line in holed), holed)
        self.assertEqual(len(holed), len(plain))
        self.assertEqual(drafted, holed[:-2])

if __name__ == "__main__":
    unittest.main()
