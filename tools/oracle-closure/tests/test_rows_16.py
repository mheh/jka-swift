"""The rows S1, S2, and S4: a `char **` byte buffer, a `void *` class return, and the PARAMS key of a closure parameter.

The callback of CM_CircularIterate takes a `float` in place of Raven's `byte *` at cm_terrain.cpp:1067,
because a Table with no sweep spells no unnamed `byte *`, and the test reads only the label of the third parameter.
"""

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
typedef unsigned char byte;
int G2_SaveGhoul2Models(void *ghoul2, char **buffer, int *size);
void *G2_GetGoreRecord(int tag);
void CM_DrawDebugSurface(void (*drawPoly)(int color, int numPoints, float *points));
void CM_CircularIterate(byte *data, int *user, void (*callback)(float, float, int *));
"""


def functions() -> dict[str, ci.Cursor]:
    with tempfile.NamedTemporaryFile("w", suffix=".c", delete=False) as f:
        f.write(SOURCE)
    tu = ci.Index.create().parse(f.name, args=["-x", "c", "-std=gnu11"])
    return {c.spelling: c for c in tu.cursor.get_children() if c.kind == CursorKind.FUNCTION_DECL}


def table():
    """A Table with no sweep, whose fact sets are empty, so a parameter takes its rows and its C type only."""
    import table as T

    t = T.Table.__new__(T.Table)
    t.types = Types(None, None)
    for facts in ("nullable", "hopped", "readonly_text", "indexed_params", "stores_through", "null_arms", "store_swept", "array_handoffs", "null_slots", "text_nulls"):
        setattr(t, facts, set())
    return t


class Rows16(unittest.TestCase):
    def setUp(self) -> None:
        self.functions = functions()

    def argument(self, function: str, name: str) -> ci.Cursor:
        return next(p for p in self.functions[function].get_arguments() if p.spelling == name)

    def test_a_ruled_char_double_pointer_is_an_optional_slots_of_bytes(self) -> None:
        # given `char **buffer` of G2_SaveGhoul2Models at G2_misc.cpp:1719 and a `bytes` row
        # then the parameter is the caller's optional Slots of bytes, inout
        answer = Types(None, None).parameter(self.argument("G2_SaveGhoul2Models", "buffer").type, Facts(ruled="bytes"))
        self.assertIsNotNone(answer)
        self.assertEqual((answer.swift, answer.kind), ("inout Slots<JKAShared.byte>?", "out_opaque"))

    def test_a_ruled_float_table_is_a_slots_of_vectors(self) -> None:
        # given `float *points` of the `drawPoly` closure and a `table` row
        # then the parameter is the Slots of vectors
        drawPoly = self.argument("CM_DrawDebugSurface", "drawPoly")
        points = next(c for c in drawPoly.get_children() if c.kind == CursorKind.PARM_DECL and c.spelling == "points")
        answer = Types(None, None).parameter(points.type, Facts(ruled="table"))
        self.assertIsNotNone(answer)
        self.assertEqual((answer.swift, answer.kind), ("Slots<JKAShared.vec3_t>", "slots"))

    def test_a_void_pointer_return_of_a_named_class_is_that_class_optional(self) -> None:
        # given the RETURNS row ("class_ref", "GoreTextureCoordinates") of G2_GetGoreRecord
        # then the return is the hand Swift class, optional, with no crossing
        self.assertEqual(table().result(self.functions["G2_GetGoreRecord"]), ("GoreTextureCoordinates?", ""))

    def test_a_closure_parameter_takes_the_row_of_its_function_and_parameter(self) -> None:
        # given the rows ("CM_DrawDebugSurface.drawPoly", "points") and ("CM_CircularIterate.callback", "p2")
        t = table()
        drawPoly = t.param(self.argument("CM_DrawDebugSurface", "drawPoly"), None, traps=False, owner="CM_DrawDebugSurface")
        callback = t.param(self.argument("CM_CircularIterate", "callback"), None, traps=False, owner="CM_CircularIterate")

        # then the named prototype parameter and the unnamed one at label `p2` take their rows
        self.assertEqual(drawPoly.swift, "((Int32, Int32, Slots<JKAShared.vec3_t>) -> Void)?")
        self.assertEqual(callback.swift, "((Float, Float, Slots<Int32>) -> Void)?")

    def test_a_closure_with_no_owner_keeps_the_default_of_its_parameters(self) -> None:
        # given the same closure with no owner, the form of a caller that names no function
        drawPoly = table().closure(self.argument("CM_DrawDebugSurface", "drawPoly"), "drawPoly")

        # then no row reaches the prototype parameter, and the `float *` keeps its default
        self.assertNotIn("Slots<JKAShared.vec3_t>", drawPoly.swift)


if __name__ == "__main__":
    unittest.main()
