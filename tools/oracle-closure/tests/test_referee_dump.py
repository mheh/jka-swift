"""The dump block of `referee.py` in the form of the fork and in the form of the Swift host, which ends a line after each Com_Printf call."""

from __future__ import annotations

import queue
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "referee"))

import referee  # noqa: E402

FORK = ["REF DUMP BEGIN n=7",
        "REF E 12 00ffa0b1",
        "REF P 0 0102",
        "REF DUMP END"]

SWIFT = ["REF DUMP BEGIN n=7", "",
         "REF E 12 ", "00ff", "a0b1", "", "",
         "REF P 0 ", "0102", "", "",
         "REF DUMP END", ""]


def side(lines: list[str]) -> referee.ServerProc:
    """A server side with no process, whose queue holds the lines of one block."""
    proc = referee.ServerProc.__new__(referee.ServerProc)
    proc.name = "test"
    proc.q = queue.Queue()
    proc.recent = []
    for line in lines:
        proc.q.put(line)
    return proc


class DumpBlock(unittest.TestCase):
    def test_the_swift_form_gives_the_bytes_of_the_fork_form(self) -> None:
        # given one dump in the form of the fork and the same dump in the form of the Swift host
        fork = side(FORK).collect_block("DUMP END", 1.0, begin_prefix="DUMP BEGIN", join=True)
        swift = side(SWIFT).collect_block("DUMP END", 1.0, begin_prefix="DUMP BEGIN", join=True)

        # then the parser reads the same frame and the same bytes from both
        self.assertEqual(referee.parse_dump(swift), referee.parse_dump(fork))
        self.assertEqual(referee.parse_dump(fork), {"frame": 7, "E": {12: bytes.fromhex("00ffa0b1")}, "P": {0: bytes.fromhex("0102")}})

    def test_a_block_without_the_join_drops_a_line_with_no_mark(self) -> None:
        # given a trace block with a line of hex and no REF mark
        lines = ["REF T 1 IN 0", "00ff", "REF TRACE END"]

        # then the collect keeps the marked lines alone, as before the join
        self.assertEqual(side(lines).collect_block("TRACE END", 1.0), ["T 1 IN 0", "TRACE END"])


if __name__ == "__main__":
    unittest.main()
