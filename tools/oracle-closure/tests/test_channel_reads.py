"""The read rows of each unit and the cvar view in the `installBgChannel()` of a consumer other than the game."""

from __future__ import annotations

import sys
import unittest
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

import channel  # noqa: E402
from rulings import CGAME_READS, READS  # noqa: E402


def install(consumer: str, unit: str, defined: set[str]) -> list[str]:
    """The install text of one consumer with no parse, over the generated bg files of the tree."""
    out = channel.ConsumerInstall.__new__(channel.ConsumerInstall)
    out.consumer = consumer
    out.defined = set(defined)
    out.declarations = {name: [""] for name in defined}
    out.reads = READS[unit]
    out.counts = Counter()
    return out.install_file()


class ReadRows(unittest.TestCase):
    def test_the_read_rows_are_for_each_unit(self) -> None:
        # given the table of read rows
        # then the cgame keeps its five rows, and the game and the ui have none
        self.assertIs(READS["mp-cgame"], CGAME_READS)
        self.assertEqual(len(READS["mp-cgame"]), 5)
        self.assertEqual(READS["mp-ui"], {})
        self.assertEqual(READS["mp-game"], {})

    def test_the_ui_install_has_no_read_callback_and_no_cvar_view(self) -> None:
        # given a ui build that defines one strap function and no bg_fighterAltControl
        text = "\n".join(install("ui", "mp-ui", {"trap_FS_Read"}))

        # then the install points the strap at the function, and it writes no read callback and no cvar view
        self.assertIn("bg.straps.trap_FS_Read = { trap_FS_Read($0, $1, $2) }", text)
        self.assertNotIn("bg.callbacks.bgClientInfoInfoValid", text)
        self.assertNotIn("bg.fighterAltControl", text)

    def test_the_cgame_install_keeps_its_read_callbacks_and_its_cvar_view(self) -> None:
        # given a cgame build that defines bg_fighterAltControl
        text = "\n".join(install("cgame", "mp-cgame", {"bg_fighterAltControl"}))

        # then the install points the cvar view and reads its tables by the expressions of its rows
        self.assertIn("    bg.fighterAltControl = bg_fighterAltControl", text)
        self.assertIn("        cgs.clientinfo[Int(entityNum)].infoValid", text)


if __name__ == "__main__":
    unittest.main()
