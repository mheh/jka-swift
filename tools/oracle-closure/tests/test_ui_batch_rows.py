"""The hand traps of HAND_TRAPS, the bg writes of another unit and the literal of a written bg table, and the `String?` slots of a NULL store."""

from __future__ import annotations

import sys
import tempfile
import unittest
from collections import Counter
from pathlib import Path
from types import SimpleNamespace
from unittest import mock

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

import clang.cindex as ci  # noqa: E402
from clang.cindex import CursorKind  # noqa: E402

import channel  # noqa: E402
import closure as C  # noqa: E402
import skeleton  # noqa: E402
import traps  # noqa: E402
from rulings import HAND_TRAPS  # noqa: E402
from skeleton import Skeleton, Variable  # noqa: E402
from spelling import Facts, Types, text_slot  # noqa: E402
from table import Table  # noqa: E402

SLOTS = b"""
#define NULL ((void *)0)
char *names[4];
char *other[4];
char *direct[4];
char buf[4];
void Fill(char *list[4]) { int n = 0; list[n] = NULL; }
void Caller(void) { Fill(names); }
void Plain(char *list[4]) { list[0] = "a"; }
void Caller2(void) { Plain(other); }
void Direct(void) { direct[1] = NULL; }
void Bytes(void) { buf[0] = 0; }
void Chars(void) { other[1][0] = 0; }
"""

TABLE = "int cost[2][3] = //c\r\n{\r\n\t{\t0,\t1,\t2\t},\t// one\r\n\t{\t3,\t4,\t5\t}\t// two\r\n};\r\n"


def parse(source: bytes, suffix: str = ".c") -> tuple[ci.TranslationUnit, bytes]:
    with tempfile.NamedTemporaryFile("wb", suffix=suffix, delete=False) as f:
        f.write(source)
    return ci.Index.create().parse(f.name, args=["-x", "c", "-std=gnu11"]), source


def functions(tu: ci.TranslationUnit) -> dict[str, ci.Cursor]:
    return {c.spelling: c for c in tu.cursor.get_children() if c.kind == CursorKind.FUNCTION_DECL and c.is_definition()}


class NullSlots(unittest.TestCase):
    def setUp(self) -> None:
        self.tu, self.data = parse(SLOTS)
        self.functions = functions(self.tu)

    def test_a_null_store_into_a_parameter_slot_names_the_parameter(self) -> None:
        # given `list[n] = NULL` in Fill and `list[0] = "a"` in Plain
        # then Fill's parameter holds a NULL slot, and Plain's does not
        self.assertEqual(Table.null_slot_stores(self.functions["Fill"], self.data), {("Fill", "list")})
        self.assertEqual(Table.null_slot_stores(self.functions["Plain"], self.data), set())

    def test_a_null_store_into_a_file_scope_array_names_the_array(self) -> None:
        # given `direct[1] = NULL` and the `char` store `buf[0] = 0`
        # then the array of texts holds a NULL slot, and the character buffer is no array of texts
        self.assertEqual(Table.null_slot_stores(self.functions["Direct"], self.data), {("", "direct")})
        self.assertEqual(Table.null_slot_stores(self.functions["Bytes"], self.data), set())

    def test_a_store_into_one_character_of_a_text_is_no_null_slot(self) -> None:
        # given `other[1][0] = 0`, the form of `com_consoleLines[i][0] = 0` of common.cpp:432
        # then the slot stays a text
        self.assertEqual(Table.null_slot_stores(self.functions["Chars"], self.data), set())

    def test_a_caller_array_handed_to_a_null_slot_parameter_holds_null_slots(self) -> None:
        # given Caller hands `names` to Fill, and Caller2 hands `other` to Plain
        slots = {("Fill", "list")}

        # then `names` holds NULL slots, and `other` does not
        self.assertEqual(Table.null_slot_handoffs(self.functions["Caller"], slots), {("", "names")})
        self.assertEqual(Table.null_slot_handoffs(self.functions["Caller2"], slots), set())

    def test_the_element_of_a_null_slot_array_is_an_optional_text(self) -> None:
        # given the parameter of Fill with and without the slot fact
        param = next(self.functions["Fill"].get_arguments())

        # then the slice holds optional texts when a body stores NULL, and texts when not
        self.assertEqual(text_slot(True), "String?")
        self.assertEqual(text_slot(False), "String")
        ruled = Types(None, None).parameter(param.type, Facts(ruled="string_slice", null_slots=True))
        self.assertEqual(ruled.swift, "inout ArraySlice<String?>")
        plain = Types(None, None).parameter(param.type, Facts(ruled="string_slice"))
        self.assertEqual(plain.swift, "inout ArraySlice<String>")


def variable(name: str, stem: str, written: bool = False, data: bool = False, swift: str | None = None,
             cur: object | None = None) -> Variable:
    var = Variable.__new__(Variable)
    var.name, var.stem, var.reason, var.written, var.data, var.walk = name, stem, None, written, data, None
    var.static, var.shared, var.const, var.local, var.suffixed = False, False, False, (), False
    var.swift = swift
    var.cur = cur if cur is not None else SimpleNamespace(
        type=SimpleNamespace(is_const_qualified=lambda: False, get_canonical=lambda: SimpleNamespace(kind=None)),
        location=SimpleNamespace(file=SimpleNamespace(name=str(C.ORACLE / "codemp" / "game" / f"{stem}.c"))))
    return var


class BgWrites(unittest.TestCase):
    def test_the_game_run_reads_the_writes_of_the_ui(self) -> None:
        # given a variable of bg_misc.c in the game run
        gen = Skeleton.__new__(Skeleton)
        names = {"bgForcePowerCost": [variable("bgForcePowerCost", "bg_misc")]}

        # then the ui is a unit beside the two parses whose build compiles the file
        self.assertIn("mp-ui", gen.consumer_units(names))
        self.assertNotIn(C.UNIT, gen.consumer_units(names))
        self.assertNotIn(C.OTHER_UNIT, gen.consumer_units(names))

    def test_a_write_of_another_unit_marks_the_variable_of_its_own_file(self) -> None:
        # given two bg files that declare a variable of one name, and a write that reaches the copy of bg_misc.c
        gen = Skeleton.__new__(Skeleton)
        misc, saga = variable("x", "bg_misc"), variable("x", "bg_saga")
        with mock.patch.object(skeleton, "root_var", lambda lvalue: ("x", "codemp/game/bg_misc.c:174")):
            gen.note_write(None, {"x": [misc, saga]}, own_file=True)
            # an element that a call takes by value is a read
            element = variable("y", "bg_misc", cur=SimpleNamespace(
                type=SimpleNamespace(is_const_qualified=lambda: False, get_canonical=lambda: SimpleNamespace(kind=ci.TypeKind.CONSTANTARRAY)),
                location=None))
            value = SimpleNamespace(type=SimpleNamespace(get_canonical=lambda: SimpleNamespace(kind=None)))
            gen.note_write(value, {"x": [element]}, arrays_only=True, own_file=True)

        # then only the copy of bg_misc.c is written
        self.assertTrue(misc.written)
        self.assertFalse(saga.written)
        self.assertFalse(element.written)

    def test_a_written_table_with_a_literal_stands_on_the_variables(self) -> None:
        # given a written data table with a literal and one with none
        with_literal = variable("cost", "bg_misc", written=True, data=True)
        with_literal.literal = ["[", "]"]
        without = variable("names", "bg_misc", written=True, data=True)

        # then the first is a variable of the struct, and the second keeps the hand form
        self.assertEqual(with_literal.kind, "state")
        self.assertEqual(without.kind, "state_data")


class TableLiteral(unittest.TestCase):
    def literal(self, text: str, swift: str = "[[Int32]]") -> list[str] | None:
        tu, _ = parse(text.encode())
        cur = next(c for c in tu.cursor.get_children() if c.kind == CursorKind.VAR_DECL)
        gen = Skeleton.__new__(Skeleton)
        var = variable(cur.spelling, "bg_misc", written=True, data=True, swift=swift, cur=cur)
        with mock.patch.object(Skeleton, "declaration_text", lambda self, var: text.split(";")[0]):
            return gen.table_literal(var)

    def test_a_table_of_integers_keeps_each_line_and_comment(self) -> None:
        # given Raven's two rows with a comment after the `=` and after each row
        # then the literal keeps the head comment, each row, and each comment, with brackets for braces
        self.assertEqual(self.literal(TABLE), ["[ //c", "[\t0,\t1,\t2\t],\t// one", "[\t3,\t4,\t5\t]\t// two", "]"])

    def test_a_line_inside_a_row_stands_one_level_deeper(self) -> None:
        # given a table whose rows open and close on their own lines
        rows = "int cost[2][2] =\n{\n\t{ // first\n\t\t0,\n\t\t1\n\t},\n\t{\n\t\t2,\n\t\t3\n\t}\n};\n"

        # then each value stands one level inside its row
        self.assertEqual(self.literal(rows), ["[", "[ // first", "    0,", "    1", "],", "[", "    2,", "    3", "]", "]"])

    def test_a_short_table_and_a_name_have_no_literal(self) -> None:
        # given a table with fewer rows than its bound, and a table that names a macro
        short = "int cost[3][3] = //c\n{\n\t{ 0, 1, 2 },\n\t{ 3, 4, 5 }\n};\n"
        named = "#define TWO 2\nint cost[2][3] = //c\n{\n\t{ 0, 1, TWO },\n\t{ 3, 4, 5 }\n};\n"

        # then neither has a literal, because the Swift array would hold another count or a name the bg target cannot see
        self.assertIsNone(self.literal(short))
        self.assertIsNone(self.literal(named.split("\n", 1)[1]))


class HandTraps(unittest.TestCase):
    def test_the_ui_holds_one_hand_trap_and_the_cgame_none(self) -> None:
        # given the ruling of hand traps
        # then the ui names trap_R_RegisterShaderNoMip, and the cgame trap of that name stays generated
        self.assertEqual(HAND_TRAPS["mp-ui"], {"trap_R_RegisterShaderNoMip"})
        self.assertNotIn("mp-cgame", HAND_TRAPS)

    def test_a_hand_trap_has_no_declaration_in_the_trap_file(self) -> None:
        # given a trap that the ruling names for the unit of the run
        gen = traps.Traps.__new__(traps.Traps)
        gen.counts = Counter()
        gen.source = SimpleNamespace(c_signature=lambda cur: "qhandle_t trap_X( const char *name )")
        cur = SimpleNamespace(spelling="trap_X", location=SimpleNamespace(line=151))
        with mock.patch.object(traps, "HAND_TRAPS", {C.UNIT: {"trap_X"}}):
            lines = gen.trap(cur)

        # then the file holds the Source line and Raven's text, and no function
        self.assertTrue(lines[0].startswith("/// Source: oracle/"))
        self.assertFalse(any("func " in line for line in lines))
        self.assertEqual(gen.counts["hand traps"], 1)

    def test_the_consumer_install_reads_the_syscall_file_of_the_view_target(self) -> None:
        # given a root with a stub, the typed traps, and a `Syscall+` file
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            (root / channel.LOGIC).mkdir(parents=True)
            (root / channel.LOGIC / "a.swift").write_text("")
            (root / channel.VIEWS).mkdir(parents=True, exist_ok=True)
            (root / channel.VIEWS / "Syscall+X.swift").write_text("")
            files = channel.ConsumerInstall.declaration_files(root)

        # then the file list holds the `Syscall+` file after the stubs and the typed traps
        self.assertEqual(files[-1], root / channel.VIEWS / "Syscall+X.swift")
        self.assertIn(root / channel.LOGIC / "a.swift", files)


if __name__ == "__main__":
    unittest.main()
