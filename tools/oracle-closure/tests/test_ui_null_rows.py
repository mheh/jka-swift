"""The NULL of the ui's UI_Alloc, and the NULL that a text slot or a text return carries into a `const char *` parameter."""

from __future__ import annotations

import sys
import tempfile
import unittest
from pathlib import Path
from types import SimpleNamespace
from unittest import mock

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

import clang.cindex as ci  # noqa: E402
from clang.cindex import CursorKind  # noqa: E402

import closure as C  # noqa: E402
from rulings import UNIT_RETURNS  # noqa: E402
from spelling import Facts, Types  # noqa: E402
from table import Table  # noqa: E402

SOURCE = b"""
char *list[4];
char *Maybe(void) { return 0; }
void Take(const char *name);
void Calls(void) { Take(list[1]); Take(Maybe()); Take("x"); }
"""


class AllocReturn(unittest.TestCase):
    def test_the_ui_alloc_of_the_ui_returns_an_optional_block(self) -> None:
        # given UI_Alloc in the run of the ui and in the run of the cgame
        table = Table.__new__(Table)
        cur = SimpleNamespace(spelling="UI_Alloc")

        # then the ui returns the optional block, and the cgame keeps the plain block
        with mock.patch.object(C, "UNIT", "mp-ui"):
            self.assertEqual(table.result(cur), ("UnsafeMutableRawPointer?", ""))
        with mock.patch.object(C, "UNIT", "mp-cgame"):
            self.assertEqual(table.result(cur), ("UnsafeMutableRawPointer", ""))
        self.assertEqual(UNIT_RETURNS, {"mp-ui": {"UI_Alloc": "optional_raw"}})


class NullValues(unittest.TestCase):
    def setUp(self) -> None:
        with tempfile.NamedTemporaryFile("wb", suffix=".c", delete=False) as f:
            f.write(SOURCE)
        self.tu = ci.Index.create().parse(f.name, args=["-x", "c", "-std=gnu11"])
        calls = next(c for c in self.tu.cursor.get_children() if c.spelling == "Calls" and c.is_definition())
        self.arguments = [list(n.get_arguments())[0] for n in calls.walk_preorder() if n.kind == CursorKind.CALL_EXPR and n.spelling == "Take"]
        self.table = Table.__new__(Table)
        self.table.null_slots = {("", "list")}
        self.table.null_returns = {"Maybe"}

    def test_a_null_slot_and_a_null_return_can_hold_null(self) -> None:
        # given `Take(list[1])`, `Take(Maybe())`, and `Take("x")`
        slot, call, literal = self.arguments

        # then in the ui the slot and the call can hold NULL, and the literal cannot
        with mock.patch.object(C, "UNIT", "mp-ui"):
            self.assertEqual(self.table.null_value(slot, SOURCE), "text")
            self.assertEqual(self.table.null_value(call, SOURCE), "text")
            self.assertIsNone(self.table.null_value(literal, SOURCE))

    def test_a_unit_outside_the_ruling_reads_no_text_that_can_be_null(self) -> None:
        # given the same slot and call in the game, whose callers test the text before they pass it
        slot, call, _ = self.arguments

        # then neither holds NULL there
        with mock.patch.object(C, "UNIT", "mp-game"):
            self.assertIsNone(self.table.null_value(slot, SOURCE))
            self.assertIsNone(self.table.null_value(call, SOURCE))

    def test_a_const_text_that_the_sweep_reaches_is_an_optional_text(self) -> None:
        # given the parameter of Take, reached by a text that can be NULL, by a literal NULL one hop on, and not reached
        take = next(c for c in self.tu.cursor.get_children() if c.spelling == "Take")
        param = next(take.get_arguments())

        # then a text that can be NULL makes a String?, and a literal NULL one hop on leaves a String, as before
        self.assertEqual(Types(None, None).parameter(param.type, Facts(text_null=True)).swift, "String?")
        self.assertEqual(Types(None, None).parameter(param.type, Facts(null_reaches=True)).swift, "String")
        self.assertEqual(Types(None, None).parameter(param.type, Facts()).swift, "String")


if __name__ == "__main__":
    unittest.main()
