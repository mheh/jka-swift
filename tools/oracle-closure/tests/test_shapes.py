"""The shape rules of the drafter, each shown on a function of the real parse that holds the shape.

This test drafts functions of the real parse, so it runs only with SLOW=1 in the environment.
The test reads a copy of the working store in a temporary folder, and the working store stays as it is.
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


@unittest.skipUnless(os.environ.get("SLOW") == "1", "slow: one parse and the drafts of the real tree, run with SLOW=1")
class Shapes(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        import closure as C
        import table
        from bodies import Drafter, Registry
        from skeleton import Skeleton

        cls.folder = tempfile.TemporaryDirectory()
        store = Path(cls.folder.name) / "table.sqlite"
        if table.STORE.exists():
            with sqlite3.connect(table.STORE) as source, sqlite3.connect(store) as copy:
                source.backup(copy)
        cls.sk = Skeleton(C.Parse(), path=store)
        cls.drafter = Drafter(cls.sk, Registry())

    @classmethod
    def tearDownClass(cls) -> None:
        cls.sk.table.store.close()
        cls.folder.cleanup()

    def draft(self, name: str) -> list[str]:
        """The stripped lines of the draft of the named function."""
        return [line.strip() for line in self.drafter.draft(self.sk.by_name[name])]

    def test_a_stepped_buffer_parameter_walks_a_write_cursor_declared_at_the_head(self) -> None:
        # given COM_SkipPath, which steps and reads its `char *pathname` parameter
        lines = self.draft("COM_SkipPath")

        # then the index stands at the head, and the reads and the step go through it
        self.assertIn("var pathnameIndex: Int32 = 0", lines)
        self.assertIn("while pathname[pathnameIndex] != 0 {", lines)
        self.assertIn("pathnameIndex += 1", lines)

        # and a call before the first step takes the buffer itself
        self.assertIn("if strlen(s) >= MAX_INFO_STRING {", self.draft("Info_RemoveKey"))


if __name__ == "__main__":
    unittest.main()
