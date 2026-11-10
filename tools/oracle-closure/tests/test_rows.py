"""The row stride of a two-index array field, which the view spells as a Slots of rows over the C bytes."""

from __future__ import annotations

import sys
import tempfile
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

import clang.cindex as ci  # noqa: E402
from clang.cindex import CursorKind, TypeKind  # noqa: E402

from views import row_stride  # noqa: E402

SOURCE = """
typedef float vec3_t[3];
struct grid { vec3_t points[129][129]; float matrix[3][4]; };
"""
STORAGE = {TypeKind.FLOAT: "Float", TypeKind.INT: "Int32"}


class RowStride(unittest.TestCase):
    def fields(self) -> dict[str, ci.Type]:
        with tempfile.NamedTemporaryFile("w", suffix=".c", delete=False) as f:
            f.write(SOURCE)
        tu = ci.Index.create().parse(f.name, args=["-x", "c", "-std=gnu11"])
        record = next(c for c in tu.cursor.get_children() if c.kind == CursorKind.STRUCT_DECL and c.spelling == "grid")
        return {c.spelling: c.type for c in record.get_children() if c.kind == CursorKind.FIELD_DECL}

    def stride(self, t: ci.Type) -> str:
        # The row element keeps its typedef, the way the view generator reads it.
        named = t.get_named_type() if t.kind == TypeKind.ELABORATED else t
        element = named.element_type.element_type
        count = t.get_canonical().element_type.element_count
        return row_stride(element, count, lambda c: STORAGE[c.get_canonical().kind])

    def test_a_row_of_vectors_takes_three_floats_per_element(self) -> None:
        # given `vec3_t points[129][129]` of cGrid_t at cm_patch.h:115
        # then a row is 129 vectors of 3 floats, 1548 bytes
        self.assertEqual(self.stride(self.fields()["points"]), "129 * 3 * MemoryLayout<Float>.stride")

    def test_a_row_of_scalars_takes_one_scalar_per_element(self) -> None:
        # given `float matrix[3][4]`, the form of `mdxaBone_t`
        # then a row is 4 floats
        self.assertEqual(self.stride(self.fields()["matrix"]), "4 * MemoryLayout<Float>.stride")


if __name__ == "__main__":
    unittest.main()
