"""The PARAMS kind `string_slots`, which spells a `char *x[]` table whose slots can hold NULL as the caller's Slots of optional texts."""

from __future__ import annotations

import sys
import tempfile
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

import clang.cindex as ci  # noqa: E402
from clang.cindex import CursorKind  # noqa: E402

from spelling import Facts, Types  # noqa: E402

SOURCE = """
char *AAS_StringFromIndex(char *indexname, char *stringindex[], int numindexes, int index);
"""


class StringSlots(unittest.TestCase):
    def parameters(self) -> dict[str, ci.Type]:
        with tempfile.NamedTemporaryFile("w", suffix=".c", delete=False) as f:
            f.write(SOURCE)
        tu = ci.Index.create().parse(f.name, args=["-x", "c", "-std=gnu11"])
        fn = next(c for c in tu.cursor.get_children() if c.kind == CursorKind.FUNCTION_DECL)
        return {p.spelling: p.type for p in fn.get_arguments()}

    def test_a_ruled_string_table_is_a_slots_of_optional_texts(self) -> None:
        # given `char *stringindex[]` of AAS_StringFromIndex at be_aas_main.cpp:56 and a `string_slots` row
        # then the parameter is the caller's Slots of optional texts
        answer = Types(None, None).parameter(self.parameters()["stringindex"], Facts(ruled="string_slots"))
        self.assertIsNotNone(answer)
        self.assertEqual(answer.swift, "Slots<String?>")
        self.assertEqual(answer.kind, "slots")

    def test_the_kind_does_not_shape_a_single_text(self) -> None:
        # given `char *indexname` with the same row
        # then the kind gives no Slots, because the parameter is not a table of texts
        answer = Types(None, None).parameter(self.parameters()["indexname"], Facts(ruled="string_slots"))
        self.assertTrue(answer is None or answer.swift != "Slots<String?>")


if __name__ == "__main__":
    unittest.main()
