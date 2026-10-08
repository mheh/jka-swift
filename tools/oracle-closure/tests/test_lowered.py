"""Seam H: the lowered rows of a stem print the text the drafter prints.

This test drafts a stem of the real parse, so it runs only with SLOW=1 in the environment.
The tests read and write a copy of the working store in a temporary folder, and the working store stays as it is.
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
        cls.sk = Skeleton(C.Parse(), store=cls.store)
        cls.registry = Registry()

    @classmethod
    def tearDownClass(cls) -> None:
        cls.sk.table.store.close()
        cls.folder.cleanup()

    def test_the_printer_prints_the_drafter_text_from_the_rows_byte_for_byte(self) -> None:
        from bodies import Drafter, Lowering, printed, stem_text

        # given the drafter's text of bg_pmove from this run
        fns = self.sk.files["bg_pmove"]
        expected = printed(Drafter(self.sk, self.registry), fns)

        # when the lowering writes the rows of every function again and the text is printed from the rows
        lowering = Lowering(self.sk, self.registry)
        lowering.store.drop_lowered()
        text = stem_text(lowering, [("bg_pmove", fn.cur.spelling) for fn in fns])

        # then the text is the drafter's text byte for byte, and every function was lowered from its draft
        self.assertEqual(lowering.lowered, len(fns))
        self.assertEqual(text, expected)

    def test_a_warm_run_lowers_nothing_and_prints_the_same_text(self) -> None:
        from bodies import Lowering, stem_text

        # given a run that printed bg_pmove and left the rows of every function in the store
        functions = [("bg_pmove", fn.cur.spelling) for fn in self.sk.files["bg_pmove"]]
        first = stem_text(Lowering(self.sk, self.registry), functions)

        # when a second run prints the stem over the same store
        warm = Lowering(self.sk, self.registry)
        text = stem_text(warm, functions)

        # then the second run lowers no function and prints the text of the first run
        self.assertEqual(warm.lowered, 0)
        self.assertEqual(text, first)


if __name__ == "__main__":
    unittest.main()
