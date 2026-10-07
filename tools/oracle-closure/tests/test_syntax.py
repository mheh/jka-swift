"""Seam F: the syntax rows of a function body, its statements, its comments, and its macros, come back from the store as the sweep wrote them.

The tests parse a C snippet in a temporary folder, so they need no oracle parse.
"""

from __future__ import annotations

import sys
import tempfile
import unittest
from pathlib import Path

import clang.cindex as ci
from clang.cindex import CursorKind

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

from overlay import OVERLAY  # noqa: E402
from store import Store  # noqa: E402
from table import SourceFile, syntax_rows  # noqa: E402


class Syntax(unittest.TestCase):
    def setUp(self) -> None:
        self.folder = tempfile.TemporaryDirectory()
        self.addCleanup(self.folder.cleanup)
        self.root = Path(self.folder.name)

    def sweep(self, text: str, name: str) -> Store:
        """Parse the snippet, sweep the syntax rows of one function, and save them in a new store."""
        path = self.root / "g_snippet.c"
        path.write_text(text)
        tu = ci.Index.create().parse(str(path), args=["-x", "c", "-std=gnu11"], options=ci.TranslationUnit.PARSE_DETAILED_PROCESSING_RECORD)
        children = list(tu.cursor.get_children())
        fn = next(c for c in children if c.kind == CursorKind.FUNCTION_DECL and c.spelling == name and c.is_definition())
        uses = [c for c in children if c.kind == CursorKind.MACRO_INSTANTIATION and c.location.file and c.location.file.name == str(path)]
        statements, comments, macros = syntax_rows("g_snippet", fn, SourceFile(path), path.read_bytes(), uses)
        store = Store(self.root / "table.sqlite")
        self.addCleanup(store.close)
        store.save("base", "key-1", {}, {}, tables={"statements": statements, "comments": comments, "macros": macros})
        return store

    def test_the_statement_rows_of_one_function_come_back_in_preorder_with_their_text(self) -> None:
        # given a function with a declaration, an if with a block and a lone else arm, a for loop, and a return
        store = self.sweep(
            "int f(int a) {\n"
            "    int b = a;\n"
            "    if (a > 0) {\n"
            "        b++;\n"
            "    } else\n"
            "        b = 2;\n"
            "    for (int i = 0; i < 3; i++) b += i;\n"
            "    return b;\n"
            "}\n",
            "f",
        )

        # when the rows of the function come back from the store
        rows = [(r["seq"], r["parent_seq"], r["kind"], r["start_line"], r["text"]) for r in store.syntax("statements", "g_snippet", "f")]

        # then each statement node of the body is one row in preorder, with its parent and Raven's text, and no expression has a row
        self.assertEqual(rows, [
            (0, None, "COMPOUND_STMT", 1, "{\n    int b = a;\n    if (a > 0) {\n        b++;\n    } else\n        b = 2;\n"
                                          "    for (int i = 0; i < 3; i++) b += i;\n    return b;\n}"),
            (1, 0, "DECL_STMT", 2, "int b = a;"),
            (2, 0, "IF_STMT", 3, "if (a > 0) {\n        b++;\n    } else\n        b = 2"),
            (3, 2, "COMPOUND_STMT", 3, "{\n        b++;\n    }"),
            (4, 3, "UNARY_OPERATOR", 4, "b++"),
            (5, 2, "BINARY_OPERATOR", 6, "b = 2"),
            (6, 0, "FOR_STMT", 7, "for (int i = 0; i < 3; i++) b += i"),
            (7, 6, "DECL_STMT", 7, "int i = 0;"),
            (8, 6, "UNARY_OPERATOR", 7, "i++"),
            (9, 6, "COMPOUND_ASSIGNMENT_OPERATOR", 7, "b += i"),
            (10, 0, "RETURN_STMT", 8, "return b"),
        ])

    def test_a_vector_macro_call_gives_one_macro_row_with_its_text(self) -> None:
        # given Raven's vector macro under the overlay, which parses its use as a call
        store = self.sweep(
            "typedef float vec3_t[3];\ntypedef int qboolean;\ntypedef int forcePowers_t;\n"
            "#define VectorCopy(a,b) ((b)[0]=(a)[0],(b)[1]=(a)[1],(b)[2]=(a)[2])\n"
            + OVERLAY
            + "void f(vec3_t a, vec3_t b) {\n"
            "    VectorCopy(a, b);\n"
            "}\n",
            "f",
        )

        # when the macro rows of the function come back from the store
        rows = [(r["seq"], r["name"], r["text"], r["kind"]) for r in store.syntax("macros", "g_snippet", "f")]

        # then the one use is one row beside its statement, with the text as Raven wrote it
        self.assertEqual(rows, [(1, "VectorCopy", "VectorCopy(a, b)", "function")])


if __name__ == "__main__":
    unittest.main()
