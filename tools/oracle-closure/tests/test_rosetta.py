"""The folders of the type stones: the default unit writes at the root of `.claude/rosetta/`, and a run deletes the old stones of its own folder only."""

from __future__ import annotations

import sys
import tempfile
import unittest
from pathlib import Path
from types import SimpleNamespace
from unittest import mock

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

import rosetta  # noqa: E402


class Folders(unittest.TestCase):
    def test_the_default_unit_writes_at_the_root_of_the_stones(self) -> None:
        # given a command line with no --unit, so the run reads the game
        # then the stones go to the root folder, as the manifests of the game do
        self.assertEqual(rosetta.OUT, rosetta.REPO / ".claude" / "rosetta")

    def test_a_run_deletes_the_old_stones_of_its_own_folder_only(self) -> None:
        folder = tempfile.TemporaryDirectory()
        self.addCleanup(folder.cleanup)
        root = Path(folder.name)

        # given an old stone at the root and the index of the ui in its own folder
        (root / "old_t.md").write_text("old\n")
        (root / "mp-ui").mkdir()
        (root / "mp-ui" / "index.md").write_text("ui\n")
        stone = rosetta.Rosetta.__new__(rosetta.Rosetta)
        stone.gen = SimpleNamespace(views={})
        stone.index = lambda: ["# The type stone"]

        # when the default unit writes its stones
        with mock.patch.object(rosetta, "OUT", root):
            self.assertEqual(stone.write(), (0, 0))

        # then the old stone goes, and the folder of the ui stays
        self.assertFalse((root / "old_t.md").exists())
        self.assertEqual((root / "mp-ui" / "index.md").read_text(), "ui\n")
        self.assertEqual((root / "index.md").read_text(), "# The type stone\n")


if __name__ == "__main__":
    unittest.main()
