"""The access that Raven's linkage gives, the relative include of a per-module copy, and the link name of the host's BSTable."""

from __future__ import annotations

import sys
import tempfile
import unittest
from pathlib import Path
from types import SimpleNamespace
from unittest import mock

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

import closure as C  # noqa: E402
import merge  # noqa: E402
import skeleton  # noqa: E402
import tables  # noqa: E402
from skeleton import Skeleton, Variable  # noqa: E402


def generator(shared: set[str] = frozenset(), stored: set[str] = frozenset(), shared_public: set[str] = frozenset()) -> Skeleton:
    """A skeleton with the name sets of the access rule alone, and no parse."""
    gen = Skeleton.__new__(Skeleton)
    gen.shared_names = set(shared)
    gen.stored_names = set(stored)
    gen.shared_public = set(shared_public)
    gen._internal = {"JKAMP_GameLogic": {"SpawnRow"}, "JKAMP_BG": set()}
    return gen


def function(name: str, stem: str, static: bool = False, returns: str | None = None) -> SimpleNamespace:
    return SimpleNamespace(name=name, stem=stem, static=static, params=[], returns=returns)


def variable(name: str, kind: str = "state", static: bool = False, shared: bool = False, const: bool = False,
             local: tuple[str, ...] = ()) -> Variable:
    var = Variable.__new__(Variable)
    var.name, var.stem, var.reason, var.written, var.data, var.walk = name, "g_spawn", None, True, False, None
    var.static, var.shared, var.const, var.local, var.suffixed = static, shared, const, local, False
    var.cur, var.swift = SimpleNamespace(kind=None), "[String]"
    var.kind_override = kind
    return var


class FunctionAccess(unittest.TestCase):
    def test_a_function_without_static_is_public_in_its_target(self) -> None:
        # given a game function and a bg function that Raven declares without static
        gen = generator()

        # then each one is public
        self.assertEqual(gen.access(function("G_RunFrame", "g_main")), "public ")
        self.assertEqual(gen.access(function("PM_Accelerate", "bg_pmove")), "public ")

    def test_a_static_function_stays_private_and_a_thunk_keeps_it_internal(self) -> None:
        # given two static functions, one of which the oracle stores in a callback field
        gen = generator(stored={"target_location_linkup"})

        # then the plain one is private, and the stored one is internal for its thunk
        self.assertEqual(gen.access(function("G_FindConfigstringIndex", "g_utils", static=True)), "private ")
        self.assertEqual(gen.access(function("target_location_linkup", "g_target", static=True)), "")

    def test_a_name_that_two_files_define_stays_private(self) -> None:
        # given `Update` of SpeederNPC.c, which Raven declares without static beside four static copies
        gen = generator(shared={"Update"})

        # then the copy is private, because Swift file-scope names share one module
        self.assertEqual(gen.access(function("Update", "SpeederNPC")), "private ")

    def test_a_bg_function_with_the_name_of_a_shared_public_function_stays_internal(self) -> None:
        # given `atof` of bg_lib.c, which CString.swift of the shared module holds in public
        gen = generator(shared_public={"atof"})

        # then the bg copy is internal
        self.assertEqual(gen.access(function("atof", "bg_lib")), "")


    def test_a_stub_whose_signature_names_an_internal_type_is_internal(self) -> None:
        # given a function that Raven declares without static and that returns the internal `SpawnRow`
        gen = generator()
        fn = function("G_FindRow", "g_spawn", returns="SpawnRow?")

        # then Raven's linkage names it, and the stub keeps internal access
        self.assertEqual(gen.linkage(fn), "public ")
        self.assertEqual(gen.access(fn), "")


class GlobalAccess(unittest.TestCase):
    def setUp(self) -> None:
        self.patch = mock.patch.object(Variable, "kind", property(lambda var: var.kind_override))
        self.patch.start()

    def tearDown(self) -> None:
        self.patch.stop()

    def test_a_global_without_static_is_public(self) -> None:
        self.assertEqual(generator().variable_access(variable("spawns", kind="state_data")), "public ")

    def test_a_static_global_a_shared_global_and_a_moved_local_keep_their_access(self) -> None:
        gen = generator()
        self.assertEqual(gen.variable_access(variable("pushed_p", static=True)), "")
        self.assertEqual(gen.variable_access(variable("gametypeNames", shared=True)), "private ")
        self.assertEqual(gen.variable_access(variable("regs", local=("IsKNI",))), "")

    def test_a_forward_of_an_internal_type_keeps_its_access(self) -> None:
        var = variable("spawnTable", kind="state_data")
        var.swift = "[SpawnRow]"
        self.assertEqual(generator().variable_access(var), "")

    def test_a_let_without_const_and_a_const_let_are_public(self) -> None:
        # given a `let` of a global that Raven declares without const, and one that he declares const
        gen = generator()

        # then each one is public, because no line that the product compiles writes it
        self.assertEqual(gen.variable_access(variable("floattime", kind="let")), "public ")
        self.assertEqual(gen.variable_access(variable("bgToggleableSurfaces", kind="let", const=True)), "public ")


class KeptDeclarations(unittest.TestCase):
    def setUp(self) -> None:
        self.patch = mock.patch.object(Variable, "kind", property(lambda var: var.kind_override))
        self.patch.start()
        self.gen = generator()

    def tearDown(self) -> None:
        self.patch.stop()

    def test_a_get_only_forward_of_a_global_without_const_takes_public(self) -> None:
        # given the get-only forward of `colorTable` of cg_main.c, which Raven declares without const
        lines = ["var colorTable: [vec4_t] { world.colorTable }"]

        # then the forward takes public with no setter
        self.assertIsNone(self.gen.kept(variable("colorTable", kind="state_data"), lines, 0, set()))

    def test_a_forward_with_a_setter_and_a_forward_over_storage_take_public(self) -> None:
        lines = ["var spawns: [SpawnRow] {", "    get { world.spawns }", "    set { world.spawns = newValue }", "}"]
        self.assertIsNone(self.gen.kept(variable("spawns", kind="state_data"), lines, 0, set()))
        lines = ["var level: LevelLocals { world.storage.level }"]
        self.assertIsNone(self.gen.kept(variable("level", kind="storage"), lines, 0, set()))

    def test_a_file_scope_let_without_const_and_a_const_let_take_public(self) -> None:
        lines = ["let floattime: Float = 0"]
        self.assertIsNone(self.gen.kept(variable("floattime", kind="let"), lines, 0, set()))
        self.assertIsNone(self.gen.kept(variable("floattime", kind="let", const=True), lines, 0, set()))

    def test_a_signature_that_names_an_internal_type_is_kept(self) -> None:
        # given a function whose return type, on the last line of a wrapped head, is internal
        lines = ["func G_FindRow(", "    name: String,", "    count: Int32 = 0", ") -> SpawnRow? {", "    nil", "}"]

        # then the declaration keeps its access, and the reason names the type
        reason = self.gen.kept(None, lines, 0, {"SpawnRow"})
        self.assertEqual(reason, "its declaration names the internal type SpawnRow")

    def test_a_parameter_label_with_the_name_of_an_internal_type_is_no_type(self) -> None:
        lines = ["func G_Spawn(SpawnRow: Int32) {", "}"]
        self.assertIsNone(self.gen.kept(None, lines, 0, {"SpawnRow"}))

    def test_internal_types_are_the_types_declared_without_public(self) -> None:
        with tempfile.TemporaryDirectory() as folder:
            target = Path(folder) / "JKAMP_GameLogic"
            target.mkdir()
            (target / "g_local.swift").write_text("struct SpawnRow {\n    struct Inner {}\n}\npublic struct Row {}\nfinal class Host {}\npublic final class World {}\n")
            with mock.patch.object(C, "READ_ROOTS", [Path(folder)]):
                self.assertEqual(self.gen.internal_types("JKAMP_GameLogic"), {"SpawnRow", "Inner", "Host"})


class VariableRowText(unittest.TestCase):
    def setUp(self) -> None:
        self.patch = mock.patch.object(Variable, "kind", property(lambda var: var.kind_override))
        self.patch.start()

    def tearDown(self) -> None:
        self.patch.stop()

    def test_the_row_of_a_forward_with_a_get_and_set_block_is_its_head_line(self) -> None:
        # given the forward of `numbots` of ai_main.c, a get and set block over the variables struct
        gen = generator()
        var = variable("numbots")
        var.line = 48
        entry = ["/// Source: oracle/codemp/game/ai_main.c:48",
                 "public var numbots: Int32 {",
                 "    get { world.variables.numbots }",
                 "    set { world.variables.numbots = newValue }",
                 "}"]

        # when the row reads the entry
        with mock.patch.object(Skeleton, "variable_entry", lambda self, var, count=True: entry):
            row = gen.variable_signature(var)

        # then the text is the head line and not the closing brace
        self.assertEqual(row["text"], "public var numbots: Int32 {")

    def test_the_row_of_a_one_line_entry_is_its_last_line(self) -> None:
        gen = generator()
        var = variable("floattime", kind="let")
        var.line = 12
        entry = ["/// Source: oracle/codemp/game/g_main.c:12", "// Raven wrote: float floattime", "public let floattime: Float = 0"]
        with mock.patch.object(Skeleton, "variable_entry", lambda self, var, count=True: entry):
            self.assertEqual(gen.variable_signature(var)["text"], "public let floattime: Float = 0")


class PerModuleInclude(unittest.TestCase):
    def setUp(self) -> None:
        self.out = merge.Output(Path("unused"))
        self.out.copies.add(("CJKAMP_Game", "codemp/icarus/interpreter/enum_TK_BLOCK_START.h"))
        self.out.copies.add(("CJKAMP_CGame", "codemp/ui/ui_shared/constants.h"))

    def test_a_copy_of_the_own_target_is_named_from_the_folder_of_the_file(self) -> None:
        spelled = self.out.spelled("CJKAMP_Game", "codemp/icarus/interpreter/enum_ID_AFFECT.h", "codemp/icarus/interpreter/enum_TK_BLOCK_START.h")
        self.assertEqual(spelled, "enum_TK_BLOCK_START.h")
        spelled = self.out.spelled("CJKAMP_CGame", "codemp/cgame/cg_local/cgMedia_t.h", "codemp/ui/ui_shared/constants.h")
        self.assertEqual(spelled, "../../ui/ui_shared/constants.h")

    def test_a_file_at_the_include_root_and_a_file_that_is_no_copy_keep_the_path(self) -> None:
        self.assertEqual(self.out.spelled("CJKAMP_Game", "g_types.h", "codemp/icarus/interpreter/enum_TK_BLOCK_START.h"),
                         "codemp/icarus/interpreter/enum_TK_BLOCK_START.h")
        self.assertEqual(self.out.spelled("CJKAMP_Game", "codemp/game/g_local/gentity_s.h", "codemp/game/q_shared/vec3_t.h"),
                         "codemp/game/q_shared/vec3_t.h")
        self.assertEqual(self.out.spelled("CJKAMP_Ded", "codemp/icarus/interpreter/enum_ID_AFFECT.h", "codemp/icarus/interpreter/enum_TK_BLOCK_START.h"),
                         "codemp/icarus/interpreter/enum_TK_BLOCK_START.h")


class HostTableLinkName(unittest.TestCase):
    def test_the_host_table_carries_its_link_name_before_raven_bytes(self) -> None:
        output = next(o for o in tables.OUTPUTS if o.name == "ded_tables.c")
        text = tables.emit(output).decode("latin-1")
        line = 'extern stringID_table_t BSTable[11] __asm("_BSTable_ded");'
        self.assertIn(line + "\n// Source: oracle/codemp/icarus/GameInterface.cpp:592-606\n", text)
        game = next(o for o in tables.OUTPUTS if o.name == "g_tables.c")
        self.assertNotIn("__asm", tables.emit(game).decode("latin-1"))


if __name__ == "__main__":
    unittest.main()
