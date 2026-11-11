"""The rows of the signature batch: a `text` row, a width pointer that takes NULL, the returns `table` and `word`, and a Bool into the word.

The width rule reads the folder of the function, so the test writes its source into a folder named `botlib`.
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
typedef float vec3_t[3];
typedef struct { int firstFrame; } animation_t;
void Log_Write(char *fmt, ...);
int PC_Evaluate(void *source, signed long int *intvalue, double *floatvalue, int integer);
animation_t *BG_AnimsetAlloc(void);
int SV_GameSystemCalls(int *args);
"""


def functions() -> dict[str, ci.Cursor]:
    folder = Path(tempfile.mkdtemp()) / "botlib"
    folder.mkdir()
    path = folder / "rows.c"
    path.write_text(SOURCE)
    tu = ci.Index.create().parse(str(path), args=["-x", "c", "-std=gnu11"])
    return {c.spelling: c for c in tu.cursor.get_children() if c.kind == CursorKind.FUNCTION_DECL}


class Views:
    """The two questions the return of a record table asks of the views, with the view name of `animation_t`."""

    @staticmethod
    def record_name(t: ci.Type) -> str:
        return t.get_canonical().spelling.replace("const ", "")

    @staticmethod
    def qualified_view(record: str, target: str) -> str:
        return "JKAMP.Animation" if record == "animation_t" else record


def table():
    """A Table with no sweep, whose fact sets are empty, so a parameter takes its rows and its C type only."""
    import table as T

    t = T.Table.__new__(T.Table)
    t.types = Types(None, None)
    t.views = Views()
    t.null_returns = set()
    for facts in ("nullable", "hopped", "readonly_text", "indexed_params", "stores_through", "null_arms", "store_swept", "array_handoffs"):
        setattr(t, facts, set())
    return t


class SignatureRows(unittest.TestCase):
    def setUp(self) -> None:
        self.functions = functions()

    def argument(self, function: str, name: str) -> ci.Cursor:
        return next(p for p in self.functions[function].get_arguments() if p.spelling == name)

    def test_a_text_row_makes_a_char_pointer_a_string(self) -> None:
        # given `char *fmt` of Log_Write at l_log.cpp:96 and a `text` row
        answer = Types(None, None).parameter(self.argument("Log_Write", "fmt").type, Facts(traps=False, ruled="text"))

        # then the parameter is a String, the form of a format that the text sweep reads
        self.assertIsNotNone(answer)
        self.assertEqual((answer.swift, answer.kind), ("String", "cstring"))

    def test_a_width_pointer_that_a_caller_skips_with_null_is_the_optional_pointer(self) -> None:
        # given `signed long int *intvalue` of PC_Evaluate at l_precomp.cpp:2184, which a caller hands NULL
        t = table()
        t.nullable = {("PC_Evaluate", "intvalue")}
        param = t.param(self.argument("PC_Evaluate", "intvalue"), None, traps=False, owner="PC_Evaluate")

        # then the parameter is the pointer itself at the width of WinDed, so `nil` has a seat
        self.assertEqual((param.swift, param.kind), ("UnsafeMutablePointer<Int32>?", "bare"))

    def test_a_width_pointer_with_no_null_stays_inout(self) -> None:
        # given the same parameter with no NULL from a caller
        param = table().param(self.argument("PC_Evaluate", "intvalue"), None, traps=False, owner="PC_Evaluate")

        # then the parameter is the scalar, inout
        self.assertEqual((param.swift, param.kind), ("inout Int32", "out_scalar"))

    def test_a_table_return_is_the_slots_of_its_records(self) -> None:
        # given the RETURNS row `table` of BG_AnimsetAlloc at bg_panimate.c:1729
        # then the return is the Slots over the records of the table
        self.assertEqual(table().result(self.functions["BG_AnimsetAlloc"]), ("Slots<JKAMP.Animation>", ""))

    def test_the_dispatcher_of_the_game_returns_the_word(self) -> None:
        # given the RETURNS row `word` of SV_GameSystemCalls at sv_game.cpp:458
        # then the return is the pointer-wide word
        self.assertEqual(table().result(self.functions["SV_GameSystemCalls"]), ("Int", ""))

    def test_a_bool_into_the_word_folds_to_a_number(self) -> None:
        # given a Bool value that Raven returns from SV_GameSystemCalls, `CM_AreasConnected(...)` at sv_game.cpp:628
        t = self.argument("SV_GameSystemCalls", "args").type
        answer = Types(None, None).crossing(t, "Int", Facts(is_bool=True))

        # then the value folds to a number, the form of a Bool into an Int32
        self.assertEqual(answer.kind, "bool_to_number")


if __name__ == "__main__":
    unittest.main()
