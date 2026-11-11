"""The rows of the axis batch: a store through an axis subscript and an axis that crosses by value."""

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

SOURCE = b"""
typedef float vec3_t[3];
void G_TransposeMatrix(vec3_t matrix[3], vec3_t transpose[3]) { int i, j; for (i = 0; i < 3; i++) for (j = 0; j < 3; j++) transpose[i][j] = matrix[j][i]; }
void Clear(char **argv) { argv[0][0] = 0; }
"""


def functions() -> tuple[dict[str, ci.Cursor], bytes]:
    path = Path(tempfile.mkdtemp()) / "axis.c"
    path.write_bytes(SOURCE)
    tu = ci.Index.create().parse(str(path), args=["-x", "c", "-std=gnu11"])
    return {c.spelling: c for c in tu.cursor.get_children() if c.kind == CursorKind.FUNCTION_DECL}, SOURCE


def stores(function: ci.Cursor, data: bytes) -> set[str]:
    """The parameters that the left side of each `=` of the body writes through, by `store_target`."""
    import table as T

    t = T.Table.__new__(T.Table)
    out: set[str] = set()
    for node in function.walk_preorder():
        if node.kind != CursorKind.BINARY_OPERATOR:
            continue
        kids = list(node.get_children())
        if data[kids[0].extent.end.offset:kids[1].extent.start.offset].strip() != b"=":
            continue
        target = t.store_target(t.unwrapped(kids[0]), data)
        if target is not None:
            out.add(target)
    return out


HANDOFF = b"""
typedef float vec3_t[3];
void MatrixMultiply(float in1[3][3], float in2[3][3], float out[3][3]) { out[0][0] = in1[0][0] * in2[0][0]; }
void Tag(vec3_t axis[3]) { float m[3][3]; MatrixMultiply(m, m, axis); }
void Read(vec3_t axis[3]) { float m[3][3]; MatrixMultiply(axis, m, m); }
"""


def handoff_stores() -> set[tuple[str, str]]:
    """The written parameters of the store sweep over one file, with no NULL fact and no adopted stub."""
    import table as T

    folder = Path(tempfile.mkdtemp())
    path = folder / "handoff.c"
    path.write_bytes(HANDOFF)
    tu = ci.Index.create().parse(str(path), args=["-x", "c", "-std=gnu11"])
    t = T.Table.__new__(T.Table)
    t.nullable, t.hopped, t.stores_through = set(), set(), set()
    t.sweep_stores(tu, path.resolve().parent)
    return t.stores_through


class AxisRows(unittest.TestCase):
    def setUp(self) -> None:
        self.functions, self.data = functions()

    def argument(self, function: str, name: str) -> ci.Cursor:
        return next(p for p in self.functions[function].get_arguments() if p.spelling == name)

    def test_a_store_through_an_axis_subscript_writes_the_axis(self) -> None:
        # given `transpose[i][j] = matrix[j][i]` of g_mover.c:132
        # then the store writes `transpose` and not `matrix`
        self.assertEqual(stores(self.functions["G_TransposeMatrix"], self.data), {"transpose"})

    def test_a_store_through_a_pointer_of_pointers_is_no_axis_store(self) -> None:
        # given `argv[0][0] = 0` through a `char **`
        # then the store sweep keeps its old answer for the parameter
        self.assertEqual(stores(self.functions["Clear"], self.data), set())

    def test_an_axis_handed_to_a_written_array_of_arrays_is_written(self) -> None:
        # given `MatrixMultiply( orientation.axis, model->axis, axis )` of cg_players.c:5454, and `float out[3][3]` of q_math.c:1293
        written = handoff_stores()

        # then the axis handed to `out` is written, and the axis handed to `in1` is not
        self.assertIn(("Tag", "axis"), written)
        self.assertIn(("MatrixMultiply", "out"), written)
        self.assertNotIn(("Read", "axis"), written)

    def test_an_axis_the_body_never_writes_crosses_by_value(self) -> None:
        # given `vec3_t matrix[3]` of G_TransposeMatrix, which the store sweep walked and saw no write through
        t = self.argument("G_TransposeMatrix", "matrix").type
        answer = Types(None, None).parameter(t, Facts(traps=False, store_swept=True))

        # then the axis is the caller's array by value
        self.assertIsNotNone(answer)
        self.assertEqual((answer.swift, answer.kind), ("[JKAShared.vec3_t]", "bare"))

    def test_an_axis_the_body_writes_stays_inout(self) -> None:
        # given `vec3_t transpose[3]` of G_TransposeMatrix, which the body writes
        t = self.argument("G_TransposeMatrix", "transpose").type
        answer = Types(None, None).parameter(t, Facts(traps=False, store_swept=True, stores_through=True))

        # then the axis is the caller's array, inout
        self.assertIsNotNone(answer)
        self.assertEqual((answer.swift, answer.kind), ("inout [JKAShared.vec3_t]", "vec3_axis"))

    def test_an_axis_of_a_body_the_sweep_never_walked_stays_inout(self) -> None:
        # given an axis of a function outside the folder of the store sweep
        t = self.argument("G_TransposeMatrix", "matrix").type
        answer = Types(None, None).parameter(t, Facts(traps=False))

        # then no proof of a read-only body exists, and the axis stays inout
        self.assertIsNotNone(answer)
        self.assertEqual((answer.swift, answer.kind), ("inout [JKAShared.vec3_t]", "vec3_axis"))


if __name__ == "__main__":
    unittest.main()
