"""The text of a cursor into a `String?` parameter, and a `String?` parameter in overload_fits."""

from __future__ import annotations

import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

from draft_calls import Calls  # noqa: E402


class CursorText(unittest.TestCase):
    def test_a_cursor_crosses_as_its_text_into_a_string_or_an_optional_string(self) -> None:
        # given the parameter shapes a cursor argument can meet
        calls = Calls.__new__(Calls)

        # then a String, a String?, a variadic, and no parameter take the text, and a cursor parameter does not
        self.assertTrue(calls.takes_cursor_text(("name", "String")))
        self.assertTrue(calls.takes_cursor_text(("name", "String?")))
        self.assertTrue(calls.takes_cursor_text(("args", "any JKAShared.FormatArg...")))
        self.assertTrue(calls.takes_cursor_text(None))
        self.assertFalse(calls.takes_cursor_text(("p", "inout JKAShared.TextCursor")))


class OverloadFits(unittest.TestCase):
    def test_an_optional_string_parameter_takes_a_string_and_no_buffer(self) -> None:
        # given an overload with a CharBuf at position 0 and a String? at position 1
        calls = Calls.__new__(Calls)
        params = [("a", "inout JKAShared.CharBuf"), ("b", "String?")]

        # then a String at position 1 fits, and a CharBuf there does not
        calls.call_kinds = {1: "String"}
        self.assertTrue(calls.overload_fits(params, 0))
        calls.call_kinds = {1: "CharBuf"}
        self.assertFalse(calls.overload_fits(params, 0))


if __name__ == "__main__":
    unittest.main()
