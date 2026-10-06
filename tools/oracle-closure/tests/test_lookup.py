"""Seam D: lookup.py sig prints the same text from the store as from the manifests.

The store must hold the signatures of the manifests on disk, so run manifest.py once before this test.
"""

from __future__ import annotations

import contextlib
import io
import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

import lookup  # noqa: E402

# A bg function, a game function with a static twin in no other file and a forward, and a file-scope variable.
NAMES = ("Pmove", "G_Damage", "pm_stopspeed")


def printed(name: str, source: str) -> tuple[int, str]:
    out = io.StringIO()
    with contextlib.redirect_stdout(out):
        status = lookup.signature(name, source=source)
    return status, out.getvalue()


class Signatures(unittest.TestCase):
    def test_sig_prints_the_same_text_from_the_store_as_from_the_manifests(self) -> None:
        for name in NAMES:
            # given the text the manifests give
            status, expected = printed(name, "manifest")
            self.assertEqual(status, 0, name)
            self.assertTrue(expected.strip(), name)

            # then the store gives the same text
            self.assertEqual(printed(name, "store"), (0, expected), name)


if __name__ == "__main__":
    unittest.main()
