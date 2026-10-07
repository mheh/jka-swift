"""The snapshot check: two equal folders compare clean, and one changed byte fails the check."""

from __future__ import annotations

import sys
import tempfile
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

from snapshot import compare  # noqa: E402


class Check(unittest.TestCase):
    def test_equal_folders_exit_zero_and_one_changed_byte_exits_one(self) -> None:
        # given two snapshot folders with the same file
        expected, actual = tempfile.TemporaryDirectory(), tempfile.TemporaryDirectory()
        self.addCleanup(expected.cleanup)
        self.addCleanup(actual.cleanup)
        for folder in (expected, actual):
            (Path(folder.name) / "bodies").mkdir()
            (Path(folder.name) / "bodies/bg_pmove.swift").write_text("let a = 1\n")
        self.assertEqual(compare(Path(expected.name), Path(actual.name)), 0)

        # when one byte changes, then the check fails
        (Path(actual.name) / "bodies/bg_pmove.swift").write_text("let a = 2\n")
        self.assertEqual(compare(Path(expected.name), Path(actual.name)), 1)


if __name__ == "__main__":
    unittest.main()
